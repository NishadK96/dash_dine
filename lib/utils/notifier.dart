// import 'package:flutter/material.dart';
// import 'package:pos_app/utils/variables.dart';
// import 'package:pos_app/variants/model/order_lines.dart';
// import 'package:provider/provider.dart';

// class CartModel extends ChangeNotifier {

//   int? newTotalCount;
//   int? totalCount;
//   Map<int, int> cartItems = {};
//   bool isLoading = false;
//   int? varId;
//   double sum = 0;
//   int totalCartCount = 0;
//   int totalCountWithout = 0;
//   void clearCart() {
//     varId = null;
//     totalCount = 0;
//     isLoading = false;
//     totalCount = 0;
//     cartItems.clear();
//     Variables.finalPrice = 0;
//     notifyListeners();
//   }
//   void newTotalCartCounts(int? count) {
//     newTotalCount= count;
//     notifyListeners();
//   }
//   void totalCartCounts(int count) {
//     totalCartCount= count;
//     notifyListeners();
//   }
//   void addToCart(int productId, List<OrderLines> apiCartData,
//       {int? count, OrderLines? cartData}) {
//     if (cartItems.containsKey(productId)) {
//       cartItems[productId] = cartItems[productId]! + 1;
//       calculateFinalPrice(cartData?.sellingPrice ?? 0.0, cartItems[productId]);
//     } else {
//       cartItems[productId] = 1;
//       calculateFinalPrice(cartData?.sellingPrice ?? 0.0, cartItems[productId]);
//     }
//     totalCountWithout = totalCountWithout + 1;
//     notifyListeners();
//   }

//   void addToCartInCart(int productId, List<OrderLines> apiCartData,
//       {int? count, OrderLines? cartData}) {
//     if (cartItems.containsKey(productId)) {
//       cartItems[productId] = cartItems[productId]! + 1;
//       calculateFinalPrice(
//           cartData?.discountDetails?.hasDiscount == true
//               ? cartData?.discountDetails!.discountPrice! ?? 0
//               : cartData?.sellingPrice ?? 0.0,
//           cartItems[productId]);
//     } else {
//       cartItems[productId] = 1;
//       calculateFinalPrice(cartData?.sellingPrice ?? 0.0, cartItems[productId]);
//     }
//     notifyListeners();
//   }

//   void removeCartInCart(int productId, List<OrderLines> apiCartData,
//       {int? count, OrderLines? cartData}) {
//     if (cartItems.containsKey(productId)) {
//       if (cartItems[productId] == 1) {
//         cartItems[productId] = 0;
//       } else {
//         cartItems[productId] = cartItems[productId]! - 1;
//         calculateOnMinusFinalPrice(
//             cartData?.discountDetails?.hasDiscount == true
//                 ? cartData?.discountDetails!.discountPrice! ?? 0
//                 : cartData?.sellingPrice ?? 0.0,
//             cartItems[productId]);
//       }
//     } else {
//       cartItems[productId] = 1;
//       calculateOnMinusFinalPrice(
//           cartData?.sellingPrice ?? 0.0, cartItems[productId]);
//     }
//     notifyListeners();
//   }

//   void addToCartAuthenticated(int productId,
//       OrderLines products, BuildContext context) {
//     varId = productId;
//     int? quantity;
//     if (cartItems.containsKey(productId)) {
//       isLoading = true;
//       quantity = cartItems[productId]! + 1;
//       cartItems[quantity] = cartItems[productId]! + 1;
//       // Future.delayed(const Duration(milliseconds: 400), () {
//       context.read<AddtocartBloc>().add(FetchAddtocartEvent(
//           inventoryID: products.inventoryID ?? "",
//           isBusiness: false,
//           quantity: quantity,
//           variantID: products.id.toString(),
//           productParams: products));

//       // OrderDataSource()
//       //     .addToCart(
//       //         variantID: products.id.toString(),
//       //         isBusiness: false,
//       //         quantity: cartItems[productId]!,
//       //         inventoryID: products.inventoryID ?? "",
//       //         productParams: products)
//       //     .then((value) {
//       //   isLoading = false;
//       //   if (value.data1 == "success") {
//       //     cartItems[productId] = cartItems[productId]! + 1;
//       //   }
//       //   varId = null;
//       //   notifyListeners();
//       // });
//       // context.read<AddtocartBloc>().add(FetchAddtocartEvent(
//       //     inventoryID: products.inventoryID ?? "",
//       //     isBusiness: false,
//       //     quantity: cartItems[productId]!,
//       //     variantID: products.id.toString(),
//       //     productParams: products));
//       // });
//     } else {
//       cartItems[productId] = 1;
//     }
//     notifyListeners();
//   }

//   void removeFromCartAuthenticated(int productId,
//       OrderLines products, BuildContext context) {
//     if (cartItems.containsKey(productId)) {
//       // cartItems[productId] = cartItems[productId]! - 1;
//       isLoading = true;
//       varId = products.id;
//       cartItems[productId] = cartItems[productId]! - 1;

//       // Future.delayed(const Duration(milliseconds: 400), () {
//       context.read<AddtocartBloc>().add(FetchAddtocartEvent(
//           inventoryID: products.inventoryID ?? "",
//           isBusiness: false,
//           quantity: cartItems[productId]!,
//           variantID: products.id.toString(),
//           productParams: products));
//       // OrderDataSource()
//       //     .addToCart(
//       //         variantID: products.id.toString(),
//       //         isBusiness: false,
//       //         quantity: cartItems[productId]!,
//       //         inventoryID: products.inventoryID ?? "",
//       //         productParams: products)
//       //     .then((value) {
//       //   isLoading = false;
//       //   if (value.data1 == "success") {
//       //     cartItems[productId] = cartItems[productId]! - 1;
//       //   }
//       //   // varId = null;
//       //   notifyListeners();
//       // });
//       // context.read<AddtocartBloc>().add(FetchAddtocartEvent(
//       //     inventoryID: products.inventoryID ?? "",
//       //     isBusiness: false,
//       //     quantity: cartItems[productId]!,
//       //     variantID: products.id.toString(),
//       //     productParams: products));
//     } else {
//       cartItems[productId] = 0;
//     }
//     notifyListeners();
//   }

//   void removeAllFromCartAuthenticated(int productId, BuildContext context) {
//     cartItems[productId] = 1;

//     notifyListeners();
//   }

//   void calculateFinalPrice(double price, count) {
//     Variables.finalPrice = Variables.finalPrice + price;
//   }

//   void calculateOnMinusFinalPrice(double price, count) {
//     Variables.finalPrice = Variables.finalPrice - price;
//   }

//   void addAcountToCart(int productId, int count) {
//     if (cartItems.containsKey(productId)) {
//       cartItems[productId] = count;
//     }

//     notifyListeners();
//   }

//   void removeFromCart(int productId, List<OrderLines> apiCartData,
//       {OrderLines? cartData}) {
//     if (cartItems.containsKey(productId) && cartItems[productId]! > 0) {
//       cartItems[productId] = cartItems[productId]! - 1;
//     }
//     calculateOnMinusFinalPrice(cartData?.price ?? 0.0, cartItems[productId]);
//     totalCountWithout = totalCountWithout - 1;
//     notifyListeners();
//   }

//   void removeFromCartInCart(int productId, List<OrderLines> apiCartData,
//       {OrderLines? cartData}) {
//     if (cartItems.containsKey(productId) && cartItems[productId]! > 0) {
//       cartItems[productId] = cartItems[productId]! - 1;
//     }
//     calculateOnMinusFinalPrice(
//         cartData?.discountDetails?.hasDiscount == true
//             ? cartData?.discountDetails!.discountPrice! ?? 0
//             : cartData?.sellingPrice ?? 0.0,
//         cartItems[productId]);
//     notifyListeners();
//   }

//   void removeAllCartCount(int productId, List<OrderLines> apiCartData) {
//     if (cartItems.containsKey(productId) && cartItems[productId]! > 0) {
//       cartItems[productId] = 0;
//     } else {
//       cartItems[productId] = 0;
//     }
//     totalCountWithout = totalCountWithout - 1;
//     notifyListeners();
//   }

//   void assignCartQuantity(
//       {required int productId,
//       required int quantity,
//       required int totalCountCart}) {
//     cartItems[productId] = quantity;
//     totalCount = totalCountCart;
//     notifyListeners();
//   }
// }
