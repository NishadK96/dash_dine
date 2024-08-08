// To parse this JSON data, do
//
//     final attributeList = attributeListFromJson(jsonString);

import 'dart:convert';

AttributeList attributeListFromJson(String str) => AttributeList.fromJson(json.decode(str));

String attributeListToJson(AttributeList data) => json.encode(data.toJson());

class AttributeList {
  int? id;
  String? code;
  String? name;
  String? description;
  String? image;

  AttributeList({
     this.id,
     this.code,
     this.name,
     this.description,
     this.image,
  });

  factory AttributeList.fromJson(Map<String, dynamic> json) => AttributeList(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "description": description,
    "image": image,
  };
}
