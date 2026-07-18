import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/product_provider.dart';
import 'product_detail_screen.dart';
import 'add_edit_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Fetch initial data exactly once when the screen finishes building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts(isRefresh: true);
    });

    // Listen to scroll events to trigger infinite scrolling
    _scrollController.addListener(() {
      // If we are within 200 pixels of the bottom, load more data
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductProvider>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DummyJSON Shop'),
        // A search bar placed underneath the AppBar title
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                // Triggers search logic in the provider
                context.read<ProductProvider>().searchProducts(value);
              },
            ),
          ),
        ),
      ),
      // Consumer listens for notifyListeners() from ProductProvider
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          // 1. Show a loading spinner if fetching the initial page
          if (provider.isLoading && provider.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Show an error message if the very first load fails
          if (provider.errorMessage.isNotEmpty && provider.products.isEmpty) {
            return Center(child: Text(provider.errorMessage));
          }

          // 3. Show a friendly empty state if the search yields no results
          if (provider.products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          // 4. Render the list of products
          return RefreshIndicator(
            onRefresh: () => provider.fetchProducts(isRefresh: true),
            child: ListView.builder(
              controller: _scrollController,
              // Add 1 extra item to the list if we have more data, to show a spinner at the bottom
              itemCount: provider.products.length + (provider.hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                
                // If we reach the end of the current products, show a spinner
                if (index == provider.products.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final product = provider.products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: product.thumbnail,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          width: 50, height: 50, child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price} - ${product.category}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditProductScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
