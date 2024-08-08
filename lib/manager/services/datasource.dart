import 'package:dio/dio.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/manager/services/model/model.dart';
import 'package:pos_app/utils/data_response.dart';
import 'package:pos_app/utils/urls.dart';

class ManagerDataSource {
  Dio client = Dio();

  Future<DoubleResponse> createManager(
      {required String managerType,
      required String fName,
      required String lName,
      required String contact,
      required String password,
      required String email,
      int? wareHouseId,
      int? storeId}) async {
    try {
      final response = await client.post(
        PosUrls.userCreationUrl,
        data: {
          "warehouse": wareHouseId,
          "store": storeId ?? 0,
          "email": email,
          "contact_number": contact,
          "first_name": fName,
          "last_name": lName,
          "user_type": managerType,
          "password": password
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return DoubleResponse(true, response.data['message']);
      } else {
        return DoubleResponse(false, response.data['message']);
      }
    } catch (e) {
      return DoubleResponse(
        false,
        null,
      );
    }
  }

  Future<DoubleResponse> editManager({
    required String managerType,
    required String fName,
    required String lName,
    required String userId,
    required String contact,
    required String email,
    // int? wareHouseId,
    // int? storeId
  }) async {
    try {
      final response = await client.put(
        "${PosUrls.userEditUrl}$userId/",
        data: {
          "email": email,
          "contact_number": contact,
          "first_name": fName,
          "last_name": lName,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': "Bearer ${authentication.authenticatedUser.access}"
          },
        ),
      );
      if (response.data['status'] == true) {
        return DoubleResponse(true, "Edited Succesfully!");
      } else {
        // If the response status is not 'success', handle the error here
        return DoubleResponse(false, "Oops Something Went Wrong!");
      }
    } catch (e) {
      // If an exception occurs during the request, handle it here
      return DoubleResponse(
        false,
        null,
      );
    }
  }

  Future<DoubleResponse> deleteManager({
    required String userId,
  }) async {
    try {
      final response = await client.delete(
        "${PosUrls.userEditUrl}$userId/",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Authorization':"Bearer ${authentication.authenticatedUser.access}"
          },
        ),
      );
      if (response.statusCode == 204) {
        return DoubleResponse(true, "Deleted Successfully!");
      } else {
        // If the response status is not 'success', handle the error here
        return DoubleResponse(false, "Something went wrong :(");
      }
    } catch (e) {
      // If an exception occurs during the request, handle it here
      return DoubleResponse(
        false,
        null,
      );
    }
  }

  Future<DoubleResponse> getAllManagers(
      {required String managerType,
      String? wareHouseId,
      String? searchKey}) async {
    try {
      final response = await client.get(
        wareHouseId == null || wareHouseId == ""
            ? "${PosUrls.listManagers}$managerType"
            : "${PosUrls.listManagers}$managerType&warehouse_id=$wareHouseId?search_name=$searchKey",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        List<ManagerList> managerList = [];
        for (var element in response.data['results']) {
          managerList.add(ManagerList.fromJson(element));
        }

        return DoubleResponse(true, managerList);
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

  //delete manager
}
