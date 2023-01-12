import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import './view_product_screen.dart';
import './add_edit_product_screen.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  final List<Product> _productList = <Product>[];

  final _productService = ProductService();

  _getAllProducts() async {
    _productService.getProducts().then((value) {
      setState(() {
        _productList.clear();
        _productList.addAll(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllProducts();
  }

  _showSuceessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insta Store Catalog"),
      ),
      body: ListView.builder(
        itemCount: _productList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) =>
                        ViewProductScreen(product: _productList[index])),
                  ),
                );
              },
              leading: CircleAvatar(
                backgroundImage:
                    AssetImage("assets/images/${_productList[index].image}"),
              ),
              title: Text(_productList[index].product),
              subtitle: Text(_productList[index].description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEditProductScreen())).then((data) {
            if (data != null) {
              _getAllProducts();
              _showSuceessSnackBar("Product added successfully");
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
