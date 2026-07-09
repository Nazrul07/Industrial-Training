import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  double price;

  @HiveField(4)
  String thumbnail;

  @HiveField(5)
  String category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.category,
  });

  // This factory method converts the JSON from DummyJSON into our Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      thumbnail: json['thumbnail'] ?? '',
      category: json['category'] ?? '',
    );
  }

  // This method converts our Product object back to JSON (useful for CRUD operations)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
      'category': category,
    };
  }
}
