// To parse this JSON data, do
//
//     final orderLines = orderLinesFromJson(jsonString);

import 'dart:convert';

OrderLines orderLinesFromJson(String str) => OrderLines.fromJson(json.decode(str));

String orderLinesToJson(OrderLines data) => json.encode(data.toJson());

class OrderLines {
  int? id;
  int? variantId;
  int? productId;
  int? orderLineId;
  bool? isActive;
  dynamic quantity;
  dynamic sellingPrice;
  String? variantName;
  String? productName;
  String? deliveryNote;
  String? image;

  OrderLines({
    required this.variantId,
    this.orderLineId,
    this.isActive,
    this.id,
    required this.image,
    required this.productId,
    required this.quantity,
    required this.sellingPrice,
    required this.variantName,
    required this.productName,
    required this.deliveryNote,
  });

  factory OrderLines.fromJson(Map<String, dynamic> json) => OrderLines(
    variantId: json["variant_id"],
    productId: json["product_id"],
    image: json['image'],
    id: json['id'],
    orderLineId: json['order_line_id'],
    quantity: json["quantity"],
    isActive: json['is_active'],
    sellingPrice: json["selling_price"],
    variantName: json["variant_name"],
    productName: json["product_name"],
    deliveryNote: json["delivery_note"],
  );

  Map<String, dynamic> toJson() => {
    "variant_id": variantId,
    "is_active":isActive,
    "id":id,
    "product_id": productId,
    "order_line_id":orderLineId,
    "quantity": quantity,
    "image":image,
    "selling_price": sellingPrice,
    "variant_name": variantName,
    "product_name": productName,
    "delivery_note": deliveryNote,
  };
}
