class VariantOrderModel {
  int? id;
  String? name;
  String? image;
  PriceData? priceData;
  StockData? stockData;
  int? productId;
  String? productName;

  VariantOrderModel(
      {this.id,
      this.name,
      this.image,
      this.priceData,
      this.stockData,
      this.productId,
      this.productName});

  VariantOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    priceData = json['price_data'] != null
        ? PriceData.fromJson(json['price_data'])
        : null;
    stockData = json['stock_data'] != null
        ? StockData.fromJson(json['stock_data'])
        : null;
    productId = json['product_id'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    if (priceData != null) {
      data['price_data'] = priceData!.toJson();
    }
    if (stockData != null) {
      data['stock_data'] = stockData!.toJson();
    }
    data['product_id'] = productId;
    data['product_name'] = productName;
    return data;
  }
}

class PriceData {
  int? costingId;
  int? sellingPrice;
  String? costingType;

  PriceData({this.costingId, this.sellingPrice, this.costingType});

  PriceData.fromJson(Map<String, dynamic> json) {
    costingId = json['costing_id'];
    sellingPrice = json['selling_price'];
    costingType = json['costing_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['costing_id'] = costingId;
    data['selling_price'] = sellingPrice;
    data['costing_type'] = costingType;
    return data;
  }
}

class StockData {
  int? stockId;
  int? stockCount;
  String? stockType;

  StockData({this.stockId, this.stockCount, this.stockType});

  StockData.fromJson(Map<String, dynamic> json) {
    stockId = json['stock_id'];
    stockCount = json['stock_count'];
    stockType = json['stock_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stock_id'] = stockId;
    data['stock_count'] = stockCount;
    data['stock_type'] = stockType;
    return data;
  }
}