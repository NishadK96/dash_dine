part of 'manager_bloc.dart';

@immutable
abstract class ManagerEvent extends Equatable {
  const ManagerEvent();
  @override
  List<Object> get props => [];
}

class GetAllMangers extends ManagerEvent {
  final String managerType;
  final String? searchKey;
  final String? wareHouseId;
  const GetAllMangers({required this.managerType,this.wareHouseId,this.searchKey});
}

class CreateManager extends ManagerEvent {
  final String managerType;
  final String fName;
  final String lName;
  final String contact;
  final String email;
  final String password;
  final int? wareHouseId;
  final int? storeId;
  const CreateManager(
      {required this.managerType,
      required this.fName,
      required this.lName,
      required this.password,
      required this.contact,
      required this.email,
      this.wareHouseId,
      this.storeId});
}

class EditManager extends ManagerEvent {
  final String managerType;
  final String fName;
  final String lName;
  final String contact;
   final String userId;
  final String email;
  // final int? wareHouseId;
  // final int? storeId;
  const EditManager(
      {required this.managerType,
      required this.fName,
      required this.lName,
      required this.contact,
      required this.userId,
      required this.email,
      // this.wareHouseId,
      // this.storeId
      });
}
