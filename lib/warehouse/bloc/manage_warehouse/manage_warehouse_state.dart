part of 'manage_warehouse_bloc.dart';

abstract class ManageWarehouseState extends Equatable {
  const ManageWarehouseState();
  
  @override
  List<Object> get props => [];
}

class ManageWarehouseInitial extends ManageWarehouseState {}

class ListWareHouseInitial extends ManageWarehouseState {}

class ListWareHouseLoading extends ManageWarehouseState {}

class ListWareHouseSuccess extends ManageWarehouseState {
final  List<WareHouseModel> productList ;
 const ListWareHouseSuccess({required this.productList});
}

class ListWareHouseFailed extends ManageWarehouseState {}

class CreateWareHouseInitial extends ManageWarehouseState {}

class CreateWareHouseLoading extends ManageWarehouseState {}

class CreateWareHouseSuccess extends ManageWarehouseState {
  final String message;
  const CreateWareHouseSuccess({required this.message});
}

class CreateWareHouseFailed extends ManageWarehouseState {
  final String message;
  const CreateWareHouseFailed({required this.message});
}
