import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/model/product.dart';
import '../providers/product_provider.dart';

class AddEditProductScreen extends StatefulWidget {
  // If product is null, the form is for Adding. If it's provided, it's for Editing.
  final Product? product; 

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late String _title;
  late String _description;
  late double _price;
  late String _category;
  late String _thumbnail;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form fields if we are in Edit mode
    _title = widget.product?.title ?? '';
    _description = widget.product?.description ?? '';
    _price = widget.product?.price ?? 0.0;
    _category = widget.product?.category ?? '';
    // DummyJSON images are hard to upload, so we'll use a placeholder for new items
    _thumbnail = widget.product?.thumbnail ?? 'https://dummyjson.com/image/150';
  }

  void _saveForm() {
    // Validate runs all the validator functions in the form fields
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final provider = context.read<ProductProvider>();

      if (widget.product == null) {
        // Create a new product instance
        final newProduct = Product(
          // Dummy ID for local simulation (since dummyjson API doesn't actually save to their DB globally)
          id: DateTime.now().millisecondsSinceEpoch % 100000, 
          title: _title,
          description: _description,
          price: _price,
          category: _category,
          thumbnail: _thumbnail,
        );
        provider.addProduct(newProduct);
      } else {
        // Update existing product instance
        final updatedProduct = Product(
          id: widget.product!.id,
          title: _title,
          description: _description,
          price: _price,
          category: _category,
          thumbnail: _thumbnail,
        );
        provider.updateProduct(updatedProduct);
      }

      // Close the screen and go back
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
                  onSaved: (value) => _title = value!,
                ),
                TextFormField(
                  initialValue: _price > 0 ? _price.toString() : '',
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
                  onSaved: (value) => _price = double.parse(value!),
                ),
                TextFormField(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) => value!.isEmpty ? 'Please enter a category' : null,
                  onSaved: (value) => _category = value!,
                ),
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                  onSaved: (value) => _description = value!,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(isEditing ? 'Update Product' : 'Create Product'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
