part of 'variant_bloc.dart';

abstract class VariantEvent extends Equatable {
  const VariantEvent();
  @override
  List<Object> get props => [];
}

class GetAllVariants extends VariantEvent
{
  bool? fromWarehouse;
  String? id;
  int? pageNo;
  final String? element;
  GetAllVariants({this.element,this.id,this.fromWarehouse,this.pageNo});}
class GetAllVariantsByInventoryForStockAdjust extends VariantEvent
{}
class GetAllVariantsByInventoryForStockAllocate extends VariantEvent
{
  final int? variantId;
  final int? wareHouseId;
  GetAllVariantsByInventoryForStockAllocate({this.variantId,this.wareHouseId});
}class GetAlreadyAssignedInventory extends VariantEvent
{
  final int variantId;
  final int wareHouseId;
  GetAlreadyAssignedInventory({required this.variantId,required this.wareHouseId});
}
class GetAllAttributeList extends VariantEvent
{}
class CreateVariantEvent extends VariantEvent{
  final File? image;
  final String description;
  final String updatedBy;
  final String stockType;
  final String name;
  final List<int> attributeIDs;
  final int productId;
  const CreateVariantEvent(
      {required this.stockType,
      required this.productId,
      required this.attributeIDs,
      this.image,
      required this.updatedBy,
      required this.description,
      required this.name});
}

class DeleteVariantEvent extends VariantEvent {
  final int variantId;
  const DeleteVariantEvent({required this.variantId});
}
