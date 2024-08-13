part of 'manage_store_bloc.dart';

abstract class ManageStoreEvent extends Equatable {
  const ManageStoreEvent();

  @override
  List<Object> get props => [];
}

class GetAllStores extends ManageStoreEvent {
 final String? searchKey;
  final String? warehouseId;
  final int? pageNo;
  GetAllStores({this.searchKey, this.warehouseId,this.pageNo});
}
class GetListReceivingStockInventory extends ManageStoreEvent {

}
class ListStockAdjustmentByAdmin extends ManageStoreEvent {

}

class GetAllStoresUserWareHouse extends ManageStoreEvent {
  final int warehouseId;
  final int variantId;
  const GetAllStoresUserWareHouse(
      {required this.warehouseId, required this.variantId});
}

class CreateStore extends ManageStoreEvent {
  final String name;
  final String email;
  final int wareHouseId;
  final String phone;
  final String address;
  final String city;
  const CreateStore({
    required this.name,
    required this.address,
    required this.city,
    required this.email,
    required this.phone,
    required this.wareHouseId
  });
}
