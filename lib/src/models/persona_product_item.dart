/// Represents a product item in the cart, order, or wishlist.
class PersonaProductItem {
  /// The unique identifier of the product.
  final String id;

  /// The quantity of the product.
  /// Maps to 'amount' or 'quantity' in JSON depending on the event.
  final int? quantity;

  /// The price of the product.
  final double? price;

  /// Constructs a [PersonaProductItem].
  PersonaProductItem({
    required this.id,
    this.quantity,
    this.price,
  });

  /// Converts the [PersonaProductItem] to a JSON map.
  ///
  /// [useAmountKey] - if true, uses 'amount' key for quantity (e.g. for purchase).
  /// if false, uses 'quantity' key (e.g. for cart).
  Map<String, dynamic> toJson({bool useAmountKey = false}) {
    final map = <String, dynamic>{
      'id': id,
    };

    if (quantity != null) {
      map[useAmountKey ? 'amount' : 'quantity'] = quantity;
    }

    if (price != null) {
      map['price'] = price;
    }

    return map;
  }
}
