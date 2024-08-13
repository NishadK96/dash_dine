part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();
  @override
  List<Object> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListSuccess extends ProductListState {
final  PaginatedResponse productList;
 const ProductListSuccess({required this.productList});
}

class ProductListFailed extends ProductListState {}

class VariantByProductLoading extends ProductListState {}

class VariantByProductSuccess extends ProductListState {
  final  List<VariantsListModel> variantList;
  const VariantByProductSuccess({required this.variantList});
}

class VariantByProductFailed extends ProductListState {}

class CreateProductInitial extends ProductListState {}

class CreateProductLoading extends ProductListState {}

class CreateProductSuccess extends ProductListState {
  final String message;
  const CreateProductSuccess({required this.message});
}

class CreateProductFailed extends ProductListState {
  final String message;
  const CreateProductFailed({required this.message});
}
class CreateAttributeInitial extends ProductListState {}

class CreateAttributeLoading extends ProductListState {}

class CreateAttributeSuccess extends ProductListState {
  final String message;
  const CreateAttributeSuccess({required this.message});
}

class CreateAttributeFailed extends ProductListState {
  final String message;
  const CreateAttributeFailed({required this.message});
}

class AttributeListInitial extends ProductListState {}

class AttributeListLoading extends ProductListState {}

class AttributeListSuccess extends ProductListState {
 final List<ProductList> productList;
 const AttributeListSuccess({required this.productList});
}

class AttributeListFailed extends ProductListState {}