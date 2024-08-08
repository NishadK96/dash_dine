class WarehouseDashboard {
  int? productCount;
  int? variantCount;
  int? inventoryCount;

  WarehouseDashboard(
      {this.productCount, this.variantCount, this.inventoryCount});

  WarehouseDashboard.fromJson(Map<String, dynamic> json) {
    productCount = json['product_count'];
    variantCount = json['variant_count'];
    inventoryCount = json['inventory_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_count'] = productCount;
    data['variant_count'] = variantCount;
    data['inventory_count'] = inventoryCount;
    return data;
  }
}