import 'package:dio/dio.dart';
import 'package:pos_app/stock_adjustments/model/dashboard_admin_model.dart';
import 'package:pos_app/stock_adjustments/model/stock_adjust_admin_model.dart';
import 'package:pos_app/utils/data_response.dart';
import 'package:pos_app/utils/urls.dart';

class AdminDataSource {
  Dio client = Dio();

  Future<DoubleResponse> listStockAdjustmentByAdmin() async {
    try {
      print("stockkk approo ${PosUrls.listStockAdjustmentForAdminUrl}");
      final response = await client.get(
        PosUrls.listStockAdjustmentForAdminUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      print("stockn manageb redspsine $response");
      if (response.data['status'] == 'success') {
        List<StockAdjustmentListAdminModel> variantList = [];
        for (var element in response.data['data']['results']) {
          variantList.add(StockAdjustmentListAdminModel.fromJson(element));
        }

        return DoubleResponse(true, variantList);
      } else {
        // If the response status is not 'success', handle the error here
        return DoubleResponse(false, null);
      }
    } catch (e) {
      // If an exception occurs during the request, handle it here
      print("Error fetching products: $e");
      return DoubleResponse(
        false,
        null,
      );
    }
  }

  Future<DoubleResponse> adminDashboard() async {
    try {
      final response = await client.post(
        PosUrls.adminDashboardUrl,
        data: {"from_date": "2023-06-10", "to_date": "2024-06-15"},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      print("trdssss $response");
      if (response.data['status'] == 'success') {
        AdminDashboard dashboard =
            AdminDashboard.fromJson(response.data['data']);
        return DoubleResponse(true, dashboard);
      } else {
        // If the response status is not 'success', handle the error here
        return DoubleResponse(false, null);
      }
    } catch (e) {
      // If an exception occurs during the request, handle it here
      print("Error fetching products: $e");
      return DoubleResponse(
        false,
        null,
      );
    }
  }
}
