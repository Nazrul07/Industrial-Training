import 'package:flutter/material.dart';
import '../data/model/product.dart';
import '../data/repository/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;

  ProductProvider({required this.repository});

  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';
  
  int _skip = 0;
  final int _limit = 20;
  bool _hasMoreData = true;
  String _currentQuery = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;

  /// Loads the initial list of products or performs a pull-to-refresh
  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      _skip = 0;
      _hasMoreData = true;
    }
    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); 

    try {
      final fetchedProducts = await repository.getProducts(
        skip: _skip,
        limit: _limit,
        query: _currentQuery,
      );

      if (isRefresh) {
        _products = fetchedProducts;
      } else {
        _products.addAll(fetchedProducts);
      }

      // Check if we've reached the end of the available pagination data
      if (fetchedProducts.length < _limit) {
        _hasMoreData = false;
      } else {
        _skip += _limit;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Triggers pagination to fetch the next batch of products
  Future<void> loadMore() async {
    if (_isLoading || !_hasMoreData) return;
    await fetchProducts();
  }

  /// Re-initializes the feed with a new search query
  Future<void> searchProducts(String query) async {
    _currentQuery = query;
    await fetchProducts(isRefresh: true);
  }

  // --- CRUD State Updates ---

  Future<void> addProduct(Product product) async {
    try {
      final newProduct = await repository.addProduct(product);
      _products.insert(0, newProduct);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add product';
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final updatedProduct = await repository.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == updatedProduct.id);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to update product';
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await repository.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
       _errorMessage = 'Failed to delete product';
       notifyListeners();
    }
  }
}
