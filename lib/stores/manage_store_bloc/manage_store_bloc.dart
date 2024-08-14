import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/stock_adjustments/data/admin_data_source.dart';
import 'package:pos_app/stock_adjustments/model/stock_adjust_admin_model.dart';
import 'package:pos_app/stores/data/store_data_soure.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/utils/data_response.dart';
import 'package:pos_app/variants/model/assign_model.dart';

part 'manage_store_event.dart';
part 'manage_store_state.dart';

class ManageStoreBloc extends Bloc<ManageStoreEvent, ManageStoreState> {
  final StoreDataSource _dataSource = StoreDataSource();
  final AdminDataSource _adiminDataSource = AdminDataSource();

  ManageStoreBloc() : super(ManageStoreInitial());

  @override
  Stream<ManageStoreState> mapEventToState(ManageStoreEvent event) async* {
    if (event is GetAllStores) {
      yield* getAllStores(searchKey: event.searchKey??"",warehouseId: event.warehouseId,pageNo: event.pageNo??1);
    }
    if (event is GetListReceivingStockInventory) {
      yield* getlistReceivingStockInventory();
    }
    if (event is ListStockAdjustmentByAdmin) {
      yield* listStockAdjustmentByAdmin();
    }
    if (event is GetAllStoresUserWareHouse) {
      yield* getAllStoresUnderWareHouse(event.warehouseId, event.variantId);
    } else if (event is CreateStore) {
      yield* createStore(
          address: event.address,
          city: event.city,
          email: event.email,
          phone: event.phone,
          name: event.name,
          wareHouseId: event.wareHouseId);
    }
  }

  Stream<ManageStoreState> getAllStores(
      {String? searchKey, String? warehouseId, int? pageNo}) async* {
    yield ListStoresLoading();
    final dataResponse = await _dataSource.getAllStores(searchKey: searchKey,warehouseId: warehouseId,pageNo: pageNo);
    if (dataResponse.isSuccess==true) {
      yield ListStoresSuccess(stores: dataResponse);
    } else {
      yield ListStoresFailed();
    }
  }

  Stream<ManageStoreState> getAllStoresUnderWareHouse(
      int warehouseId, int variantId) async* {
    yield ListStoresUnderWareHouseLoading();
    final dataResponse =
        await _dataSource.getAllStoresUnerWareHouse(warehouseId, variantId);
    if (dataResponse.data1) {
      yield ListStoresUnderWareHouseSuccess(productList: dataResponse.data2);
    } else {
      yield ListStoresUnderWareHouseFailed();
    }
  }
  Stream<ManageStoreState> getlistReceivingStockInventory() async* {
    yield ListReceivingStockInventoryLoading();
    final dataResponse =
    await _dataSource.listReceivingStockInventory();
    if (dataResponse.data1) {
      yield ListReceivingStockInventorySuccess(variantList: dataResponse.data2);
    } else {
      yield ListReceivingStockInventoryFailed();
    }
  }Stream<ManageStoreState> listStockAdjustmentByAdmin() async* {
    yield ListStockAdjustmentByAdminLoading();
    final dataResponse =
    await _adiminDataSource.listStockAdjustmentByAdmin();
    if (dataResponse.data1) {
      yield ListStockAdjustmentByAdminSuccess(variantList: dataResponse.data2);
    } else {
      yield ListStockAdjustmentByAdminFailed();
    }
  }


  Stream<ManageStoreState> createStore({
    required String name,
    required int wareHouseId,
    required String email,
    required String phone,
    required String address,
    required String city,
  }) async* {
    yield CreateStoreLoading();
    final dataResponse = await _dataSource.createStore(
      address: address,
      city: city,
      email: email,
      phone: phone,
      name: name,
      wareHouseId: wareHouseId,
    );
    if (dataResponse.data1) {
      yield CreateStoreSuccess(message: dataResponse.data2);
    } else {
      yield CreateStoreFailed(message: dataResponse.data2);
    }
  }
}
