part of 'variant_bloc.dart';

abstract class VariantState extends Equatable {
  const VariantState();
  @override
  List<Object> get props => [];
}

final class VariantInitial extends VariantState {}

class VariantsListInitial extends VariantState {}

class VariantsListLoading extends VariantState {}

class VariantsListSuccess extends VariantState {
  PaginatedResponse variantsList;
  VariantsListSuccess({required this.variantsList});
}

class VariantsListFailed extends VariantState {}
class AlreadyAssignedInventoryLoading extends VariantState {}

class AlreadyAssignedInventorySuccess extends VariantState {
  List<AssignToStock> alreadyAssignedList = [];
  AlreadyAssignedInventorySuccess({required this.alreadyAssignedList});
}

class AlreadyAssignedInventoryFailed extends VariantState {}
class VariantsListForStockAdjustInitial extends VariantState {}

class VariantsListForStockAdjustLoading extends VariantState {}

class VariantsListForStockAdjustSuccess extends VariantState {
final  List<StockAdjustmentModel> variantsList;
const  VariantsListForStockAdjustSuccess({required this.variantsList});
}

class VariantsListForStockAdjustFailed extends VariantState {}
class VariantsListForStockAllocateInitial extends VariantState {}

class VariantsListForStockAllocateLoading extends VariantState {}

class VariantsListForStockAllocateSuccess extends VariantState {
final  StockAllocateModel variantsList;
const  VariantsListForStockAllocateSuccess({required this.variantsList});
}

class VariantsListForStockAllocateFailed extends VariantState {}

class AttributesListLoading extends VariantState {}

class AttributesListSuccess extends VariantState {
  List<AttributeList> attributeList = [];
  AttributesListSuccess({required this.attributeList});
}

class AttributesListFailed extends VariantState {}

class CreateVariantInitial extends VariantState {}

class CreateVariantLoading extends VariantState {}

class CreateVariantSuccess extends VariantState {
  final String message;
  const CreateVariantSuccess({required this.message});
}

class CreateVariantFailed extends VariantState {
  final String message;
  const CreateVariantFailed({required this.message});
}
class DeleteVariantLoading extends VariantState {}

class DeleteVariantSuccess extends VariantState {
final String message;
const DeleteVariantSuccess({required this.message});
}

class DeleteVariantFailed extends VariantState {
final String message;
const DeleteVariantFailed({required this.message});
}