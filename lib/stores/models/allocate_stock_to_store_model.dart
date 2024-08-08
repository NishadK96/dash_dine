class AllocateStockToStoreModel {
  int? stockCount;
  int? inventoryId;
  String? inventoryName;
  String? variantName;

  AllocateStockToStoreModel(
      {this.stockCount,
      this.inventoryId,
      this.inventoryName,
      this.variantName});

  AllocateStockToStoreModel.fromJson(Map<String, dynamic> json) {
    stockCount = json['stock_count'];
    inventoryId = json['inventory_id'];
    inventoryName = json['inventory_name'];
    variantName = json['variant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stock_count'] = stockCount;
    data['inventory_id'] = inventoryId;
    data['inventory_name'] = inventoryName;
    data['variant_name'] = variantName;
    return data;
  }
}