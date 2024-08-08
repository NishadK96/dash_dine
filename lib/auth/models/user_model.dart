class UserModel {
  String? refresh;
  String? access;
  bool? status;
  String? firstName;
  String? lastName;
  String? userType;
  String? contactNumber;
  String? email;
  BusinessData? businessData;

  UserModel(
      {this.refresh,
      this.access,
      this.status,
      this.firstName,
      this.lastName,
      this.userType,
      this.contactNumber,
      this.email,
      this.businessData});

  UserModel.fromJson(Map<String, dynamic> json) {
    refresh = json['refresh'];
    access = json['access'];
    status = json['status'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userType = json['user_type'];
    contactNumber = json['contact_number'];
    email = json['email'];
    businessData = json['business_data'] != null
        ? BusinessData.fromJson(json['business_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['refresh'] = refresh;
    data['access'] = access;
    data['status'] = status;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['user_type'] = userType;
    data['contact_number'] = contactNumber;
    data['email'] = email;
    if (businessData != null) {
      data['business_data'] = businessData!.toJson();
    }
    return data;
  }
}

class BusinessData {
  int? businessId;
  String? code;
  String? name;
  String? email;
  String? type;

  BusinessData({this.businessId, this.code, this.name, this.email, this.type});

  BusinessData.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    code = json['code'];
    name = json['name'];
    email = json['email'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_id'] = businessId;
    data['code'] = code;
    data['name'] = name;
    data['email'] = email;
    data['type'] = type;
    return data;
  }
}