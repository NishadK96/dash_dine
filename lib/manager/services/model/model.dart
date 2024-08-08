// To parse this JSON data, do
//
//     final managerList = managerListFromJson(jsonString);

import 'dart:convert';

ManagerList managerListFromJson(String str) => ManagerList.fromJson(json.decode(str));

String managerListToJson(ManagerList data) => json.encode(data.toJson());

class ManagerList {
  int? id;
  dynamic lastLogin;
  String? email;
  DateTime? dateJoined;
  bool? isActive;
  bool? emailVerified;
  String? contactNumber;
  String? firstName;
  String? lastName;
  String? userType;
  OperationValueClass? operationValue;

  ManagerList({
     this.id,
     this.lastLogin,
     this.email,
     this.dateJoined,
    this.operationValue,
     this.isActive,
     this.emailVerified,
     this.contactNumber,
     this.firstName,
     this.lastName,
     this.userType,
  });

  factory ManagerList.fromJson(Map<String, dynamic> json) => ManagerList(
    id: json["id"],
    lastLogin: json["last_login"],
    email: json["email"],
    dateJoined: DateTime.parse(json["date_joined"]),
    isActive: json["is_active"],
    operationValue: OperationValueClass.fromJson(json["operation_value"]),
    emailVerified: json["email_verified"],
    contactNumber: json["contact_number"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    userType: json["user_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "last_login": lastLogin,
    "email": email,
    "operation_value": operationValue?.toJson(),
    "date_joined": dateJoined?.toIso8601String(),
    "is_active": isActive,
    "email_verified": emailVerified,
    "contact_number": contactNumber,
    "first_name": firstName,
    "last_name": lastName,
    "user_type": userType,
  };
}
class OperationValueClass {
  String? inventoryCode;
  String? inventoryName;
  String? warehouseCode;
  String? warehouseName;

  OperationValueClass({
    this.inventoryCode,
    this.inventoryName,
    this.warehouseCode,
    this.warehouseName,
  });

  factory OperationValueClass.fromJson(Map<String, dynamic> json) => OperationValueClass(
    inventoryCode: json["inventory_code"],
    inventoryName: json["inventory_name"],
    warehouseCode: json["warehouse_code"],
    warehouseName: json["warehouse_name"],
  );

  Map<String, dynamic> toJson() => {
    "inventory_code": inventoryCode,
    "inventory_name": inventoryName,
    "warehouse_code": warehouseCode,
    "warehouse_name": warehouseName,
  };
}