import 'dart:math';

import 'package:dio/dio.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/stores/models/allocate_stock_to_store_model.dart';
import 'package:pos_app/stores/models/store_dashboard_model.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/utils/data_response.dart';
import 'package:pos_app/utils/urls.dart';
import 'package:pos_app/variants/model/assign_model.dart';

class StoreDataSource {
  Dio client = Dio();

  Future<DoubleResponse> createStore({
    required String name,
    required int wareHouseId,
    required String email,
    required String phone,
    required String address,
    required String city,
  }) async {
    final response = await client.post(
      PosUrls.createStore,
      data: {
        "name": name,
        "email": email,
        "address_line": address,
        "city": city,
        "phone_number": phone,
        "warehouse": wareHouseId,
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

  Future<DoubleResponse> editStore({
    required String name,
    // required String description,
    required int id,
    // required int wareHouseId,
    required String email,
    required String phone,
    required String address,
    required String city,
  }) async {
    final response = await client.put(
      "${PosUrls.editStore}$id/",
      data: {
        "name": name,
        // "description": description,
        // "code": code,
        // "warehouse": wareHouseId,
        "city": city,
        "phone_number": phone,
        "email": email,
        "address_line": address,
        // "is_active": true
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

  Future<DoubleResponse> readVariantForStockAllocate({
    required int variantId,
    required int wareHouseId,
  }) async {
    final response = await client.post(
      PosUrls.readVariantForStockAllocateUrl,
      data: {"variant_id": variantId, "warehouse_id": wareHouseId},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    StockAllocateModel stockData =
        StockAllocateModel.fromJson(response.data['data']);

    return DoubleResponse(response.data['status'] == "success", stockData);
  }

  Future<DoubleResponse> receiveStockByInventory({
    required int inventoryId,
    required String variantName,
    required int receivingId,
  }) async {
    final response = await client.post(
      PosUrls.receiveStockByInventory,
      data: {
        "recieving_id": receivingId,
        "inventory_id": inventoryId,
        "variant_name": variantName
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

  Future<DoubleResponse> stockApproveByAdmin({
    required int receivingId,
  }) async {
    final response = await client.post(
      PosUrls.stockApprovalByAdmin,
      data: {"adjustment_id": receivingId, "is_approved": true},
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
//allocate stock to store

  Future<DoubleResponse> allocateStockToStore({
    required int stockId,
    required List<AllocateStockToStoreModel> stockList,
  }) async {
    final response = await client.post(
      PosUrls.allocateStockToStoreUrl,
      data: {"stock_id": stockId, "store_list": stockList},
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

  Future<DoubleResponse> allocateStockToWareHouse(
      {required int variantId,
      required int wareHouseId,
      required int quantity,
      required bool add}) async {
    final response = await client.post(
      PosUrls.allocateStockToWareHouseUrl,
      data: {
        "variant_id": variantId,
        "warehouse_id": wareHouseId,
        "stock_choice": add ? "increase" : "reduce",
        "stock_count": quantity
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

  Future<DoubleResponse> listReceivingStockInventory() async {
    try {
      final response = await client.get(
        PosUrls.listReceivingStockByInventory,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.data['status'] == 'success') {
        List<ReceiveStockModel> variantList = [];
        for (var element in response.data['data']['results']) {
          variantList.add(ReceiveStockModel.fromJson(element));
        }

        return DoubleResponse(true, variantList);
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

  Future<PaginatedResponse> getAllStores(
      {String? searchKey, String? warehouseId, int? pageNo}) async {
    try {
      print('saaarchhhhh $searchKey');
      print('sdjhgchsjdx ${PosUrls.listStores}?warehouse_id=$warehouseId');
      final response = await client.get(searchKey!=null && searchKey!=""?"${PosUrls.listStores}?search_name=$searchKey":
        authentication.authenticatedUser.userType == "wmanager"
            ? "${PosUrls.listStores}?warehouse_id=${authentication.authenticatedUser.businessData?.businessId}"
            : warehouseId == null || warehouseId == ""
                ? "${PosUrls.listStores}?search_name=$searchKey&page=$pageNo"
                : "${PosUrls.listStores}?warehouse_id=$warehouseId",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      print("resssss $response");
      if (response.data['status'] == "success") {
        List<StoreModel> stores = [];
        for (var element in response.data['data']['results']) {
          stores.add(StoreModel.fromJson(element));
        }

        return PaginatedResponse(true,stores,response.data['data']['next'],response.data['data']['count'].toString());
      } else {
        // If the response status is not 'success', handle the error here
        return PaginatedResponse(false,null,null,null);
      }
    } catch (e) {
      // If an exception occurs during the request, handle it here
      return PaginatedResponse(false,null,null,null);
    }
  }

  Future<DoubleResponse> deleteStore({
    required String storeId,
  }) async {
    print("urrll ${PosUrls.editStore}$storeId");
    try {
       final response = await client.delete(
      "${PosUrls.editStore}$storeId",
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    print("responseeee reeeedee $response");

    } catch (e) {
      print("edcc z4e $e");
    }
    final response = await client.delete(
      "${PosUrls.editStore}$storeId",
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    print("responseeee reeeedee $response");
    return DoubleResponse(response.statusCode == 204, "Deleted Successfully");
  }

  Future<DoubleResponse> getAllStoresUnerWareHouse(
      int warehouseId, int variantId) async {
    try {
      final response = await client.post(
        PosUrls.AssignToInventory,
        data: {"warehouse_id": warehouseId, "variant_id": variantId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.data['status'] == "success") {
        List<InventoryId> assignStore = [];
        for (var element in response.data['data']['results']) {
          assignStore.add(InventoryId.fromJson(element));
        }

        return DoubleResponse(true, assignStore);
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

  Future<DoubleResponse> storeDashboard() async {
    try {
      final response = await client.post(
        PosUrls.adminDashboardUrl,
        data: {
          "from_date": "2023-06-10",
          "to_date": "2024-06-15",
          "inventory_id": 1
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.data['status'] == 'success') {
        StoreDashboard dashboard =
            StoreDashboard.fromJson(response.data['data']);
        return DoubleResponse(true, dashboard);
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
}
