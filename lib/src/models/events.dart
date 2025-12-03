import 'package:persona_click_rest/src/models/persona_product_item.dart';

/// Base class for all events.
abstract class PersonaEvent {
  String get eventName;
  Map<String, dynamic> toJson();
}

class CartEvent extends PersonaEvent {
  @override
  final String eventName = 'cart';

  final String? referer;
  final List<PersonaProductItem> items;
  final bool? fullCart;
  final String? source;

  CartEvent({
    this.referer,
    required this.items,
    this.fullCart,
    this.source,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'event': eventName,
      if (referer != null) 'referer': referer,
      'items': items.map((e) => e.toJson(useAmountKey: false)).toList(),
      if (fullCart != null) 'full_cart': fullCart,
      if (source != null) 'source': source,
    };
  }
}

class PurchaseEvent extends PersonaEvent {
  @override
  final String eventName = 'purchase';

  final String? referer;
  final String orderId;
  final double? orderPrice;
  final String? currency; // Not explicitly in curl but common
  final List<PersonaProductItem> items;
  final String? source;
  final Map<String, dynamic>? custom;

  PurchaseEvent({
    this.referer,
    required this.orderId,
    this.orderPrice,
    this.currency,
    required this.items,
    this.source,
    this.custom,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'event': eventName,
      if (referer != null) 'referer': referer,
      'order_id': orderId,
      if (orderPrice != null) 'order_price': orderPrice,
      'items': items.map((e) => e.toJson(useAmountKey: true)).toList(),
      if (source != null) 'source': source,
      if (custom != null) 'custom': custom,
    };
  }
}

class SearchEvent extends PersonaEvent {
  @override
  final String eventName = 'search';

  final String? referer;
  final String searchQuery;
  final String? recommendedCode;
  final String? source;

  SearchEvent({
    this.referer,
    required this.searchQuery,
    this.recommendedCode,
    this.source,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'event': eventName,
      if (referer != null) 'referer': referer,
      'search_query': searchQuery,
      if (recommendedCode != null) 'recommended_code': recommendedCode,
      if (source != null) 'source': source,
    };
  }
}

class WishlistEvent extends PersonaEvent {
  @override
  final String eventName = 'wish';

  final String? referer;
  final List<PersonaProductItem> items;
  final bool? fullWish;
  final String? source;

  WishlistEvent({
    this.referer,
    required this.items,
    this.fullWish,
    this.source,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'event': eventName,
      if (referer != null) 'referer': referer,
      'items': items.map((e) => e.toJson()).toList(),
      if (fullWish != null) 'full_wish': fullWish,
      if (source != null) 'source': source,
    };
  }
}

class RemoveFromCartEvent extends PersonaEvent {
  @override
  final String eventName = 'remove_from_cart';

  final String? referer;
  final List<PersonaProductItem> items;

  RemoveFromCartEvent({
    this.referer,
    required this.items,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'event': eventName,
      if (referer != null) 'referer': referer,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class RemoveFromWishlistEvent extends PersonaEvent {
  @override
  final String eventName = 'remove_wish';

  final String? referer;
  final List<PersonaProductItem> items;

  RemoveFromWishlistEvent({
    this.referer,
    required this.items,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'event': eventName,
      if (referer != null) 'referer': referer,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class CustomEvent extends PersonaEvent {
  final String name;
  final String? referer;
  final String? category;
  final String? label;
  final dynamic value;
  final Map<String, dynamic>? payload;
  final String? source;

  CustomEvent({
    required this.name,
    this.referer,
    this.category,
    this.label,
    this.value,
    this.payload,
    this.source,
  });

  @override
  String get eventName => name;

  @override
  Map<String, dynamic> toJson() {
    return {
      'event': eventName,
      if (referer != null) 'referer': referer,
      if (category != null) 'category': category,
      if (label != null) 'label': label,
      if (value != null) 'value': value,
      if (payload != null) 'payload': payload,
      if (source != null) 'source': source,
    };
  }
}

class ProductViewEvent extends PersonaEvent {
  @override
  final String eventName = 'view';

  final String? referer;
  final List<PersonaProductItem> items;
  final String? recommendedBy;
  final String? recommendedCode;
  final String? source;

  ProductViewEvent({
    this.referer,
    required this.items,
    this.recommendedBy,
    this.recommendedCode,
    this.source,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'event': eventName,
      if (referer != null) 'referer': referer,
      'items': items.map((e) => e.toJson()).toList(),
      if (recommendedBy != null) 'recommended_by': recommendedBy,
      if (recommendedCode != null) 'recommended_code': recommendedCode,
      if (source != null) 'source': source,
    };
  }
}

class CategoryViewEvent extends PersonaEvent {
  @override
  final String eventName = 'category';

  final String? referer;
  final String categoryId;
  final String? source;

  CategoryViewEvent({
    this.referer,
    required this.categoryId,
    this.source,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'event': eventName,
      if (referer != null) 'referer': referer,
      'category_id': categoryId,
      if (source != null) 'source': source,
    };
  }
}
