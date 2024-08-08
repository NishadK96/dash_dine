import 'package:dio/dio.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/utils/data_response.dart';
import 'package:pos_app/utils/urls.dart';
import 'package:pos_app/variants/model/orderDetails.dart';
import 'package:pos_app/variants/model/order_lines.dart';

class CartDataSource {
  Dio client = Dio();

  Future<DoubleResponse> getAllOrderHistory({bool? costing}) async {
    try {

      final response = await client.get(
        PosUrls.listOrderHistory,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.data['status'] == 'success') {
        List<OrderDetailsModel> historyList = [];
        for (var element in response.data['data']['results']) {
          historyList.add(OrderDetailsModel.fromJson(element));
        }

        return DoubleResponse(true, historyList);
      } else {
        // If the response status is not 'success', handle the error here
        return DoubleResponse(false, response.data['message']);
      }
    } catch (e) {
      // If an exception occurs during the request, handle it here
      return DoubleResponse(
        false,
        null,
      );
    }
  }

  Future<DoubleResponse> getAllOrderDetails(
      {required int orderId, required int inventoryId}) async {
    try {

      final response = await client.get(
        "${PosUrls.orderDetails}$orderId/$inventoryId",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.data['status'] == 'success') {
        OrderDetailsModel historyList;
        historyList=OrderDetailsModel.fromJson(response.data['data']);

        return DoubleResponse(true, historyList);
      } else {
        // If the response status is not 'success', handle the error here
        return DoubleResponse(false, response.data['message']);
      }
    } catch (e) {
      // If an exception occurs during the request, handle it here
      return DoubleResponse(
        false,
        null,
      );
    }
  }

  Future<DoubleResponse> createOrder({
    required String personName,
    required String phoneNumber,
    required String deliveryNote,
    required double totalPrice,
    required List<OrderLines> orderLines,
  }) async {
    final response = await client.post(
      PosUrls.createOrder,
      data: {
        "phone_number": phoneNumber,
        "customer_name": personName,
        "inventory_id": authentication.authenticatedUser.businessData?.businessId,
        "total_price": totalPrice,
        "order_lines": orderLines,
        "delivery_note": deliveryNote
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    if(response.data['status'] == 'success') {
      return DoubleResponse(
          response.data['status'] == 'success', response.data['order_id'].toString());
    }else
      {
        return DoubleResponse(
            response.data['status'] == 'success', response.data['message']);
      }
  }
  Future<DoubleResponse> editOrder({
    required String personName,
    required String phoneNumber,
    required String deliveryNote,
    required double totalPrice,
    required int orderId,
    required List<OrderLines> orderLines,
  }) async {
    final response = await client.patch(
      PosUrls.editOrder,
      data: {
        "order_id":orderId,
        "phone_number": phoneNumber,
        "customer_name": personName,
        "inventory_id": authentication.authenticatedUser.businessData?.businessId,
        "total_price": totalPrice,
        "order_lines": orderLines,
        "delivery_note": deliveryNote,
  
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
}
