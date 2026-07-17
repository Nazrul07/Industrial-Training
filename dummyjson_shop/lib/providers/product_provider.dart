import 'package:flutter/material.dart';
import '../data/model/product.dart';
import '../data/repository/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository repository;

  ProductProvider({required this.repository});

  // --- State Variables ---
  // These hold the current status of our app's data
  List<Product> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';
  
  // --- Pagination & Search Variables ---
  int _skip = 0;
  final int _limit = 20;
  bool _hasMoreData = true;
  String _currentQuery = '';

  // --- Getters ---
  // The UI will read from these getters to know what to display
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;

  // Fetch initial products or refresh the list
  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      _skip = 0; // Reset pagination
      _hasMoreData = true;
    }
    
    _isLoading = true;
    _errorMessage = '';
    // notifyListeners() shouts out to the UI: "Hey, the state changed! Rebuild yourself!"
    notifyListeners(); 

    try {
      final fetchedProducts = await repository.getProducts(
        skip: _skip,
        limit: _limit,
        query: _currentQuery,
      );

      if (isRefresh) {
        _products = fetchedProducts; // Replace old data
      } else {
        _products.addAll(fetchedProducts); // Append new data to the bottom
      }

      // If we got fewer items than the limit we requested, it means we hit the end of the database
      if (fetchedProducts.length < _limit) {
        _hasMoreData = false;
      } else {
        _skip += _limit; // Prepare the skip counter for the next page
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Tell UI to stop showing loading spinners
    }
  }

  // Load more data for infinite scrolling
  Future<void> loadMore() async {
    if (_isLoading || !_hasMoreData) return;
    await fetchProducts(); // Fetch without isRefresh so it appends
  }

  // Search
  Future<void> searchProducts(String query) async {
    _currentQuery = query;
    await fetchProducts(isRefresh: true);
  }

  // --- CRUD Operations ---
  
  Future<void> addProduct(Product product) async {
    try {
      final newProduct = await repository.addProduct(product);
      _products.insert(0, newProduct); // Add to the top of our local list
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
        _products[index] = updatedProduct; // Swap the old one for the new one
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
      _products.removeWhere((p) => p.id == id); // Remove it from our local list
      notifyListeners();
    } catch (e) {
       _errorMessage = 'Failed to delete product';
       notifyListeners();
    }
  }
}
