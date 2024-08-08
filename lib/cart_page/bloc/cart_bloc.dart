import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/cart_page/service/data_source.dart';
import 'package:pos_app/variants/model/orderDetails.dart';
import 'package:pos_app/variants/model/order_lines.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartDataSource _dataSource = CartDataSource();
  CartBloc() : super(CartInitial());
  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if(event is CreateOrderEvent)
      {
        yield* createVariant(personName: event.personName, phoneNumber: event.phoneNumber, totalPrice: event.totalPrice, orderLines: event.orderLines,deliveryNote: event.deliveryNote);
      }
    if (event is GetAllOrderHistory) {
      yield* getAllOrderHistory();
    }
    if (event is GetOrderDetails) {
      yield* getOrderDetails(event.orderId,event.inventoryId);
    }
  }


  Stream<CartState> getAllOrderHistory() async* {
    yield OrderHistoryLoading();
    final dataResponse = await _dataSource.getAllOrderHistory();
    if (dataResponse.data1) {
      yield OrderHistorySuccess(orderHistoryList: dataResponse.data2);
    } else {
      yield OrderHistoryFailed(message: dataResponse.data2);
    }
  }
  Stream<CartState> getOrderDetails(int orderId,int inventoryId) async* {
    yield OrderDetailsLoading();
    final dataResponse = await _dataSource.getAllOrderDetails(orderId: orderId, inventoryId: inventoryId);
    if (dataResponse.data1) {
      yield OrderDetailsSuccess(orderHistoryList: dataResponse.data2);
    } else {
      yield OrderDetailsFailed(message: dataResponse.data2);
    }
  }

  Stream<CartState> createVariant(
      {    required String personName,
        required String phoneNumber,
        required String deliveryNote,
        required double totalPrice,
        required List<OrderLines> orderLines,}) async* {
    yield CreateOrderLoading();
    final dataResponse = await _dataSource.createOrder(personName: personName, phoneNumber: phoneNumber, totalPrice: totalPrice, orderLines: orderLines,deliveryNote: deliveryNote);
    if (dataResponse.data1) {
      yield CreateOrderSuccess(orderId: dataResponse.data2);
    } else {
      yield CreateOrderFailed(message: dataResponse.data2);
    }
  }
}
