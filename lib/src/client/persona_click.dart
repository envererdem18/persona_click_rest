import 'dart:async';

import 'package:persona_click_rest/src/client/api_client.dart';
import 'package:persona_click_rest/src/models/events.dart';
import 'package:persona_click_rest/src/models/init_response.dart';
import 'package:persona_click_rest/src/models/persona_product_item.dart';
import 'package:persona_click_rest/src/utils/storage.dart';

/// Main class for interacting with the PersonaClick API.
class PersonaClick {
  static final PersonaClick _instance = PersonaClick._internal();

  /// Returns the singleton instance of [PersonaClick].
  factory PersonaClick() => _instance;

  PersonaClick._internal();

  late final ApiClient _apiClient;
  final StorageService _storage = StorageService();

  String? _shopId;
  String? _did;
  String? _seance;
  String? _stream;
  String? _segment;
  String? _source;

  final Completer<void> _initCompleter = Completer<void>();

  /// Returns a future that completes when initialization is finished.
  Future<void> get initialized => _initCompleter.future;

  /// Initializes the PersonaClick SDK.
  ///
  /// [shopId] - Your shop ID.
  /// [stream] - The stream name (e.g. 'android', 'ios', 'web').
  /// [segment] - The user segment (default is null).
  /// [source] - Optional source parameter. If provided, it updates the stored source.
  Future<void> init({
    required String shopId,
    required String stream,
    String? segment,
    String? source,
  }) async {
    if (_initCompleter.isCompleted) return;

    _shopId = shopId;
    _stream = stream;
    _segment = segment;
    _apiClient = ApiClient();

    try {
      _did = await _storage.getDid();

      // Handle Source Logic
      if (source != null) {
        await setSource(source);
      } else {
        await _checkAndLoadSource();
      }

      final response = await _apiClient.get('/init', queryParameters: {
        'shop_id': _shopId,
        if (_did != null) 'did': _did,
      });

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final initResponse = InitResponse.fromJson(response.data);
        if (initResponse.did != null) {
          _did = initResponse.did;
          await _storage.saveDid(_did!);
        }
        if (initResponse.seance != null) {
          _seance = initResponse.seance;
        }
      }
      _initCompleter.complete();
    } catch (e) {
      // If initialization fails, we log it.
      // Future tracking calls will wait for this completer, so we should probably
      // complete it with error or just complete it to allow "offline" behavior
      // (though without DID/Seance tracking might fail on server).
      print('PersonaClick init error: $e');
      _initCompleter.completeError(e);
    }
  }

  Future<void> _checkAndLoadSource() async {
    final storedSource = await _storage.getSource();
    final storedTime = await _storage.getSourceTimestamp();

    if (storedSource != null && storedTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = now - storedTime;
      // 48 hours in milliseconds
      const expiration = 48 * 60 * 60 * 1000;

      if (diff < expiration) {
        _source = storedSource;
      } else {
        await _storage.clearSource();
        _source = null;
      }
    }
  }

  /// Sets the source parameter and saves it with the current timestamp.
  /// Valid for 48 hours.
  Future<void> setSource(String source) async {
    _source = source;
    await _storage.saveSource(source);
  }

  /// Tracks an event.
  ///
  /// [event] - The event to track (e.g. [CartEvent], [PurchaseEvent]).
  Future<void> track(PersonaEvent event) async {
    await initialized;

    // Check if event has a source, if so update storage
    final eventSource = event.toJson()['source'] as String?;
    if (eventSource != null) {
      await setSource(eventSource);
    } else {
      // If event doesn't have source, check if we have a valid stored source
      // We re-check expiration here in case app was open for > 48h
      await _checkAndLoadSource();
    }

    final path = event is CustomEvent ? '/push/custom' : '/push';

    final body = event.toJson();
    body.addAll({
      'shop_id': _shopId,
      'did': _did,
      'seance': _seance,
      'stream': _stream,
      if (_segment != null) 'segment': _segment,
      if (_source != null && !body.containsKey('source')) 'source': _source,
    });

    try {
      await _apiClient.post(path, data: body);
    } catch (e) {
      print('PersonaClick track error: $e');
      rethrow;
    }
  }

  /// Tracks a cart event.
  Future<void> trackCart({
    required List<PersonaProductItem> items,
    String? referer,
    bool? fullCart,
    String? source,
  }) {
    return track(CartEvent(
      items: items,
      referer: referer,
      fullCart: fullCart,
      source: source,
    ));
  }

  /// Tracks a purchase event.
  Future<void> trackPurchase({
    required String orderId,
    required List<PersonaProductItem> items,
    double? orderPrice,
    String? currency,
    String? referer,
    String? source,
    Map<String, dynamic>? custom,
  }) {
    return track(PurchaseEvent(
      orderId: orderId,
      items: items,
      orderPrice: orderPrice,
      currency: currency,
      referer: referer,
      source: source,
      custom: custom,
    ));
  }

  /// Tracks a search event.
  Future<void> trackSearch({
    required String searchQuery,
    String? recommendedCode,
    String? referer,
    String? source,
  }) {
    return track(SearchEvent(
      searchQuery: searchQuery,
      recommendedCode: recommendedCode,
      referer: referer,
      source: source,
    ));
  }

  /// Tracks a wishlist event.
  Future<void> trackWishlist({
    required List<PersonaProductItem> items,
    String? referer,
    bool? fullWish,
    String? source,
  }) {
    return track(WishlistEvent(
      items: items,
      referer: referer,
      fullWish: fullWish,
      source: source,
    ));
  }

  /// Tracks a remove from cart event.
  Future<void> trackRemoveFromCart({
    required List<PersonaProductItem> items,
    String? referer,
  }) {
    return track(RemoveFromCartEvent(
      items: items,
      referer: referer,
    ));
  }

  /// Tracks a remove from wishlist event.
  Future<void> trackRemoveFromWishlist({
    required List<PersonaProductItem> items,
    String? referer,
  }) {
    return track(RemoveFromWishlistEvent(
      items: items,
      referer: referer,
    ));
  }

  /// Tracks a custom event.
  Future<void> trackCustomEvent({
    required String name,
    String? referer,
    String? category,
    String? label,
    dynamic value,
    Map<String, dynamic>? payload,
    String? source,
  }) {
    return track(CustomEvent(
      name: name,
      referer: referer,
      category: category,
      label: label,
      value: value,
      payload: payload,
      source: source,
    ));
  }

  /// Tracks a product view event.
  Future<void> trackProductView({
    required List<PersonaProductItem> items,
    String? referer,
    String? recommendedBy,
    String? recommendedCode,
    String? source,
  }) {
    return track(ProductViewEvent(
      items: items,
      referer: referer,
      recommendedBy: recommendedBy,
      recommendedCode: recommendedCode,
      source: source,
    ));
  }

  /// Tracks a category view event.
  Future<void> trackCategoryView({
    required String categoryId,
    String? referer,
    String? source,
  }) {
    return track(CategoryViewEvent(
      categoryId: categoryId,
      referer: referer,
      source: source,
    ));
  }
}
