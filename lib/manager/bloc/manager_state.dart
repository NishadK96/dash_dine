part of 'manager_bloc.dart';

@immutable
abstract class ManagerState extends Equatable{
  const ManagerState();
  @override
  List<Object> get props => [];
}

final class ManagerInitial extends ManagerState {}
class ManagerListLoading extends ManagerState {}

class ManagerListSuccess extends ManagerState {
List<ManagerList> managerList = [];
ManagerListSuccess({required this.managerList});
}

class ManagerListFailed extends ManagerState {}
class ManagerCreationLoading extends ManagerState {}

class ManagerCreationSuccess extends ManagerState {
String message;
ManagerCreationSuccess({required this.message});
}

class ManagerCreationFailed extends ManagerState {
String message;
ManagerCreationFailed({required this.message});
}
class ManagerEditLoading extends ManagerState {}

class ManagerEditSuccess extends ManagerState {
String message;
ManagerEditSuccess({required this.message});
}

class ManagerEditFailed extends ManagerState {
String message;
ManagerEditFailed({required this.message});
}