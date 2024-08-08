class StoreDashboard {
  int? totalOrder;
  int? productCount;
  int? variantCount;
  int? totalRevenue;

  StoreDashboard(
      {this.totalOrder,
      this.productCount,
      this.variantCount,
      this.totalRevenue});

  StoreDashboard.fromJson(Map<String, dynamic> json) {
    totalOrder = json['total_order'];
    productCount = json['product_count'];
    variantCount = json['variant_count'];
    totalRevenue = json['total_revenue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_order'] = totalOrder;
    data['product_count'] = productCount;
    data['variant_count'] = variantCount;
    data['total_revenue'] = totalRevenue;
    return data;
  }
}