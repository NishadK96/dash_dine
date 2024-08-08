// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pos_app/auth/authenticate.dart';
// import 'package:pos_app/common_widgets/buttons.dart';
// import 'package:pos_app/stores/data/store_data_soure.dart';
// import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
// import 'package:pos_app/stores/models/store_model.dart';
// import 'package:pos_app/utils/colors.dart';
// import 'package:pos_app/utils/size_config.dart';
//
// class StockAcceptancePopUp extends StatelessWidget {
//   final ReceiveStockModel receiveStockModel;
//   const StockAcceptancePopUp({super.key, required this.receiveStockModel});
//
//   @override
//   Widget build(BuildContext context) {
//     double w1 = MediaQuery.of(context).size.width;
//
//     return Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(15), topRight: Radius.circular(15))),
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 10,
//             ),
//             Center(
//                 child: Container(
//               width: 35,
//               height: 7,
//               decoration: BoxDecoration(
//                   color: ColorTheme.secondaryBlue,
//                   borderRadius: BorderRadius.circular(5)),
//             )),
//             const SizedBox(
//               height: 10,
//             ),
//             Text(
//               'Stock Acceptance',
//               textAlign: TextAlign.center,
//               style: GoogleFonts.urbanist(
//                 color: Colors.black,
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Container(
//               height: 1,
//               color: ColorTheme.backGround,
//               width: widthDouble(context, 1),
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//             SizedBox(
//               width: w1,
//               child: Center(
//                 child: Text(
//                   "Requested By ${receiveStockModel.allocatedBy}",
//                   style: GoogleFonts.urbanist(
//                     color: const Color(0xFF1C1B1F),
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w500,
//                     height: 0,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: w1,
//               child: Center(
//                 child: Text(
//                   "${receiveStockModel.inventoryId}",
//                   style: GoogleFonts.urbanist(
//                     color: ColorTheme.secondary,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w500,
//                     height: 0,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//             Container(
//               height: 1,
//               color: ColorTheme.secondaryBlue,
//               width: widthDouble(context, 1),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               child: Container(
//                 width: w1,
//                 decoration: BoxDecoration(
//                     color: ColorTheme.backGround,
//                     border: Border.all(
//                       color: ColorTheme.secondaryBlue,
//                     ),
//                     borderRadius: BorderRadius.circular(8)),
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//                   child: Row(
//                     children: [
//                       Text(
//                         'Add Stock',
//                         style: GoogleFonts.urbanist(
//                           color: Color(0xFF4CAF50),
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           height: 0,
//                         ),
//                       ),Spacer(), Text(
//                         '${receiveStockModel.recievingQty}',
//                         style: GoogleFonts.urbanist(
//                           color: ColorTheme.text,
//                           fontSize: 20.sp,
//                           fontWeight: FontWeight.w700,
//                           height: 0,
//                         ),
//                       ),SizedBox(width: 16,)
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // SizedBox(height: 10,),
//               Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
//               child: Container(
//                 width: w1,
//                 decoration: BoxDecoration(
//                     color: ColorTheme.backGround,
//                     border: Border.all(
//                       color: ColorTheme.secondaryBlue,
//                     ),
//                     borderRadius: BorderRadius.circular(8)),
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             'Reason',
//                             style: GoogleFonts.urbanist(
//                               color: ColorTheme.secondary,
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w500,
//                               height: 0,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Divider(color: ColorTheme.secondaryBlue,),
//                        SizedBox(width: w1,height: MediaQuery.of(context).size.height/10,
//                          child: Text(
//
//                               "-Not Mentioned-",
//                               style: GoogleFonts.urbanist(
//                                 color: ColorTheme.secondary,
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w400,
//                                 height: 0,
//                               ),
//                             ),
//                        ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // Container(
//             //   height: 1,
//             //   color: Colors.black12,
//             //   width: widthDouble(context, 1),
//             // ),
//             // const SizedBox(
//             //   height: 15,
//             // ),
//             // Container(
//             //   width: 187,
//             //   height: 46,
//             //   decoration: ShapeDecoration(
//             //     color: const Color(0xFFE8ECF4),
//             //     shape: RoundedRectangleBorder(
//             //       side: const BorderSide(width: 1, color: Color(0xFFE8ECF4)),
//             //       borderRadius: BorderRadius.circular(8),
//             //     ),
//             //   ),
//             //   alignment: Alignment.center,
//             //   child: Text(
//             //     'Allocated Quantity: ${receiveStockModel.recievingQty}',
//             //     textAlign: TextAlign.right,
//             //     style: TextStyle(
//             //       color: Color(0xFF1C1B1F),
//             //       fontSize: 16,
//             //       fontFamily: 'Urbanist',
//             //       fontWeight: FontWeight.w600,
//             //     ),
//             //   ),
//             // ),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: CommonButton(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       cancel: true,
//                       title: "Cancel",
//                     ),
//                   ),
//                   SizedBox(
//                     width: 6,
//                   ),
//                   Expanded(
//                     child: CommonButton(
//                       onTap: () {
//                         StoreDataSource()
//                             .receiveStockByInventory(
//                                 inventoryId: authentication.authenticatedUser.businessData?.businessId??0,
//                                 variantName:
//                                     receiveStockModel.variantData?.name ?? "",
//                                 receivingId: receiveStockModel.id ?? 0)
//                             .then((value) {
//                           if (value.data1) {
//                             Fluttertoast.showToast(msg: value.data2);
//                             context.read<ManageStoreBloc>().add(GetListReceivingStockInventory());
//                           } else {
//                             Fluttertoast.showToast(msg: value.data2);
//                           }
//                           Navigator.pop(context);
//                         });
//                       },
//                       title: "Confirm",
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }
// }
