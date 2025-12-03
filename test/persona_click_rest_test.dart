import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:persona_click_rest/persona_click_rest.dart';
import 'package:persona_click_rest/src/client/api_client.dart';
import 'package:persona_click_rest/src/utils/storage.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockStorageService extends Mock implements StorageService {}

class MockResponse extends Mock implements Response {}

void main() {
  late MockApiClient mockApiClient;
  late MockStorageService mockStorageService;

  setUp(() {
    mockApiClient = MockApiClient();
    mockStorageService = MockStorageService();
    PersonaClick.apiClient = mockApiClient;
    PersonaClick.storage = mockStorageService;
    PersonaClick.resetInitCompleter();

    // Default mocks
    when(() => mockStorageService.getDid()).thenAnswer((_) async => null);
    when(() => mockStorageService.saveDid(any())).thenAnswer((_) async {});
    when(() => mockStorageService.getSource()).thenAnswer((_) async => null);
    when(() => mockStorageService.getSourceTimestamp()).thenAnswer((_) async => null);
    when(() => mockStorageService.saveSource(any())).thenAnswer((_) async {});
    when(() => mockStorageService.clearSource()).thenAnswer((_) async {});
  });

  group('PersonaClick Init Tests', () {
    test('init success', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.data).thenReturn({'did': 'new_did'});
      when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer(
        (_) async => response,
      );

      await PersonaClick.init(shopId: 'test_shop', stream: PersonaStream.web);

      verify(() => mockApiClient.get('/init', queryParameters: {
            'shop_id': 'test_shop',
          })).called(1);
      verify(() => mockStorageService.saveDid('new_did')).called(1);
    });

    test('init with source', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.data).thenReturn({});
      when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer(
        (_) async => response,
      );

      await PersonaClick.init(
        shopId: 'test_shop',
        stream: PersonaStream.web,
        source: 'test_source',
      );

      verify(() => mockStorageService.saveSource('test_source')).called(1);
    });

    test('init failure', () async {
      when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenThrow(
        DioException(requestOptions: RequestOptions(path: '/init')),
      );

      // init should not throw, but completeError the completer
      await PersonaClick.init(shopId: 'test_shop', stream: PersonaStream.web);

      expect(PersonaClick.initialized, throwsA(isA<DioException>()));
    });
  });

  group('PersonaClick Track Tests', () {
    setUp(() async {
      // Re-init for track tests to ensure shopId is set
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.data).thenReturn({'did': 'test_did'});
      when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer(
        (_) async => response,
      );
      await PersonaClick.init(shopId: 'test_shop', stream: PersonaStream.web);
      reset(mockApiClient); // Reset calls from init
    });

    test('trackCart', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => MockResponse());

      await PersonaClick.trackCart(items: [
        PersonaProductItem(id: '1', quantity: 1),
      ]);

      verify(() => mockApiClient.post('/push', data: any(named: 'data'))).called(1);
    });

    test('trackPurchase', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => MockResponse());

      await PersonaClick.trackPurchase(
        orderId: '123',
        items: [PersonaProductItem(id: '1', quantity: 1)],
      );

      verify(() => mockApiClient.post('/push', data: any(named: 'data'))).called(1);
    });

    test('trackSearch', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => MockResponse());

      await PersonaClick.trackSearch(searchQuery: 'test');

      verify(() => mockApiClient.post('/push', data: any(named: 'data'))).called(1);
    });

    test('trackWishlist', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => MockResponse());

      await PersonaClick.trackWishlist(items: []);

      verify(() => mockApiClient.post('/push', data: any(named: 'data'))).called(1);
    });

    test('trackRemoveFromCart', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => MockResponse());

      await PersonaClick.trackRemoveFromCart(items: []);

      verify(() => mockApiClient.post('/push', data: any(named: 'data'))).called(1);
    });

    test('trackRemoveFromWishlist', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => MockResponse());

      await PersonaClick.trackRemoveFromWishlist(items: []);

      verify(() => mockApiClient.post('/push', data: any(named: 'data'))).called(1);
    });

    test('trackCustomEvent', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => MockResponse());

      await PersonaClick.trackCustomEvent(name: 'custom');

      verify(() => mockApiClient.post('/push/custom', data: any(named: 'data')))
          .called(1);
    });

    test('trackProductView', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => MockResponse());

      await PersonaClick.trackProductView(items: []);

      verify(() => mockApiClient.post('/push', data: any(named: 'data'))).called(1);
    });

    test('trackCategoryView', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => MockResponse());

      await PersonaClick.trackCategoryView(categoryId: 'cat');

      verify(() => mockApiClient.post('/push', data: any(named: 'data'))).called(1);
    });
  });

  group('Source Logic Tests', () {
    test('setSource updates storage', () async {
      await PersonaClick.setSource('new_source');
      verify(() => mockStorageService.saveSource('new_source')).called(1);
    });

    test('checkAndLoadSource loads valid source', () async {
      when(() => mockStorageService.getSource()).thenAnswer((_) async => 'stored_source');
      when(() => mockStorageService.getSourceTimestamp())
          .thenAnswer((_) async => DateTime.now().millisecondsSinceEpoch);

      // We need to access the private method via a public trigger or reflection,
      // but since it's private we test its effect via track or init.
      // track calls checkAndLoadSource if no source provided.

      // Setup init to ensure SDK is ready
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.data).thenReturn({});
      when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer(
        (_) async => response,
      );
      await PersonaClick.init(shopId: 'test', stream: PersonaStream.web);

      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => MockResponse());

      await PersonaClick.trackSearch(searchQuery: 'test');

      // Verify that the stored source was sent in the payload
      final captured =
          verify(() => mockApiClient.post(any(), data: captureAny(named: 'data')))
              .captured;
      final body = captured.first as Map<String, dynamic>;
      expect(body['source'], 'stored_source');
    });

    test('checkAndLoadSource clears expired source', () async {
      when(() => mockStorageService.getSource()).thenAnswer((_) async => 'old_source');
      // 49 hours ago
      when(() => mockStorageService.getSourceTimestamp()).thenAnswer((_) async =>
          DateTime.now().subtract(const Duration(hours: 49)).millisecondsSinceEpoch);

      // Setup init
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.data).thenReturn({});
      when(() => mockApiClient.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer(
        (_) async => response,
      );
      await PersonaClick.init(shopId: 'test', stream: PersonaStream.web);

      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => MockResponse());

      await PersonaClick.trackSearch(searchQuery: 'test');

      verify(() => mockStorageService.clearSource()).called(2);
      final captured =
          verify(() => mockApiClient.post(any(), data: captureAny(named: 'data')))
              .captured;
      final body = captured.first as Map<String, dynamic>;
      expect(body.containsKey('source'), false);
    });
  });

  group('Models Tests', () {
    test('PersonaProductItem toJson', () {
      final item = PersonaProductItem(id: '1', quantity: 2, price: 10.0);
      expect(item.toJson(), {'id': '1', 'quantity': 2, 'price': 10.0});
    });

    test('CartEvent toJson', () {
      final event = CartEvent(items: [], referer: 'ref', fullCart: true);
      final json = event.toJson();
      expect(json['event'], 'cart');
      expect(json['referer'], 'ref');
      expect(json['full_cart'], true);
    });

    test('PurchaseEvent toJson', () {
      final event =
          PurchaseEvent(orderId: '1', items: [], orderPrice: 100, currency: 'USD');
      final json = event.toJson();
      expect(json['event'], 'purchase');
      expect(json['order_id'], '1');
      expect(json['order_price'], 100);
    });

    test('SearchEvent toJson', () {
      final event = SearchEvent(searchQuery: 'q', recommendedCode: 'code');
      final json = event.toJson();
      expect(json['event'], 'search');
      expect(json['search_query'], 'q');
      expect(json['recommended_code'], 'code');
    });

    test('WishlistEvent toJson', () {
      final event = WishlistEvent(items: [], fullWish: true);
      final json = event.toJson();
      expect(json['event'], 'wish');
      expect(json['full_wish'], true);
    });

    test('RemoveFromCartEvent toJson', () {
      final event = RemoveFromCartEvent(items: []);
      final json = event.toJson();
      expect(json['event'], 'remove_from_cart');
    });

    test('RemoveFromWishlistEvent toJson', () {
      final event = RemoveFromWishlistEvent(items: []);
      final json = event.toJson();
      expect(json['event'], 'remove_wish');
    });

    test('CustomEvent toJson', () {
      final event = CustomEvent(
          name: 'custom', category: 'cat', label: 'lbl', value: 1, payload: {'a': 1});
      final json = event.toJson();
      expect(json['event'], 'custom');
      expect(json['category'], 'cat');
      expect(json['label'], 'lbl');
      expect(json['value'], 1);
      expect(json['payload'], {'a': 1});
    });

    test('ProductViewEvent toJson', () {
      final event =
          ProductViewEvent(items: [], recommendedBy: 'rec', recommendedCode: 'code');
      final json = event.toJson();
      expect(json['event'], 'view');
      expect(json['recommended_by'], 'rec');
      expect(json['recommended_code'], 'code');
    });

    test('CategoryViewEvent toJson', () {
      final event = CategoryViewEvent(categoryId: 'cat');
      final json = event.toJson();
      expect(json['event'], 'category');
      expect(json['category_id'], 'cat');
    });
  });
}
