// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
    int? id;
    DateTime? orderDate;
    String? orderBy;
    String? customerName;
    CustomerId? customerId;
    String? deliveryNote;
    double? totalPrice;
    List<Line>? lines;

    OrderDetailsModel({
        this.id,
        this.orderDate,
        this.orderBy,
        this.customerId,
        this.customerName,
        this.deliveryNote,
        this.totalPrice,
        this.lines,
    });

    factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
        id: json["id"],
        orderDate: DateTime.parse(json["order_date"]),
        orderBy: json["order_by"],
      customerName: json["customer_name"],
        customerId:json['customer_id']==null? null:CustomerId.fromJson(json["customer_id"]),
        deliveryNote: json["delivery_note"],
        totalPrice: json["total_price"],
        lines:json["lines"]==null? null:List<Line>.from(json["lines"].map((x) => Line.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "order_date": orderDate?.toIso8601String(),
        "order_by": orderBy,
        "customer_id": customerId?.toJson(),
      "customer_name":customerName,
        "delivery_note": deliveryNote,
        "total_price": totalPrice,
        "lines":lines==null? null:List<dynamic>.from(lines!.map((x) => x.toJson())),
    };
}

class CustomerId {
    int? id;
    String? name;
    String? phoneNumber;

    CustomerId({
        this.id,
        this.name,
        this.phoneNumber,
    });

    factory CustomerId.fromJson(Map<String, dynamic> json) => CustomerId(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["Phone_number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "Phone_number": phoneNumber,
    };
}

class Line {
    int? id;
    int? productInventoryMapperId;
    int? productId;
    int? variantInventoryMapperId;
    VariantId? variantId;
    int? stockInventoryId;
    int? costingId;
    dynamic quantity;
    dynamic sellingPrice;

    Line({
        this.id,
        this.productInventoryMapperId,
        this.productId,
        this.variantInventoryMapperId,
        this.variantId,
        this.stockInventoryId,
        this.costingId,
        this.quantity,
        this.sellingPrice,
    });

    factory Line.fromJson(Map<String, dynamic> json) => Line(
        id: json["id"],
        productInventoryMapperId: json["product_inventory_mapper_id"],
        productId: json["product_id"],
        variantInventoryMapperId: json["variant_inventory_mapper_id"],
        variantId: VariantId.fromJson(json["variant_id"]),
        stockInventoryId: json["stock_inventory_id"],
        costingId: json["costing_id"],
        quantity: json["quantity"],
        sellingPrice: json["selling_price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_inventory_mapper_id": productInventoryMapperId,
        "product_id": productId,
        "variant_inventory_mapper_id": variantInventoryMapperId,
        "variant_id": variantId?.toJson(),
        "stock_inventory_id": stockInventoryId,
        "costing_id": costingId,
        "quantity": quantity,
        "selling_price": sellingPrice,
    };
}

class VariantId {
    int? id;
    String? code;
    String? name;
    String? description;
    String? image;
    Id? productId;
    List<Id>? attributeId;
    String? stockType;

    VariantId({
        this.id,
        this.code,
        this.name,
        this.description,
        this.image,
        this.productId,
        this.attributeId,
        this.stockType,
    });

    factory VariantId.fromJson(Map<String, dynamic> json) => VariantId(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        productId: Id.fromJson(json["product_id"]),
        attributeId: List<Id>.from(json["attribute_id"].map((x) => Id.fromJson(x))),
        stockType: json["stock_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
        "image": image,
        "product_id": productId?.toJson(),
        "attribute_id":attributeId==null? null:List<dynamic>.from(attributeId!.map((x) => x.toJson())),
        "stock_type": stockType,
    };
}

class Id {
    int? id;
    String? code;
    String? name;
    String? description;
    String? image;
    String? costingType;

    Id({
        this.id,
        this.code,
        this.name,
        this.description,
        this.image,
        this.costingType,
    });

    factory Id.fromJson(Map<String, dynamic> json) => Id(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        costingType: json["costing_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
        "image": image,
        "costing_type": costingType,
    };
}
