// import 'dart:io';

class ProductModel {
  // File? img;
  String? imgUrl;
  String? name;
  int? price;
  bool stock;

  ProductModel({this.imgUrl, this.name, this.price, required this.stock});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      name: json['name'], price: json['price'], stock: json['stock']);

  Map<String, dynamic> toJson() => {
        'imgUrl': imgUrl,
        'name': name,
        'price': price,
        'stock': stock,
      };
}
