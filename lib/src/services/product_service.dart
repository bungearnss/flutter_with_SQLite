import '../utils/helpers/db_helper.dart';
import '../models/product.dart';

class ProductService {
  late DBHelper _dbHelper;

  ProductService() {
    _dbHelper = DBHelper();
  }

  Future<List<Product>> getProducts() async {
    List<Map<String, dynamic>> productMaps = await _dbHelper.getData();

    print("productMaps : $productMaps");

    List<Product> products = [];
    for (var map in productMaps) {
      products.add(Product.fromMap(map));
    }

    print("products : $products");

    return products;
  }

  Future<int?> addProduct(Product product) async {
    return await _dbHelper.addData(product.toMap());
  }

  Future<int?> deleteProduct(Product product) async {
    return await _dbHelper.deleteData(product.id!);
  }

  Future<int?> updateProduct(Product product) async {
    return await _dbHelper.updateData(product.toMap());
  }
}
