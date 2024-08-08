class StoreModel {
  int? id;
  String? code;
   String? email;
    String? phone;
     String? address;
      String? city;
  String? name;
  String? warehouseName;
  String? description;
  bool? isActive;
  int? warehouse;

  StoreModel(
      {this.id,
      this.code,
      this.name,
      this.warehouseName,
      this.address,
      this.city,
      this.email,
      this.phone,
      this.description,
      this.isActive,
      this.warehouse});

  StoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone=json['phone_number'];
    email=json['email'];
    address=json['address_line'];
    warehouseName=json['warehouse_name'];
    city=json['city']
;    code = json['code'];
    name = json['name'];
    description = json['description'];
    isActive = json['is_active'];
    warehouse = json['warehouse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city']=city;
    data['address_line']=address;
    data['email']=email;
    data['phone_number']=phone;
    data['code'] = code;
    data['name'] = name;
    data['warehouse_name'] = warehouseName;
    data['description'] = description;
    data['is_active'] = isActive;
    data['warehouse'] = warehouse;
    return data;
  }
}
// class StockAllocateModel {
//   int? id;
//   String? name;
//   int? warehouseStockData;
//   List<StoreStockList>? storeStockList;

//   StockAllocateModel(
//       {this.id, this.name, this.warehouseStockData, this.storeStockList});

//   StockAllocateModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     warehouseStockData = json['warehouse_stock_data'];
//     if (json['store_stock_list'] != null) {
//       storeStockList = <StoreStockList>[];
//       json['store_stock_list'].forEach((v) {
//         storeStockList!.add(new StoreStockList.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['name'] = name;
//     data['warehouse_stock_data'] = warehouseStockData;
//     if (storeStockList != null) {
//       data['store_stock_list'] =
//           storeStockList!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class StoreStockList {
//   int? id;
//   int? stockCount;
//   String? storeName;

//   StoreStockList({this.id, this.stockCount, this.storeName});

//   StoreStockList.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     stockCount = json['stock_count'];
//     storeName = json['store_name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['stock_count'] = stockCount;
//     data['store_name'] = storeName;
//     return data;
//   }
// }

class StockAllocateModel {
  int? id;
  String? name;
  int? warehouseStockData;
  List<StoreStockList>? storeStockList;
  int? stockId;

  StockAllocateModel(
      {this.id,
      this.name,
      this.warehouseStockData,
      this.storeStockList,
      this.stockId});

  StockAllocateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    warehouseStockData = json['warehouse_stock_data'];
    if (json['store_stock_list'] != null) {
      storeStockList = <StoreStockList>[];
      json['store_stock_list'].forEach((v) {
        storeStockList!.add(StoreStockList.fromJson(v));
      });
    }
    stockId = json['stock_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['warehouse_stock_data'] = warehouseStockData;
    if (storeStockList != null) {
      data['store_stock_list'] =
          storeStockList!.map((v) => v.toJson()).toList();
    }
    data['stock_id'] = stockId;
    return data;
  }
}

class StoreStockList {
  int? id;
  int? stockCount;
  String? storeName;
  int? inventoryId;

  StoreStockList({this.id, this.stockCount, this.storeName});

  StoreStockList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stockCount = json['stock_count'];
    storeName = json['store_name'];
    inventoryId = json['inventory_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stock_count'] = stockCount;
    data['store_name'] = storeName;
    data['inventoryId'] = inventoryId;
    return data;
  }
}

class ReceiveStockModel {
  int? id;
  VariantData? variantData;
  int? stockId;
  String? allocatedDate;
  String? allocatedBy;
  int? recievingQty;
  int? inventoryId;

  ReceiveStockModel(
      {this.id,
      this.variantData,
      this.stockId,
      this.allocatedDate,
      this.allocatedBy,
      this.recievingQty,
      this.inventoryId});

  ReceiveStockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variantData = json['variant_data'] != null
        ? VariantData.fromJson(json['variant_data'])
        : null;
    stockId = json['stock_id'];
    allocatedDate = json['allocated_date'];
    allocatedBy = json['allocated_by'];
    recievingQty = json['recieving_qty'];
    inventoryId = json['inventory_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (variantData != null) {
      data['variant_data'] = variantData!.toJson();
    }
    data['stock_id'] = stockId;
    data['allocated_date'] = allocatedDate;
    data['allocated_by'] = allocatedBy;
    data['recieving_qty'] = recievingQty;
    data['inventory_id'] = inventoryId;
    return data;
  }
}

class VariantData {
  int? id;
  String? code;
  String? name;
  String? description;
  String? image;

  VariantData({this.id, this.code, this.name, this.description, this.image});

  VariantData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    return data;
  }
}