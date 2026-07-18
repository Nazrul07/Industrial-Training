import 'package:hive/hive.dart';
import '../model/product.dart';

class LocalDataSource {
  final Box<Product> _productBox = Hive.box<Product>('products');

  /// Replaces the entire local cache with a fresh list of products
  Future<void> cacheProducts(List<Product> products) async {
    await _productBox.clear();
    for (var product in products) {
      await _productBox.put(product.id, product);
    }
  }

  /// Retrieves all offline cached products
  Future<List<Product>> getCachedProducts() async {
    return _productBox.values.toList();
  }

  // --- Local CRUD Operations ---

  Future<void> addProduct(Product product) async {
    await _productBox.put(product.id, product);
  }

  Future<void> updateProduct(Product product) async {
    await _productBox.put(product.id, product);
  }

  Future<void> deleteProduct(int id) async {
    await _productBox.delete(id);
  }
}
