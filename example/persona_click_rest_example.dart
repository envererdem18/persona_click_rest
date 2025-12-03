import 'package:persona_click_rest/persona_click_rest.dart';

void main() async {
  // 1. Initialize the SDK
  // Replace with your actual shop ID
  final shopId = '0d42fd8b713d0752776ca589cc0056';

  print('Initializing PersonaClick...');
  try {
    await PersonaClick().init(
      shopId: shopId,
      stream: 'web',
    );
    print('Initialization successful!');
  } catch (e) {
    print('Initialization failed: $e');
    return;
  }

  // 2. Track a search event
  print('Tracking search event...');
  try {
    await PersonaClick().trackSearch(
      searchQuery: 'iphone',
    );
    print('Search event tracked!');
  } catch (e) {
    print('Failed to track search: $e');
  }

  // 3. Track add to cart
  print('Tracking add to cart...');
  try {
    await PersonaClick().trackCart(
      items: [
        PersonaProductItem(id: '123', amount: 1, price: 999.0),
      ],
    );
    print('Cart event tracked!');
  } catch (e) {
    print('Failed to track cart: $e');
  }
}
