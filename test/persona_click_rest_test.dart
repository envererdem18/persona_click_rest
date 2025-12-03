import 'package:flutter_test/flutter_test.dart';
import 'package:persona_click_rest/persona_click_rest.dart';

void main() {
  group('PersonaProductItem Tests', () {
    test('toJson serialization', () {
      final item = PersonaProductItem(id: '123', quantity: 2, price: 10.0);
      final json = item.toJson();

      expect(json['id'], '123');
      expect(json['quantity'], 2);
      expect(json['price'], 10.0);
    });

    test('toJson serialization with amount key', () {
      final item = PersonaProductItem(id: '123', quantity: 2, price: 10.0);
      final json = item.toJson(useAmountKey: true);

      expect(json['id'], '123');
      expect(json['amount'], 2);
      expect(json['quantity'], null);
    });
  });

  group('Event Tests', () {
    test('CartEvent serialization', () {
      final event = CartEvent(
        items: [PersonaProductItem(id: '1', quantity: 1)],
        referer: 'http://example.com',
      );
      final json = event.toJson();

      expect(json['event'], 'cart');
      expect(json['referer'], 'http://example.com');
      expect((json['items'] as List).length, 1);
    });
  });
}
