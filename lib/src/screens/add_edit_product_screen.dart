import 'package:flutter/material.dart';

import '../services/product_service.dart';
import '../models/product.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _productController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isNameValid = false;
  bool _isImageValid = false;
  bool _isDescriptionValid = false;

  final _productService = ProductService();

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      _productController.text = widget.product!.product;
      _imageController.text = widget.product!.image;
      _descriptionController.text = widget.product!.description;

      _updateState();
    }
  }

  void _updateState() {
    setState(() {
      _isNameValid = _productController.text.isNotEmpty;
      _isImageValid = _imageController.text.isNotEmpty;
      _isDescriptionValid = _descriptionController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.product == null
            ? const Text("Add Product to Catalog")
            : const Text("Edit Product in Catalog"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _productController,
                    decoration: InputDecoration(
                      hintText: "Enter name",
                      labelText: "Name",
                      errorText:
                          !_isNameValid ? "Product cannot be empty" : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _imageController,
                    decoration: InputDecoration(
                      hintText: "Enter image name",
                      labelText: "Image",
                      errorText:
                          !_isImageValid ? "Image cannot be empty" : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: "Enter description",
                      labelText: "Description",
                      errorText: !_isDescriptionValid
                          ? "Description cannot be empty"
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      _updateState();
                      if (_isNameValid &&
                          _isImageValid &&
                          _isDescriptionValid) {
                        var product = Product(
                          _productController.text,
                          _imageController.text,
                          _descriptionController.text,
                        );

                        // Future<int?> result =
                        //     _productService.addProduct(product);

                        Future<int?> result;
                        if (widget.product == null) {
                          result = _productService.addProduct(product);
                        } else {
                          product.id = widget.product?.id;
                          result = _productService.updateProduct(product);
                        }

                        result.then((value) => Navigator.pop(context, result));
                      }
                    },
                    child: const Text("Save product"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _productController.text = "";
                      _imageController.text = "";
                      _descriptionController.text = "";
                    },
                    child: const Text("Clear product"),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
