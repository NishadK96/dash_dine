part of 'product_list_bloc.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();
  @override
  List<Object> get props => [];
}

class GetAllProducts extends ProductListEvent
{
  final String? element;
  final bool costing;
  final bool? isInventory;
  final bool? underWareHouse;
  final bool? fromOrder;
  final int? inventoryId;
  const GetAllProducts({this.element,this.costing=false,this.underWareHouse,this.isInventory, this.inventoryId,this.fromOrder});}

class GetVariantByProduct extends ProductListEvent
{
  final int productId;
  const GetVariantByProduct({required this.productId});
}

class GetAllAttributes extends ProductListEvent
{}

class CreateProductEvent extends ProductListEvent{
  final File image;
  final String description;
  final String updatedBy;
  final String costingType;
  final String name;
  const CreateProductEvent({required this.costingType,required this.image,required this.updatedBy,required this.description,required this.name});

}
class CreateAttributeEvent extends ProductListEvent{
  final File image;
  final String description;
  final String name;
  const CreateAttributeEvent({required this.image,required this.description,required this.name});

}