import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/utils/data_response.dart';
import 'package:pos_app/utils/urls.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pos_app/variants/model/assign_model.dart';
import 'package:pos_app/variants/model/attribute_model.dart';
import 'package:pos_app/variants/model/stock_adjustment_model.dart';
import 'package:pos_app/variants/model/variant_model.dart';
import 'package:pos_app/variants/screens/edit_variant.dart';

class VariantDataSource {
  Dio client = Dio();
Future<DoubleResponse> createVariant(
      {required String name,
      required String description,
      required String updatedBy,
      File? image,
      required String stockType,
      required List<int> attributeIDs,
      required int productId}) async {
    String? filePath = "";
    String newAttributeId=attributeIDs.join(",");
    print("check new at services $newAttributeId, $stockType");

    filePath = image?.path;
    final mime = lookupMimeType(filePath ?? "")!.split("/");
    final fileData = await MultipartFile.fromFile(filePath ?? "",
        contentType: MediaType(mime.first, mime.last));

    final FormData formData = FormData.fromMap({
      "image": fileData,
      "name": name,
      "description": description,
      "updated_by": updatedBy,
      "stock_type": stockType,
      "product_id": productId,
      "attribute_id": newAttributeId,
    });
    final response = await client.post(
      PosUrls.createVariant,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    print("response is ${response.data}");
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
  }


  Future<DoubleResponse> editVariant(
      {required String name,
      required String description,
      required String updatedBy,
      File? image,
      required String stockType,
      required List<AttributeModel> attributes,
      required int productId,
      required int variantId}) async {
    try {
      var response;
      final List<Map<String, dynamic>> attributesJson =
          attributes.map((attribute) => attribute.toJson()).toList();
// final String attributesJsonString = jsonEncode(attributesJson);
      String? filePath = "";
      print(
          "check new at services ${PosUrls.deleteVariant}$variantId $attributesJson, $stockType ,$name ,$description , $productId");

      // if (image == null) {
      response = await client.patch(
        "${PosUrls.deleteVariant}$variantId",
        data: {
          "image": null,
          "name": name,
          "description": description,
          "stock_type": stockType,
          "product_id": productId,
          "attribute_id": attributesJson,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print("response is of edit ${response.data}");
      return DoubleResponse(
          response.data['status'] == 'success', response.data['message']);
    } catch (e, l) {
      print("hkjkhfhkjwhdfbjc $e ,$l");
      return DoubleResponse(false, "SomeThing went wrong");
    }
  }

  Future<DoubleResponse> editImage(
      {File? image, required int variantId}) async {
    try {
      print("edittttteyyyy IMSE $image");
      String? filePath = "";

      filePath = image?.path;
      final mime = lookupMimeType(filePath ?? "")!.split("/");
      final fileData = await MultipartFile.fromFile(filePath ?? "",
          contentType: MediaType(mime.first, mime.last));

      final FormData formData = FormData.fromMap({"image": fileData});
      print("pathhh ${PosUrls.editVariantImageUrl}$variantId");
      final response = await client.post(
        "${PosUrls.editVariantImageUrl}$variantId",
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      print('rsponse image dit $response');
      return DoubleResponse(
          response.data['status'] == 'success', response.data['message']);
    } catch (e, l) {
      print("hkjkhfhkjwhdfbjc $e ,$l");
      return DoubleResponse(false, "SomeThing went wrong");
    }
  }

  Future<DoubleResponse> assignToInventory(
      {required int warehouseId,
      required int variantId,
      required int inventoryId,
      required int productId}) async {
    final response = await client.post(
      PosUrls.assignToInventory,
      data: {
        "product_id": productId,
        "variant_id": variantId,
        "warehouse_id": warehouseId,
        "inventory_id": inventoryId,
        "updated_by": ""
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    print("response is ${response.data}");
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
  }

  Future<DoubleResponse> alreadyAssignToInventory(
      {required int warehouseId, required int variantId}) async {
    final response = await client.post(
      PosUrls.alreadyAssignToInventory,
      data: {
        "variant_id": variantId,
        "warehouse_id": warehouseId,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    print("response is ${response.data}");
    if (response.data['status'] == 'success') {
      List<AssignToStock> alreadyAssignedList = [];
      for (var element in response.data['data']['results']) {
        alreadyAssignedList.add(AssignToStock.fromJson(element));
      }

      return DoubleResponse(true, alreadyAssignedList);
    } else {
      return DoubleResponse(
          response.data['status'] == 'success', response.data['message']);
    }
  }

  Future<DoubleResponse> deleteAlreadyAssignToInventory(
      {required int inventoryId, required int variantId}) async {
    final response = await client.post(
      PosUrls.deleteAssignToInventory,
      data: {
        "variant_id": variantId,
        "inventory_id": inventoryId,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    print("response is ${response.data}");
    if (response.data['status'] == 'success') {
      return DoubleResponse(true, response.data['message']);
    } else {
      return DoubleResponse(
          response.data['status'] == 'success', response.data['message']);
    }
  }

//create stock adjustment
  Future<DoubleResponse> deleteVariant({required int variantId}) async {
    final response = await client.delete(
      "${PosUrls.deleteVariant}$variantId",
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    print("response is ${response.data}");
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
  }

  Future<DoubleResponse> createStockAdjustment(
      {required int quantity,
      required String adjustmentType,
      required String reason,
      required int inventoryStockId}) async {
    final response = await client.post(
      PosUrls.createStockAdjustmentUrl,
      data: {
        "quantity": quantity,
        "adjustment_type": adjustmentType,
        "reason": reason,
        "inventory_stock_id": inventoryStockId
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    print("response is stock adjusttt${response.data}");
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
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
    print("responseeee $response");
    StockAllocateModel stockData =
        StockAllocateModel.fromJson(response.data['data']);
    print("responseeee $stockData");

    return DoubleResponse(response.data['status'] == "success", stockData);
  }
  //list variant by inventory for stock adjust

  Future<DoubleResponse> listVariantByInventory() async {
    try {
      final response = await client.get(
        PosUrls.listVariantByInventoryForStockAdjust,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      print("stockn manageb redspsine $response");
      if (response.data['status'] == 'success') {
        List<StockAdjustmentModel> variantList = [];
        for (var element in response.data['data']['results']) {
          variantList.add(StockAdjustmentModel.fromJson(element));
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

  Future<PaginatedResponse> getAllVariants(
      {String? element, bool? fromWarehouse, String? id,int? pageNo}) async {
    try {
      print("skfjhjc $pageNo");
      print("${PosUrls.varientList}?element=$element");
    String path=  authentication.authenticatedUser.userType ==
          "wmanager"
          ? "${PosUrls.varientListInWareHouse}${authentication.authenticatedUser.businessData?.businessId}?element=$element&page=$pageNo"
          : "${PosUrls.varientList}?element=$element&page=$pageNo";
      final response = await client.get(
        path,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      print("response of variant is ${response.data}");
      if (response.data['status'] == 'success') {
        List<VariantsListModel> variantList = [];
        for (var element in response.data['data']['results']) {
          variantList.add(VariantsListModel.fromJson(element));
        }

        return PaginatedResponse(true,variantList,response.data['data']['next'],response.data['data']['count'].toString());
      } else {
        // If the response status is not 'success', handle the error here
        return PaginatedResponse(false,null,null,null);
      }
    } catch (e) {
      // If an exception occurs during the request, handle it here
      print("Error fetching products: $e");
      return PaginatedResponse(false,null,null,null);
    }
  }

  Future<DoubleResponse> getVariantDetails({required int id}) async {
    try {
      final response = await client.get(
        "${PosUrls.varientDetails}$id",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      print("response of variant is ${response.data}");
      if (response.data['status'] == 'success') {
        VariantsListModel variantList;
        variantList = VariantsListModel.fromJson(response.data['data']);

        return DoubleResponse(true, variantList);
      } else {
        // If the response status is not 'success', handle the error here
        return DoubleResponse(false, response.data['message']);
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

  Future<DoubleResponse> getAllAttribute() async {
    try {
      final response = await client.get(
        PosUrls.attributeList,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.data['status'] == 'success') {
        List<AttributeList> variantList = [];
        for (var element in response.data['data']['results']) {
          variantList.add(AttributeList.fromJson(element));
        }

        return DoubleResponse(true, variantList);
      } else {
        // If the response status is not 'success', handle the error here
        return DoubleResponse(false, null);
      }
    } catch (e, l) {
      // If an exception occurs during the request, handle it here
      print("Error fetching attribute: $e ,$l");
      return DoubleResponse(
        false,
        null,
      );
    }
  }
}
