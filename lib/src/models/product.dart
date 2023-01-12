class Product {
  int? id;
  late String product;
  late String image;
  late String description;

  Product(this.product, this.image, this.description);

  Product.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    product = map['product'];
    image = map['image'];
    description = map['description'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['product'] = product;
    map['image'] = image;
    map['description'] = description;

    return map;
  }
}
