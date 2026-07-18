import 'package:dio/dio.dart';
import '../model/product.dart';

class ApiDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// Fetches products with support for pagination and search
  Future<List<Product>> getProducts({int skip = 0, int limit = 20, String query = ''}) async {
    try {
      final String endpoint = query.isEmpty ? '/products' : '/products/search';
      
      final response = await _dio.get(
        endpoint,
        queryParameters: {
          'limit': limit,
          'skip': skip,
          if (query.isNotEmpty) 'q': query,
        },
      );

      final List<dynamic> productsJson = response.data['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // --- Remote CRUD Operations ---
  // Note: These simulate server mutations. The backend returns 200 OK
  // but doesn't persist the data globally.

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
      return response.data['isDeleted'] == true;
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
