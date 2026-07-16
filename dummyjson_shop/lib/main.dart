import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/model/product.dart';

void main() async {
  // Ensure Flutter engine is initialized before running async tasks like Hive
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Register our auto-generated Product adapter so Hive understands our objects
  Hive.registerAdapter(ProductAdapter());
  
  // Open a 'box' (which is like a table in SQL databases) to store our products
  await Hive.openBox<Product>('products');

  runApp(const MyApp());
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
