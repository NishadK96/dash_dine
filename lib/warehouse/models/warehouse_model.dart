class WareHouseModel {
  String? name;
  String? email;
  String? addressLine;
  String? city;
  String? phoneNumber;
  int? id;

  WareHouseModel(
      {this.name, this.email, this.addressLine, this.city, this.phoneNumber});

  WareHouseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    addressLine = json['address_line'];
    city = json['city'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['address_line'] = addressLine;
    data['city'] = city;
    data['phone_number'] = phoneNumber;
    return data;
  }
}