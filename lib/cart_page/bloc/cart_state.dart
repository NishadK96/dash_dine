part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();
  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {
}
class CreateOrderLoading extends CartState {}

class CreateOrderSuccess extends CartState {
final String orderId;
const CreateOrderSuccess({required this.orderId});
}

class CreateOrderFailed extends CartState {
final String message;
const CreateOrderFailed({required this.message});
}
class OrderHistoryLoading extends CartState {}

class OrderHistorySuccess extends CartState {
final List<OrderDetailsModel> orderHistoryList;
const OrderHistorySuccess({required this.orderHistoryList});
}

class OrderHistoryFailed extends CartState {
final String message;
const OrderHistoryFailed({required this.message});
}
class OrderDetailsLoading extends CartState {}

class OrderDetailsSuccess extends CartState {
final OrderDetailsModel orderHistoryList;
const OrderDetailsSuccess({required this.orderHistoryList});
}

class OrderDetailsFailed extends CartState {
final String message;
const OrderDetailsFailed({required this.message});
}