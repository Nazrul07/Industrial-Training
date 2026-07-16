import 'package:dio/dio.dart';
import '../model/product.dart';

class ApiDataSource {
  // Initialize Dio with a base URL and timeouts
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Fetch products with optional pagination (limit/skip) and search (query)
  Future<List<Product>> getProducts({int skip = 0, int limit = 20, String query = ''}) async {
    try {
      // If we have a query, use the search endpoint. Otherwise, use the standard products endpoint.
      final String endpoint = query.isEmpty ? '/products' : '/products/search';
      
      final response = await _dio.get(
        endpoint,
        queryParameters: {
          'limit': limit,
          'skip': skip,
          if (query.isNotEmpty) 'q': query,
        },
      );

      // The JSON has a key called 'products' which holds the list of items
      final List<dynamic> productsJson = response.data['products'];
      
      // Convert the raw JSON map into a List of our Product objects
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      // If there's no internet or the server is down, we throw an error
      throw Exception('Failed to fetch products: $e');
    }
  }

  // --- CRUD Simulated API Calls ---
  // Note: DummyJSON doesn't actually save these changes on their server database, 
  // but it returns a successful response mimicking a real backend. We will combine this 
  // with our Local Cache in the next steps to make it persist on the device.

  Future<Product> addProduct(Product product) async {
    try {
      final response = await _dio.post(
        '/products/add',
        data: product.toJson(),
      );
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<Product> updateProduct(Product product) async {
    try {
      final response = await _dio.put(
        '/products/${product.id}',
        data: product.toJson(),
      );
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final response = await _dio.delete('/products/$id');
      // The API returns an 'isDeleted' boolean flag
      return response.data['isDeleted'] == true;
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
