import '../datasource/api_datasource.dart';
import '../datasource/local_datasource.dart';
import '../model/product.dart';

class ProductRepository {
  final ApiDataSource apiDataSource;
  final LocalDataSource localDataSource;

  ProductRepository({required this.apiDataSource, required this.localDataSource});

  /// Orchestrates data fetching by prioritizing network with a local cache fallback
  Future<List<Product>> getProducts({int skip = 0, int limit = 20, String query = ''}) async {
    try {
      // Fetch fresh data from remote API
      final products = await apiDataSource.getProducts(skip: skip, limit: limit, query: query);
      
      // Cache the first page of default results for offline mode
      if (skip == 0 && query.isEmpty) {
        await localDataSource.cacheProducts(products);
      }
      
      return products;
    } catch (e) {
      // Fallback to local cache if offline
      if (skip == 0 && query.isEmpty) {
        final cachedProducts = await localDataSource.getCachedProducts();
        if (cachedProducts.isNotEmpty) {
          return cachedProducts;
        }
      }
      throw Exception('Failed to load products. Check your internet connection.');
    }
  }

  Future<Product> addProduct(Product product) async {
    final newProduct = await apiDataSource.addProduct(product);
    await localDataSource.addProduct(newProduct);
    return newProduct;
  }

  Future<Product> updateProduct(Product product) async {
    final updatedProduct = await apiDataSource.updateProduct(product);
    await localDataSource.updateProduct(updatedProduct);
    return updatedProduct;
  }

  Future<void> deleteProduct(int id) async {
    final isDeleted = await apiDataSource.deleteProduct(id);
    if (isDeleted) {
      await localDataSource.deleteProduct(id);
    }
  }
}
