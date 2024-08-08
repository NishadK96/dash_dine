// To parse this JSON data, do
//
//     final assignToStock = assignToStockFromJson(jsonString);

import 'dart:convert';

AssignToStock assignToStockFromJson(String str) =>
    AssignToStock.fromJson(json.decode(str));

String assignToStockToJson(AssignToStock data) => json.encode(data.toJson());

class AssignToStock {
  int? id;
  InventoryId? inventoryId;
  int? variantId;

  AssignToStock({
    this.id,
    this.inventoryId,
    this.variantId,
  });

  factory AssignToStock.fromJson(Map<String, dynamic> json) => AssignToStock(
        id: json["id"],
        inventoryId: InventoryId.fromJson(json["inventory_id"]),
        variantId: json["variant_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "inventory_id": inventoryId?.toJson(),
        "variant_id": variantId,
      };
}

class InventoryId {
  int? id;
  String? code;
  String? name;
  dynamic city;
  dynamic phoneNumber;
  dynamic email;
  dynamic addressLine;
  String? description;
  bool? isActive;
  int? warehouse;

  InventoryId({
    this.id,
    this.code,
    this.name,
    this.city,
    this.phoneNumber,
    this.email,
    this.addressLine,
    this.description,
    this.isActive,
    this.warehouse,
  });

  factory InventoryId.fromJson(Map<String, dynamic> json) => InventoryId(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        city: json["city"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        addressLine: json["address_line"],
        description: json["description"],
        isActive: json["is_active"],
        warehouse: json["warehouse"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "city": city,
        "phone_number": phoneNumber,
        "email": email,
        "address_line": addressLine,
        "description": description,
        "is_active": isActive,
        "warehouse": warehouse,
      };
}
