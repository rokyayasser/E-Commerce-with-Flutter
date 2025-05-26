// lib/features/home/data/models/ProductModel.dart

class ProductModel {
  bool? status;
  ProductItem? data;

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? ProductItem.fromJson(json['data']) : null;
  }
}

class ProductItem {
  List<Data> productList = [];

  ProductItem.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        productList.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  late int id;
  late final double price;
  late final double oldPrice;
  late int discount;
  late String image;
  late String name;
  late String description;
  late bool inFavorites;
  late bool inCart;
  List<String> images = [];

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'].toDouble();
    oldPrice = json['old_price'].toDouble();
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
    images = List<String>.from(json['images']);
  }
}
