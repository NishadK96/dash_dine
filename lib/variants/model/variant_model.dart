// To parse this JSON data, do
//
//     final variantsList = variantsListFromJson(jsonString);

import 'dart:convert';

import 'package:pos_app/variants/model/orderDetails.dart';

VariantsListModel variantsListFromJson(String str) => VariantsListModel.fromJson(json.decode(str));

String variantsListToJson(VariantsListModel data) => json.encode(data.toJson());

class VariantsListModel {
  int? id;
  String? code;
  String? name;
  String? description;
  String? image;
  String? costingType;
  int? productId;
  String? productName;
    VariantId? variantData;
  PriceData? priceData;
  
  StockData? stockData;
  VariantsListModel({
     this.id,
     this.costingType,
      this.variantData,
     this.code,
     this.name,
    this.productName,
     this.description,
     this.image,
    this.productId,
    this.priceData,
    this.stockData,
  });

  factory VariantsListModel.fromJson(Map<String, dynamic> json) => VariantsListModel(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    variantData:json["variant_data"]==null? null: VariantId.fromJson(json["variant_data"]),
      productName: json['product_name'],
      productId: json['product_id'],
      stockData:json['stock_data'] != null
        ?  StockData.fromJson(json['stock_data'])
        : null,
    priceData: json['price_data'] != null
        ? new PriceData.fromJson(json['price_data'])
        : null,
    costingType: json['costing_type'],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "product_name":productName,
    "costing_type":costingType,
    "name": name,
    "product_id":productId,
    "description": description,
    "image": image,
    "variant_data":variantData
  };
}
class PriceData {
  int? costingId;
  int? sellingPrice;
  String? costingType;

  PriceData({this.costingId, this.sellingPrice, this.costingType});

  PriceData.fromJson(Map<String, dynamic> json) {
    costingId = json['costing_id'];
    sellingPrice = json['selling_price'];
    costingType = json['costing_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['costing_id'] = this.costingId;
    data['selling_price'] = this.sellingPrice;
    data['costing_type'] = this.costingType;
    return data;
  }
}
class StockData {
  int? stockId;
  int? stockCount;
  String? stockType;

  StockData({this.stockId, this.stockCount, this.stockType});

  StockData.fromJson(Map<String, dynamic> json) {
    stockId = json['stock_id'];
    stockCount = json['stock_count'];
    stockType = json['stock_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stock_id'] = this.stockId;
    data['stock_count'] = this.stockCount;
    data['stock_type'] = this.stockType;
    return data;
  }
}