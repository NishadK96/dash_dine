import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/warehouse/data/warehouse_datasource.dart';
import 'package:pos_app/warehouse/models/warehouse_model.dart';

part 'manage_warehouse_event.dart';
part 'manage_warehouse_state.dart';

class ManageWarehouseBloc extends Bloc<ManageWarehouseEvent, ManageWarehouseState> {
  final WareHouseDataSource _dataSource = WareHouseDataSource();

  ManageWarehouseBloc() : super(ManageWarehouseInitial()) ;

    @override
  Stream<ManageWarehouseState> mapEventToState(ManageWarehouseEvent event) async* {
    if (event is GetAllWarehouses) {
      yield* getAllWarehouses(event.searchKey??"");
    } 
    else if (event is CreateWareHouse) {
      yield* createWareHouse(
          name: event.name,
          address: event.address,
          city: event.city,
          email: event.email,
          phone: event.phone
          );
    }
   }
    Stream<ManageWarehouseState> getAllWarehouses(String searchKey) async* {
    yield ListWareHouseLoading();
    final dataResponse = await _dataSource.getAllWarehouses(searchKey);
    if (dataResponse.data1) {
      yield ListWareHouseSuccess(productList: dataResponse.data2);
    } else {
      yield ListWareHouseFailed();
    }
  }

  Stream<ManageWarehouseState> createWareHouse({
    required String name,
    required String address,
    required String city,
     required String phone,
    required String email,
  }) async* {
    yield CreateWareHouseLoading();
    final dataResponse = await _dataSource.createWareHouse(
        name: name,
        address: address,
        city: city,
        email: email,
        phone: phone
        );
    if (dataResponse.data1) {
      yield CreateWareHouseSuccess(message: dataResponse.data2);
    } else {
      yield CreateWareHouseFailed(message: dataResponse.data2);
    }
  }
}
