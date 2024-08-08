

import 'package:dio/dio.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/auth/models/user_model.dart';
import 'package:pos_app/utils/data_response.dart';
import 'package:pos_app/utils/urls.dart';

class UserDataSource {
  Dio client = Dio();
 
  Future<DoubleResponse> userLogin(
      {required String password, required String contact}) async {
    UserModel authenticatedUser;

    final response = await client.post(
      PosUrls.loginUrl,
      data: {
        "email": contact,
        "password": password,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.data['status'] == true) {
      authenticatedUser = UserModel.fromJson(response.data);

      if (authenticatedUser.access != null) {

        await authentication.saveAuthenticatedUser(
            authenticatedUser: authenticatedUser);

      }
    }
    return DoubleResponse(
      
        response.data['status'] == true, response.data['message']);
  } Future<DoubleResponse> changePassword(
      {required String password, required String id}) async {
    UserModel authenticatedUser;

    final response = await client.post(
      "${PosUrls.changePassword}$id/reset-password/",
      data: {
        "password": password,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':"Bearer ${authentication.authenticatedUser.access}"
        },
      ),
    );

    if (response.data['status'] == true) {
      return DoubleResponse(
          true, "Password Changed Successfully");
    }else
      {
        return DoubleResponse(
            false, "Something went wrong!");
      }

  }
}
