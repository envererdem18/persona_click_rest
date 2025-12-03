# PersonaClick REST

A Dart package for integrating with the PersonaClick REST API. This package allows you to track user activities, manage sessions, and send events to PersonaClick.

## Features

- **Automatic Session Management**: Handles `did` (Device ID) and `seance` (Session ID) storage and updates.
- **Event Tracking**: Easy-to-use methods for tracking various events like `cart`, `purchase`, `search`, `wish`, and custom events.
- **Type-Safe Models**: Provides structured classes for events and items to ensure data consistency.
- **Platform Agnostic**: Works on Android, iOS, and Web (configurable via `stream` parameter).

## Installation

Add `persona_click_rest` to your `pubspec.yaml`:

```yaml
dependencies:
  persona_click_rest: ^0.0.1
```

## Usage

### Initialization

Initialize the SDK with your `shop_id` and `stream` (e.g., 'android', 'ios', 'web').

```dart
import 'package:persona_click_rest/persona_click_rest.dart';

void main() async {
  // Initialize the SDK
  // 'stream' is optional. If omitted, it auto-detects (Android/iOS/Web).
  await PersonaClick().init(
    shopId: 'YOUR_SHOP_ID',
    stream: PersonaStream.android, 
    source: 'CAMPAIGN_CODE', // Optional
  );
  
  runApp(MyApp());
}
```

### Tracking Events

#### Add to Cart

```dart
await PersonaClick().trackCart(
  items: [
    PersonaProductItem(id: '100500', amount: 3, price: 100.0),
  ],
);
```

#### Purchase

```dart
await PersonaClick().trackPurchase(
  orderId: 'ORDER_12345',
  items: [
    PersonaProductItem(id: '100500', amount: 3, price: 100.0),
  ],
  orderPrice: 300.0,
);
```

#### Search

```dart
await PersonaClick().trackSearch(
  searchQuery: 'apple',
);
```

#### Product View

```dart
await PersonaClick().trackProductView(
  items: [
    PersonaProductItem(id: '100500'),
  ],
  recommendedBy: 'dynamic',
  recommendedCode: 'CODE_123',
);
```

#### Category View

```dart
await PersonaClick().trackCategoryView(
  categoryId: '146',
);
```

#### Custom Events

```dart
await PersonaClick().trackCustomEvent(
  name: 'my_custom_event',
  category: 'interaction',
  label: 'button_click',
  value: 1,
);
```

## Error Handling

The `init` and `track` methods return `Future`s. You should wrap them in try-catch blocks to handle potential network errors.

```dart
try {
  await PersonaClick().track(CartEvent(...));
} catch (e) {
  print('Failed to track event: $e');
}
```

## License

MIT
