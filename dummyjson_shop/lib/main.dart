import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'data/model/product.dart';
import 'data/datasource/api_datasource.dart';
import 'data/datasource/local_datasource.dart';
import 'data/repository/product_repository.dart';
import 'providers/product_provider.dart';

void main() async {
  // Ensure Flutter engine is initialized before running async tasks like Hive
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  await Hive.openBox<Product>('products');

  // --- Dependency Injection ---
  // We create our classes here and pass them down. This is much cleaner
  // than creating them inside the UI.
  final apiDataSource = ApiDataSource();
  final localDataSource = LocalDataSource();
  final productRepository = ProductRepository(
    apiDataSource: apiDataSource,
    localDataSource: localDataSource,
  );

  runApp(
    // MultiProvider allows us to inject our state manager into the entire app
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(repository: productRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DummyJSON Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Setup in progress...'),
        ),
      ),
    );
  }
}
