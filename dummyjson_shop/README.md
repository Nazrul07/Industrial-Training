# DummyJSON Shop

This is a Flutter application built as a university assignment demonstrating API Integration, CRUD operations, Local Caching, and Pagination.

## API Used
- **DummyJSON Products API**: `https://dummyjson.com/products`

## Features
- **[x] Data Modeling**: Maps raw JSON data from the API into strongly typed Dart objects (`Product`).
- **[ ] Local Caching (Offline Mode)**: Uses Hive database to store products locally for offline access.
- **[ ] API Integration**: Uses `dio` to fetch and manipulate products.
- **[ ] State Management**: Uses `provider` to manage UI state effectively.
- **[ ] CRUD Operations**: Users can Create, Read, Update, and Delete products (simulated on API, persisted locally).
- **[ ] Pagination**: Infinite scrolling for loading more products.
- **[ ] Search functionality** to filter products.

## Packages Used
- `dio`: For making HTTP network requests.
- `provider`: For reactive state management.
- `hive` & `hive_flutter`: For local NoSQL database caching.
- `cached_network_image`: For downloading and caching network images.
- `build_runner` & `hive_generator`: For auto-generating code for data serialization.

## Screenshots
*(Screenshots will be added here once the UI is implemented)*

## How to run project
1. Clone this repository.
2. Run `flutter pub get` to install all packages.
3. Run `dart run build_runner build --delete-conflicting-outputs` to generate the necessary database code.
4. Run `flutter run` to launch the app on your emulator or connected device.
