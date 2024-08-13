import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/utils/data_response.dart';
import 'package:pos_app/utils/urls.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pos_app/variants/model/variant_model.dart';

class ProductDataSource {
  Dio client = Dio();
Future<DoubleResponse> editProduct({
    required String name,
    required String description,
     required int id,
    required String updatedBy,
     File? image,
    required String costingType,
  }) async {
print("jhashvxgjehjsyhdxjheshydxkj $image");
 final FormData formData;
if(image!=null){
    String filePath = "";
    filePath = image!.path;    
    final mime = lookupMimeType(filePath)!.split("/");
    final fileData = await MultipartFile.fromFile(filePath,
        contentType: MediaType(mime.first, mime.last));
        

     formData = FormData.fromMap({
      "image":image==null? null:fileData,
      "name": name,
      "description": description,
      "updated_by": updatedBy,
      "costing_type": costingType
    });
}else{
    formData = FormData.fromMap({
      "image":null,
      "name": name,
      "description": description,
      "updated_by": updatedBy,
      "costing_type": costingType
    });
}
    final response = await client.patch(
      "${PosUrls.deleteProduct}$id",
      data:image==null? {
       "image":null,
      "name": name,
      "description": description,
      "updated_by": updatedBy,
      "costing_type": costingType

      }:formData,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
  }
  Future<DoubleResponse> createProduct({
    required String name,
    required String description,
    required String updatedBy,
    required File image,
    required String costingType,
  }) async {
    String filePath = "";
    filePath = image.path;
    
    final mime = lookupMimeType(filePath)!.split("/");
    final fileData = await MultipartFile.fromFile(filePath,
        contentType: MediaType(mime.first, mime.last));
    final FormData formData = FormData.fromMap({
      "image": fileData,
      "name": name,
      "description": description,
      "updated_by": updatedBy,
      "costing_type": costingType
    });

    final response = await client.post(
      PosUrls.createProduct,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
  }
 Future<DoubleResponse>deleteProduct({
    required String productId,
  }) async {
    final response = await client.delete(
      "${PosUrls.deleteProduct}$productId",
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
  }
  //creare costing

  Future<DoubleResponse> createCosting({
    required int prodId,
    required int inventoryId,
    required double sellingPrice,
    required String costingName,
  }) async {
    final response = await client.post(
      PosUrls.createCosting,
      data: {
        "product_id": prodId,
        "inventory_id": inventoryId,
        "selling_price": sellingPrice,
        "costing_name": costingName
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
  }

  Future<DoubleResponse> createAttribute({
    required String name,
    required String description,
    required File image,
  }) async {
    // String filePath = "";
    // filePath = image.path;
    // final mime = lookupMimeType(filePath)!.split("/");
    // final fileData = await MultipartFile.fromFile(filePath,
    //     contentType: MediaType(mime.first, mime.last));
    final FormData formData = FormData.fromMap(
        {"name": name, "description": description});

    final response = await client.post(
      PosUrls.createAttribute,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
  }
Future<DoubleResponse> editAttribute({
    required String name,
    required String description,
    required int id,
  }) async {
    // String filePath = "";
    // filePath = image.path;
    // final mime = lookupMimeType(filePath)!.split("/");
    // final fileData = await MultipartFile.fromFile(filePath,
    //     contentType: MediaType(mime.first, mime.last));
    final FormData formData = FormData.fromMap(
        {"name": name, "description": description});

    final response = await client.patch(
      "${PosUrls.editAttribute}$id",
      data: {"name": name, "description": description},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
  }
Future<DoubleResponse> deleteAttribute({
    required int id
  }) async {
    final response = await client.delete(
      "${PosUrls.editAttribute}$id",
    
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return DoubleResponse(
        response.data['status'] == 'success', response.data['message']);
  }
  Future<PaginatedResponse> getAllProducts(
      {bool? costing, bool? isInventory, int? inventoryId,String element="",bool? fromOrder,bool? underWareHouse,int? pageNo}) async {
    try {
      String path =underWareHouse==true? "${PosUrls.listProductForWareHouse}$inventoryId":fromOrder==true? "${PosUrls.listProductForInventory}$inventoryId":costing == true
          ? PosUrls.listProductsForCosting
          : isInventory == true
              ? PosUrls.productListByInventory + inventoryId.toString()
              : "${PosUrls.productList}?element=$element&page=$pageNo";
     print("searchingggg $path");
      final response = await client.get(
        path,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
     print("searchingggg $response");

      if (response.data['status'] == 'success') {
        List<ProductList> productList = [];
        for (var element in response.data['data']['results']) {
          productList.add(ProductList.fromJson(element));
        }

        return PaginatedResponse(true,productList,response.data['data']['next'],response.data['data']['count'].toString());
      } else {
        // If the response status is not 'success', handle the error here
        return PaginatedResponse(false,null,null,null);
      }
    } catch (e) {
      print("eeeeee $e");
      // If an exception occurs during the request, handle it here
      return PaginatedResponse(false,null,null,null);
    }
  }

  Future<DoubleResponse> listVariantByProduct({required int productId}) async {
    try {
      final response = await client.get(
        "${PosUrls.listVariantByProductAndInventoryUrl}${authentication.authenticatedUser.businessData?.businessId}/$productId",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.data['status'] == 'success') {
        List<VariantsListModel> productList = [];
        for (var element in response.data['data']['results']) {
          productList.add(VariantsListModel.fromJson(element));
        }

        return DoubleResponse(true, productList);
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

  Future<DoubleResponse> getAllAttributes() async {
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
        List<ProductList> productList = [];
        for (var element in response.data['data']['results']) {
          productList.add(ProductList.fromJson(element));
        }

        return DoubleResponse(true, productList);
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
