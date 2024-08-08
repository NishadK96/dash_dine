import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pos_app/manager/services/datasource.dart';
import 'package:pos_app/manager/services/model/model.dart';

part 'manager_event.dart';
part 'manager_state.dart';

class ManagerBloc extends Bloc<ManagerEvent, ManagerState> {
  final ManagerDataSource _dataSource = ManagerDataSource();
  ManagerBloc() : super(ManagerInitial());
  @override
  Stream<ManagerState> mapEventToState(ManagerEvent event) async* {
    if (event is GetAllMangers) {
      yield* getAllManagers(
          managerType: event.managerType,
          wareHouseId: event.wareHouseId,
          searchKey: event.searchKey);
    }
    if (event is CreateManager) {
      yield* createManager(
          managerType: event.managerType,
          fName: event.fName,
          lName: event.lName,
          contact: event.contact,
          email: event.email,
          wareHouseId: event.wareHouseId,
          storeId: event.storeId,
          password: event.password);
    }
    if (event is EditManager) {
      yield* editManager(
        userId: event.userId,
        managerType: event.managerType,
        fName: event.fName,
        lName: event.lName,
        contact: event.contact,
        email: event.email,
        // wareHouseId: event.wareHouseId,
        // storeId: event.storeId,
      );
    }
  }

  Stream<ManagerState> getAllManagers(
      {required String managerType,
      String? wareHouseId,
      String? searchKey}) async* {
    yield ManagerListLoading();
    final dataResponse = await _dataSource.getAllManagers(
        managerType: managerType,
        wareHouseId: wareHouseId,
        searchKey: searchKey);
    if (dataResponse.data1) {
      yield ManagerListSuccess(managerList: dataResponse.data2);
    } else {
      yield ManagerListFailed();
    }
  }

  Stream<ManagerState> createManager(
      {required String managerType,
      required String fName,
      required String lName,
      required String contact,
      required String password,
      required String email,
      int? wareHouseId,
      int? storeId}) async* {
    yield ManagerCreationLoading();
    final dataResponse = await _dataSource.createManager(
        managerType: managerType,
        fName: fName,
        lName: lName,
        contact: contact,
        email: email,
        wareHouseId: wareHouseId,
        storeId: storeId,
        password: password);
    if (dataResponse.data1) {
      yield ManagerCreationSuccess(message: dataResponse.data2);
    } else {
      yield ManagerCreationFailed(message: dataResponse.data2);
    }
  }

  Stream<ManagerState> editManager({
    required String managerType,
    required String fName,
    required String lName,
    required String userId,
    required String contact,
    required String email,
    // int? wareHouseId,
    // int? storeId
  }) async* {
    yield ManagerEditLoading();
    final dataResponse = await _dataSource.editManager(
      userId: userId,
      managerType: managerType,
      fName: fName,
      lName: lName,
      contact: contact,
      email: email,
      // wareHouseId: wareHouseId,
      // storeId: storeId,
    );
    if (dataResponse.data1) {
      yield ManagerEditSuccess(message: dataResponse.data2);
    } else {
      yield ManagerEditFailed(message: dataResponse.data2);
    }
  }
}
