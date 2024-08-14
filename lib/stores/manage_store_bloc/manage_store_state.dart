part of 'manage_store_bloc.dart';

abstract class ManageStoreState extends Equatable {
  const ManageStoreState();
  
  @override
  List<Object> get props => [];
}

final class ManageStoreInitial extends ManageStoreState {}



class ListStoresInitial extends ManageStoreState {}

class ListStoresLoading extends ManageStoreState {}

class ListStoresSuccess extends ManageStoreState {
final   PaginatedResponse stores ;
 const ListStoresSuccess({required this.stores});
}

class ListStoresFailed extends ManageStoreState {}

class SearchStoresInitial extends ManageStoreState {}

class SearchStoresLoading extends ManageStoreState {}

class SearchStoresSuccess extends ManageStoreState {
final   PaginatedResponse stores ;
 const SearchStoresSuccess({required this.stores});
}

class SearchStoresFailed extends ManageStoreState {}
class ListStoresUnderWareHouseLoading extends ManageStoreState {}

class ListStoresUnderWareHouseSuccess extends ManageStoreState {
final  List<InventoryId> productList ;
const ListStoresUnderWareHouseSuccess({required this.productList});
}

class ListStoresUnderWareHouseFailed extends ManageStoreState {}
class ListStockAdjustmentByAdminLoading extends ManageStoreState {}

class ListStockAdjustmentByAdminSuccess extends ManageStoreState {
final  List<StockAdjustmentListAdminModel> variantList ;
const ListStockAdjustmentByAdminSuccess({required this.variantList});
}

class ListStockAdjustmentByAdminFailed extends ManageStoreState {}

class ListReceivingStockInventoryLoading extends ManageStoreState {}

class ListReceivingStockInventorySuccess extends ManageStoreState {
 final List<ReceiveStockModel> variantList;
const ListReceivingStockInventorySuccess({required this.variantList});
}

class ListReceivingStockInventoryFailed extends ManageStoreState {}

class CreateStoreInitial extends ManageStoreState {}

class CreateStoreLoading extends ManageStoreState {}

class CreateStoreSuccess extends ManageStoreState {
  final String message;
  const CreateStoreSuccess({required this.message});
}

class CreateStoreFailed extends ManageStoreState {
  final String message;
  const CreateStoreFailed({required this.message});
}