import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/variants/data/data_source.dart';
import 'package:pos_app/variants/model/assign_model.dart';
import 'package:pos_app/variants/model/attribute_model.dart';
import 'package:pos_app/variants/model/stock_adjustment_model.dart';
import 'package:pos_app/variants/model/variant_model.dart';

part 'variant_event.dart';
part 'variant_state.dart';

class VariantBloc extends Bloc<VariantEvent, VariantState> {
  final VariantDataSource _dataSource = VariantDataSource();
  VariantBloc() : super(VariantInitial());
  @override
  Stream<VariantState> mapEventToState(VariantEvent event) async* {
    if (event is GetAllVariants) {
      yield* getAllProducts(element:event.element,fromWarehouse: event.fromWarehouse,id: event.id);
    } 
    else if (event is GetAllAttributeList) {
      yield* getAllAttribute();
    }
    else if (event is GetAlreadyAssignedInventory) {
      yield* getAlreadyAssignedInventory(event.wareHouseId, event.variantId);
    }
    else if (event is GetAllVariantsByInventoryForStockAdjust) {
      yield* getAllVariantsByInventoryForStockAdjust();
    } 
    else if (event is GetAllVariantsByInventoryForStockAllocate) {
      yield* getAllVariantsByInventoryForStockAllocation(variantId: event.variantId,wareHouseId: event.wareHouseId);
    } 
    else if (event is CreateVariantEvent) {
      yield* createVariant(
          name: event.name,
          description: event.description,
          updatedBy: event.updatedBy,
          image: event.image,
          stockType: event.stockType,
          productId: event.productId,
          attributeIDs: event.attributeIDs);
    }
    else if (event is DeleteVariantEvent) {
      yield* deleteVariant(variantId: event.variantId,);
    }
  }

  Stream<VariantState> getAllProducts({String? element,bool? fromWarehouse,String? id}) async* {
    yield VariantsListLoading();
    final dataResponse = await _dataSource.getAllVariants(element:element??"",fromWarehouse: fromWarehouse,id: id);
    if (dataResponse.data1) {
      yield VariantsListSuccess(variantsList: dataResponse.data2);
    } else {
      yield VariantsListFailed();
    }
  }

  Stream<VariantState> createVariant(
      {required String name,
      required String description,
      required String updatedBy,
       File? image,
      required String stockType,
      required List<int> attributeIDs,
      required int productId}) async* {
    yield CreateVariantLoading();
    final dataResponse = await _dataSource.createVariant(
        name: name,
        description: description,
        updatedBy: updatedBy,
        image: image,
        stockType: stockType,
        attributeIDs: attributeIDs,
        productId: productId);
    if (dataResponse.data1) {
      yield CreateVariantSuccess(message: dataResponse.data2);
    } else {
      yield CreateVariantFailed(message: dataResponse.data2);
    }
  }

  Stream<VariantState> deleteVariant(
      {required int variantId}) async* {
    yield DeleteVariantLoading();
    final dataResponse = await _dataSource.deleteVariant(
      variantId: variantId);
    if (dataResponse.data1) {
      yield DeleteVariantSuccess(message: dataResponse.data2);
    } else {
      yield DeleteVariantFailed(message: dataResponse.data2);
    }
  }

  Stream<VariantState> getAllAttribute() async* {
    yield AttributesListLoading();
    final dataResponse = await _dataSource.getAllAttribute();
    if (dataResponse.data1) {
      yield AttributesListSuccess(attributeList: dataResponse.data2);
    } else {
      yield AttributesListFailed();
    }
  }
  Stream<VariantState> getAllVariantsByInventoryForStockAdjust() async* {
    yield VariantsListForStockAdjustLoading();
    final dataResponse = await _dataSource.listVariantByInventory();
    if (dataResponse.data1) {
      yield VariantsListForStockAdjustSuccess(variantsList: dataResponse.data2);
    } else {
      yield VariantsListForStockAdjustFailed();
    }
  }

  Stream<VariantState> getAlreadyAssignedInventory(int warehouseId,int variantId) async* {
    yield AlreadyAssignedInventoryLoading();
    final dataResponse = await _dataSource.alreadyAssignToInventory(warehouseId: warehouseId, variantId: variantId);
    if (dataResponse.data1) {
      yield AlreadyAssignedInventorySuccess(alreadyAssignedList: dataResponse.data2);
    } else {
      yield AlreadyAssignedInventoryFailed();
    }
  }

  Stream<VariantState> getAllVariantsByInventoryForStockAllocation({int? variantId,int? wareHouseId}) async* {
    yield VariantsListForStockAllocateLoading();
    final dataResponse = await _dataSource.readVariantForStockAllocate(variantId: variantId??0,wareHouseId: wareHouseId??0);
    if (dataResponse.data1) {
      yield VariantsListForStockAllocateSuccess(variantsList: dataResponse.data2);
    } else {
      yield VariantsListForStockAllocateFailed();
    }
  }
}
