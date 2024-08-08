part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class CreateOrderEvent extends CartEvent {
  final String personName;
  final String phoneNumber;
  final String deliveryNote;
  final double totalPrice;
  final List<OrderLines> orderLines;
  const CreateOrderEvent(
      {required this.totalPrice,
      required this.phoneNumber,
      required this.deliveryNote,
      required this.orderLines,
      required this.personName});
}

class GetAllOrderHistory extends CartEvent {}

class GetOrderDetails extends CartEvent {
  final int orderId;
  final int inventoryId;
  const GetOrderDetails({required this.inventoryId, required this.orderId});
}
