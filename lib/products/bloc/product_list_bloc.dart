import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/products/data/data_source.dart';
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/variants/model/variant_model.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductDataSource _dataSource = ProductDataSource();
  ProductListBloc() : super(ProductListInitial());
  @override
  Stream<ProductListState> mapEventToState(ProductListEvent event) async* {
    if (event is GetAllProducts) {
      yield* getAllProducts(underWareHouse: event.underWareHouse,costing:  event.costing,inventoryId: event.inventoryId,isInventory: event.isInventory,element: event.element,fromOrder: event.fromOrder);
    }
    if (event is GetVariantByProduct) {
      yield* listVariantByProduct(productId: event.productId);
    }
    else if (event is CreateProductEvent) {
      yield* createProduct(
          name: event.name,
          description: event.description,
          updatedBy: event.updatedBy,
          image: event.image,
          costingType: event.costingType);
    }
    else if (event is CreateAttributeEvent) {
      yield* createAttribute(
          name: event.name,
          description: event.description,
          image: event.image,);
    }
     else if (event is GetAllAttributes) {
      yield* getAllAttributes();
    }
  }

  Stream<ProductListState> getAllProducts({bool? underWareHouse,bool? costing,bool? isInventory,int? inventoryId,String? element,bool? fromOrder}) async* {
    yield ProductListLoading();
    final dataResponse = await _dataSource.getAllProducts(costing: costing,inventoryId: inventoryId,isInventory: isInventory??false,underWareHouse: underWareHouse??false,element:element??"",fromOrder: fromOrder);
    if (dataResponse.data1) {
      yield ProductListSuccess(productList: dataResponse.data2);
    } else {
      yield ProductListFailed();
    }
  }

  Stream<ProductListState> listVariantByProduct({required int productId}) async* {
    yield VariantByProductLoading();
    final dataResponse = await _dataSource.listVariantByProduct(productId: productId);
    if (dataResponse.data1) {
      yield VariantByProductSuccess(variantList: dataResponse.data2);
    } else {
      yield VariantByProductFailed();
    }
  }

  Stream<ProductListState> createProduct({
    required String name,
    required String description,
    required String updatedBy,
    required File image,
    required String costingType,
  }) async* {
    yield CreateProductLoading();
    final dataResponse = await _dataSource.createProduct(
        name: name,
        description: description,
        updatedBy: updatedBy,
        image: image,
        costingType: costingType);
    if (dataResponse.data1) {
      yield CreateProductSuccess(message: dataResponse.data2);
    } else {
      yield CreateProductFailed(message: dataResponse.data2);
    }
  }
  Stream<ProductListState> createAttribute({
    required String name,
    required String description,
    required File image,
  }) async* {
    yield CreateAttributeLoading();
    final dataResponse = await _dataSource.createAttribute(
        name: name,
        description: description,
        image: image,);
    if (dataResponse.data1) {
      yield CreateAttributeSuccess(message: dataResponse.data2);
    } else {
      yield CreateAttributeFailed(message: dataResponse.data2);
    }
  }

  Stream<ProductListState> getAllAttributes() async* {
    yield AttributeListLoading();
    final dataResponse = await _dataSource.getAllAttributes();
    if (dataResponse.data1) {
      yield AttributeListSuccess(productList: dataResponse.data2);
    } else {
      yield AttributeListFailed();
    }
  }
}
