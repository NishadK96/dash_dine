// To parse this JSON data, do
//
//     final productList = productListFromJson(jsonString);

import 'dart:convert';

ProductList productListFromJson(String str) =>
    ProductList.fromJson(json.decode(str));

String productListToJson(ProductList data) => json.encode(data.toJson());

class ProductList {
  int id;
  String code;
  String name;
  String description;
  dynamic image;
  dynamic costingType;
  dynamic price;

  ProductList({
    required this.id,
    required this.code,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.costingType,
  });

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        id: json["id"],
        code: json["code"],
        price: json["price"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        costingType: json["costing_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "price":price,
        "name": name,
        "description": description,
        "image": image,
        "costing_type": costingType,
      };
}
