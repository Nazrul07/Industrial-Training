import '../datasource/api_datasource.dart';
import '../datasource/local_datasource.dart';
import '../model/product.dart';

class ProductRepository {
  final ApiDataSource apiDataSource;
  final LocalDataSource localDataSource;

  ProductRepository({required this.apiDataSource, required this.localDataSource});

  Future<List<Product>> getProducts({int skip = 0, int limit = 20, String query = ''}) async {
    try {
      // 1. Try to fetch fresh data from the internet
      final products = await apiDataSource.getProducts(skip: skip, limit: limit, query: query);
      
      // 2. If successful, and we are fetching the first page without a search query, 
      // let's cache it for offline use! We don't want to cache search results or page 2, 3 etc. 
      // to keep the offline cache simple and relevant to the main screen.
      if (skip == 0 && query.isEmpty) {
        await localDataSource.cacheProducts(products);
      }
      
      return products;
    } catch (e) {
      // 3. If the internet fails (e.g. no connection), fall back to our local cache
      // We only return cached data if we were trying to load the first page without a search
      if (skip == 0 && query.isEmpty) {
        final cachedProducts = await localDataSource.getCachedProducts();
        if (cachedProducts.isNotEmpty) {
          return cachedProducts;
        }
      }
      // If we still fail (e.g. offline and no cache), throw the error to the UI
      throw Exception('Failed to load products. Check your internet connection.');
    }
  }

  // --- CRUD Operations ---
  
  Future<Product> addProduct(Product product) async {
    // 1. Tell API to add it
    final newProduct = await apiDataSource.addProduct(product);
    // 2. Save it locally so it shows up even if offline later
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
