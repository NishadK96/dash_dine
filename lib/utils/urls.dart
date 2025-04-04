import 'package:pos_app/auth/authenticate.dart';

class PosUrls{
  static const String baseUrl=
  // "http://192.168.29.169:8000";
  "http://api-posorder.dhoomaworksbench.site";  
  static const String loginUrl ="$baseUrl/api/user/user-login/";
  static const String changePassword ="$baseUrl/user/";
  static const String printInvoice ="$baseUrl/invoice/invoice-create";
  static const String adminDashboardUrl ="$baseUrl/stock/dashboard-for-admin";
  static const String storeDashboardUrl ="$baseUrl/order/dashboard-for-store";
  static const String warehouseDashboardUrl ="$baseUrl/product/dashbord-for-warehouse-admin/1";
  static const String productList="$baseUrl/product/list-product";
  static const String productListByInventory="$baseUrl/costing/list-product-by-inventory-for-costing/";
  static const String productListByInventoryForOrder="$baseUrl/order/list-product-by-inventory-for-order/";
  static const String varientList="$baseUrl/product/list-variant";
  static const String varientListInWareHouse="$baseUrl/product/list-variant-by-warehouse/";
   static const String varientDetails="$baseUrl/product/read-edit-delete-variant/";
  static const String deleteVariant="$baseUrl/product/read-edit-delete-variant/";
  static const String attributeList="$baseUrl/product/list-attribute";
  static const String createProduct="$baseUrl/product/create-product";
  static const String editVariantImageUrl="$baseUrl/product/edit-variant-image/";
  static const String deleteProduct="$baseUrl/product/read-edit-delete-product/";
  static const String createVariant="$baseUrl/product/create-variant-new";
  static const String createOrder="$baseUrl/order/create-order";
  static const String editOrder="$baseUrl/order/patch-order";
  static const String createAttribute="$baseUrl/product/create-attribute";
   static const String editAttribute="$baseUrl/product/read-edit-delete-attribute/";
  static const String listWareHouse="$baseUrl/operation/read-warehouse";
  static const String deleteWareHouse="$baseUrl/api/operation/warehouse/";
  static const String createWareHouse="$baseUrl/api/operation/warehouse/";
  static const String managerByWarehouse="$baseUrl/api/user/?warehouse_id=1";
  static const String listManagers="$baseUrl/api/user/?user_type=";
  static const String listStores="$baseUrl/operation/read-inventory";
  static const String createStore="$baseUrl/api/operation/inventory/";
  static const String editStore="$baseUrl/api/operation/inventory/";
  static const String assignToInventory="$baseUrl/stock/map-variant-with-inventory";
  static const String alreadyAssignToInventory="$baseUrl/product/list-variant-by-inventory-for-assigning";
  static const String deleteAssignToInventory="$baseUrl/stock/delete-variant-with-inventory";
  static const String AssignToInventory="$baseUrl/product/list-variant-by-inventory-not-assigned";
  static const String listStoresUnderWareHouse="$baseUrl/operation/read-inventory?warehouse_id=";
  static const String readVariantForStockAllocateUrl = "$baseUrl/stock/read-variant-for-stock-allocate";
  static const String listVariantByProductAndInventoryUrl = "$baseUrl/order/list-variant-by-product-and-inventory/";
  static const String allocateStockToWareHouseUrl = "$baseUrl/stock/allocate-stock-to-warehouse";
  static const String userCreationUrl="$baseUrl/user/user-create";
  static const String userEditUrl="$baseUrl/user/";
  static  String listReceivingStockByInventory = "$baseUrl/stock/list-stock-recieving-by-inventory/${authentication.authenticatedUser.businessData?.businessId}";
  static const String receiveStockByInventory = "$baseUrl/stock/stock-recieving";
  static  String listVariantByInventoryForStockAdjust = "$baseUrl/stock/list-variant-for-stock/${authentication.authenticatedUser.businessData?.businessId}";
  static  String listProductsForCosting="$baseUrl/costing/list-product-by-inventory-for-costing/${authentication.authenticatedUser.businessData?.businessId}";
  static  String listOrderHistory="$baseUrl/order/list-orders/${authentication.authenticatedUser.businessData?.businessId}";
  static const String orderDetails="$baseUrl/order/read-order/";
  static const String listProductForInventory="$baseUrl/product/list-product-by-inventory/";
  static const String listProductForInventoryForOrder="$baseUrl/order/list-product-by-inventory-for-order/";
  static const String stockApprovalByAdmin="$baseUrl/stock/adjustment-approval-by-admin";
  static const String listProductForWareHouse="$baseUrl/product/list-product-by-warehouse/";
  static const String allocateStockToStoreUrl="$baseUrl/stock/allocate-stock-to-store";
  static const String createCosting="$baseUrl/costing/create-or-update-costing";
  static const String createStockAdjustmentUrl="$baseUrl/stock/create-adjust-stock";
  static const String listStockAdjustmentForAdminUrl="$baseUrl/stock/list-adjustment-stock-for-admin";
}