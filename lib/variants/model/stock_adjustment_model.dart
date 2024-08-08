class StockAdjustmentModel {
  int? id;
  String? code;
  String? name;
  String? description;
  String? image;
  InventoryStockData? inventoryStockData;
  InventoryCostingData? inventoryCostingData;
  AdjustmentType? adjustmentType;

  StockAdjustmentModel(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.image,
      this.inventoryStockData,
      this.inventoryCostingData,
      this.adjustmentType});

  StockAdjustmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    inventoryStockData = json['inventory_stock_data'] != null
        ? new InventoryStockData.fromJson(json['inventory_stock_data'])
        : null;
    inventoryCostingData = json['inventory_costing_data'] != null
        ? new InventoryCostingData.fromJson(json['inventory_costing_data'])
        : null;
    adjustmentType = json['adjustment_type'] != null
        ? new AdjustmentType.fromJson(json['adjustment_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    if (this.inventoryStockData != null) {
      data['inventory_stock_data'] = this.inventoryStockData!.toJson();
    }
    if (this.inventoryCostingData != null) {
      data['inventory_costing_data'] = this.inventoryCostingData!.toJson();
    }
    if (this.adjustmentType != null) {
      data['adjustment_type'] = this.adjustmentType!.toJson();
    }
    return data;
  }
}

class InventoryStockData {
  int? id;
  int? variantId;
  String? code;
  int? variantInventoryMapperId;
  String? stockType;
  int? stockCount;

  InventoryStockData(
      {this.id,
      this.variantId,
      this.code,
      this.variantInventoryMapperId,
      this.stockType,
      this.stockCount});

  InventoryStockData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variantId = json['variant_id'];
    code = json['code'];
    variantInventoryMapperId = json['variant_inventory_mapper_id'];
    stockType = json['stock_type'];
    stockCount = json['stock_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['variant_id'] = this.variantId;
    data['code'] = this.code;
    data['variant_inventory_mapper_id'] = this.variantInventoryMapperId;
    data['stock_type'] = this.stockType;
    data['stock_count'] = this.stockCount;
    return data;
  }
}

class InventoryCostingData {
  int? id;
  String? costingType;
  int? inventoryProductMapperId;
  int? productId;
  int? inventoryId;
  int? sellingPrice;

  InventoryCostingData(
      {this.id,
      this.costingType,
      this.inventoryProductMapperId,
      this.productId,
      this.inventoryId,
      this.sellingPrice});

  InventoryCostingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    costingType = json['costing_type'];
    inventoryProductMapperId = json['inventory_product_mapper_id'];
    productId = json['product_id'];
    inventoryId = json['inventory_id'];
    sellingPrice = json['selling_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['costing_type'] = this.costingType;
    data['inventory_product_mapper_id'] = this.inventoryProductMapperId;
    data['product_id'] = this.productId;
    data['inventory_id'] = this.inventoryId;
    data['selling_price'] = this.sellingPrice;
    return data;
  }
}

class AdjustmentType {
  List<String>? stockType;

  AdjustmentType({this.stockType});

  AdjustmentType.fromJson(Map<String, dynamic> json) {
    stockType = json['stock_type'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stock_type'] = this.stockType;
    return data;
  }
}