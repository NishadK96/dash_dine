
import 'package:dio/dio.dart';
import 'package:pos_app/utils/data_response.dart';
import 'package:pos_app/utils/urls.dart';
import 'package:pos_app/warehouse/models/warehouse_dashboard_model.dart';
import 'package:pos_app/warehouse/models/warehouse_model.dart';
class WareHouseDataSource {
  Dio client = Dio();

  Future<DoubleResponse> createWareHouse({
    required String name,
    required String address,
    required String city,
    required String phone,
     required String email,
  }) async {
    print("addresss line $address");
    final response = await client.post(
      PosUrls.createWareHouse,
      data: {
        "name":name,
        "address_line":address,
        "city":city,
        "phone_number":phone,
        "email":email
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return DoubleResponse(
        response.data['status'] == "success", response.data['message']);
  }
  Future<DoubleResponse> editWareHouse({
    required String name,
    required String address,
    required String city,
    required String phone,
     required String email,
     required String wareHouseId,
  }) async {
    print("addresss line $address");
    final response = await client.put(
      "${PosUrls.deleteWareHouse}$wareHouseId/",
      data: {
        "name":name,
        "address_line":address,
        "city":city,
        "phone_number":phone,
        "email":email
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return DoubleResponse(
        response.data['status'] == "success", response.data['message']);
  }
  Future<DoubleResponse>deleteWarehouse({
    required String storeId,
  }) async {
    final response = await client.delete(
      "${PosUrls.deleteWareHouse}$storeId/",
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return DoubleResponse(
        response.statusCode==204, "Deleted Successfully");
  }
  Future<DoubleResponse> getAllWarehouses(String searchKey) async {
    try {
      final response = await client.get(
        "${PosUrls.listWareHouse}?search_name=$searchKey",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      print("response of warehjouse $response");
      if (response.data['status']=="success") {
        List<WareHouseModel> warehouses = [];
        for (var element in response.data['data']['results']) {
          warehouses.add(WareHouseModel.fromJson(element));
        }

        return DoubleResponse(true, warehouses);
      } else {
        // If the response status is not 'success', handle the error here
        return DoubleResponse(false, null);
      }
    } catch (e) {
      // If an exception occurs during the request, handle it here
      return DoubleResponse(
        false,
        null,
      );
    }
  }
   Future<DoubleResponse> warehouseDashboard() async {
    try {
      final response = await client.get(
        PosUrls.adminDashboardUrl,
        
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.data['status'] == 'success') {
        WarehouseDashboard dashboard =
            WarehouseDashboard.fromJson(response.data['data']);
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
