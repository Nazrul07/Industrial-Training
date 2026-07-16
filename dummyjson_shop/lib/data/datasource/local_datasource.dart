import 'package:hive/hive.dart';
import '../model/product.dart';

class LocalDataSource {
  // A box is like a table in SQL databases
  final Box<Product> _productBox = Hive.box<Product>('products');

  // Save a list of products to the local cache
  Future<void> cacheProducts(List<Product> products) async {
    // We clear the old cache and save the new list from the API
    await _productBox.clear();
    for (var product in products) {
      // Use the product ID as the key for easy lookup later
      await _productBox.put(product.id, product);
    }
  }

  // Get all cached products
  Future<List<Product>> getCachedProducts() async {
    // Convert the box values to a simple List
    return _productBox.values.toList();
  }

  // --- CRUD Operations for Local Cache ---

  // Create (Add)
  Future<void> addProduct(Product product) async {
    await _productBox.put(product.id, product);
  }

  // Update (Edit)
  Future<void> updateProduct(Product product) async {
    await _productBox.put(product.id, product);
  }

  // Delete
  Future<void> deleteProduct(int id) async {
    await _productBox.delete(id);
  }
}
