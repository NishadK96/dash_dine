class AdminDashboard {
  int? warehouseCount;
  int? productCount;
  int? variantCount;
  int? inventoryCount;
  int? stockAdjustmentRequestCount;

  AdminDashboard(
      {this.warehouseCount,
      this.productCount,
      this.variantCount,
      this.inventoryCount,
      this.stockAdjustmentRequestCount});

  AdminDashboard.fromJson(Map<String, dynamic> json) {
    warehouseCount = json['warehouse_count'];
    productCount = json['product_count'];
    variantCount = json['variant_count'];
    inventoryCount = json['inventory_count'];
    stockAdjustmentRequestCount = json['stock_adjustment_request_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warehouse_count'] = this.warehouseCount;
    data['product_count'] = this.productCount;
    data['variant_count'] = this.variantCount;
    data['inventory_count'] = this.inventoryCount;
    data['stock_adjustment_request_count'] = this.stockAdjustmentRequestCount;
    return data;
  }
}