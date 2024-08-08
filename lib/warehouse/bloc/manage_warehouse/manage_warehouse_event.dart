part of 'manage_warehouse_bloc.dart';

abstract class ManageWarehouseEvent extends Equatable {
  const ManageWarehouseEvent();

  @override
  List<Object> get props => [];
}


class GetAllWarehouses extends ManageWarehouseEvent
{
  String? searchKey;
  GetAllWarehouses(this.searchKey);
}
class CreateWareHouse extends ManageWarehouseEvent{
  final String address;
  final String city;
  final String name;
  final String phone;
  final String email;
  const CreateWareHouse({required this.city,required this.name,required this.address,required this.email,required this.phone});

}
