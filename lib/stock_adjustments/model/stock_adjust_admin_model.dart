class StockAdjustmentListAdminModel {
  int? id;
  int? inventoryStockId;
  int? quantity;
  String? adjustmentType;
  String? reason;
  VariantData? variantData;
  VariantData? stockData;
  String? inventoryName;

  StockAdjustmentListAdminModel(
      {this.id,
      this.inventoryStockId,
      this.quantity,
      this.adjustmentType,
      this.reason,
      this.variantData,
      this.stockData,
      this.inventoryName});

  StockAdjustmentListAdminModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inventoryStockId = json['inventory_stock_id'];
    quantity = json['quantity'];
    adjustmentType = json['adjustment_type'];
    reason = json['reason'];
    variantData = json['variant_data'] != null
        ? VariantData.fromJson(json['variant_data'])
        : null;
    stockData = json['stock_data'] != null
        ? VariantData.fromJson(json['stock_data'])
        : null;
    inventoryName = json['inventory_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['inventory_stock_id'] = inventoryStockId;
    data['quantity'] = quantity;
    data['adjustment_type'] = adjustmentType;
    data['reason'] = reason;
    if (variantData != null) {
      data['variant_data'] = variantData!.toJson();
    }
    if (stockData != null) {
      data['stock_data'] = stockData!.toJson();
    }
    data['inventory_name'] = inventoryName;
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