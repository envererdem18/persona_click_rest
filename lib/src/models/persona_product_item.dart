/// Represents a product item in the cart, order, or wishlist.
class PersonaProductItem {
  /// The unique identifier of the product.
  final String id;

  /// The quantity of the product (usually for cart synchronization).
  final int? quantity;

  /// The amount of the product (usually for purchase or adding to cart).
  final int? amount;

  /// The price of the product.
  final double? price;

  /// Constructs a [PersonaProductItem].
  PersonaProductItem({
    required this.id,
    this.quantity,
    this.amount,
    this.price,
  });

  /// Converts the [PersonaProductItem] to a JSON map.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
    };

    if (quantity != null) {
      map['quantity'] = quantity;
    }

    if (amount != null) {
      map['amount'] = amount;
    }

    if (price != null) {
      map['price'] = price;
    }

    return map;
  }
}
