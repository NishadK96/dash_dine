import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/cart_page/bloc/cart_bloc.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/order_app_bar.dart';
import 'package:pos_app/products/widgets/attribute_tile_card.dart';
import 'package:pos_app/screens/dashboard.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/device_info.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/variants/model/orderDetails.dart';
import 'package:pos_app/variants/model/order_lines.dart';

class InvoiceDetails extends StatefulWidget {
  const InvoiceDetails({super.key,required this.id});
  final int id;
  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  @override
  void initState() {
    context.read<CartBloc>().add(GetOrderDetails(
        inventoryId: authentication.authenticatedUser.businessData?.businessId??0, orderId: widget.id ?? 0));
  }
  String formatIsoTimestamp(DateTime isoTimestamp) {
    // DateTime dateTime = DateTime.parse(isoTimestamp);
    DateFormat dateFormat = DateFormat('dd-MMM-yyyy, hh:mm a');
    return dateFormat.format(isoTimestamp);
  }
  bool isLoading = true;
  OrderDetailsModel? orderDetails;
  List<OrderLines> orderLines = [];
  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,onPopInvoked: (didPop) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashBoard(),
          ),
              (route) => false);

    },
      child: Scaffold(bottomNavigationBar: Container(
        width: DeviceInfo(context).width,
        height: 65,
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 13),
          child: SizedBox(
              width: DeviceInfo(context).width,
              child:  CommonButton(onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => YourCartPage(),));
              },
                title: "Print Invoice",
              )),
        ),
      ),
        backgroundColor: ColorTheme.backGround,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: OrderAppBar(title: "Invoice Details",toDashboard: true,)),
        body: MultiBlocListener(listeners: [
          BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is OrderDetailsSuccess) {
                orderLines.clear();
                orderDetails = state.orderHistoryList;
                for (int i = 0; i < state.orderHistoryList.lines!.length; i++) {
                  orderLines.add(OrderLines(orderLineId: orderDetails?.lines?[i].id,isActive: true,
                      variantId: orderDetails?.lines?[i].variantId?.id ?? 0,
                      image: orderDetails?.lines?[i].variantId?.image ?? "",
                      productId: orderDetails?.lines?[i].productId ?? 0,
                      quantity: orderDetails?.lines?[i].quantity ?? 1,
                      sellingPrice: orderDetails?.lines?[i].sellingPrice,
                      variantName:
                      orderDetails?.lines?[i].variantId?.name ?? "",
                      productName:
                      orderDetails?.lines?[i].variantId?.productId?.name ??
                          "",
                      deliveryNote: orderDetails?.deliveryNote ?? ""));
                }
                isLoading = false;
                setState(() {});
              }
              if (state is OrderDetailsFailed) {
                isLoading = false;
                setState(() {});
              }
            },
          )
        ],
          child:isLoading? const LoadingPage():Column(
            children: [
              Container(
                width: DeviceInfo(context).width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: DeviceInfo(context).width,
                        child: Row(
                          children: [
                            Container(
                              height: 75.w,
                              width: 75.w,
                              decoration: BoxDecoration(
                                  color: ColorTheme.primary,
                                  shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Image.asset("assets/splash.png"),
                            ),),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(height: 10,),
                                Text(
                                  "INVOICE",
                                  style: GoogleFonts.poppins(height: 1.1,
                                    color: ColorTheme.text,
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Invoice No. ${orderDetails?.id}",
                                  style: GoogleFonts.urbanist(
                                    color: ColorTheme.text,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Bill To :",
                          style: GoogleFonts.urbanist(
                            color: ColorTheme.text,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(
                        height: 2.5,
                      ),
                      Row(
                        children: [
                          Text(orderDetails?.customerId?.name?.toTitleCase()??"",
                              style: GoogleFonts.urbanist(
                                color: ColorTheme.text,
                                fontSize:15.sp,
                                fontWeight: FontWeight.w600,
                              )),
                          const Spacer(),
                          Text("Date and Time :",
                              style: GoogleFonts.urbanist(
                                color: ColorTheme.text,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Text(orderDetails?.customerId?.phoneNumber??"",
                              style: GoogleFonts.urbanist(
                                color: ColorTheme.secondary,
                                fontSize: 15.sp,
                              )),
                          const Spacer(),
                          Text(formatIsoTimestamp(orderDetails?.orderDate??DateTime.now()),
                              style: GoogleFonts.urbanist(
                                color: ColorTheme.secondary,
                                fontSize:15.sp,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ),
              DottedLine(
                direction: Axis.horizontal,
                lineLength: double.infinity,
                dashColor: ColorTheme.secondary,
                lineThickness: 1.5,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                width: DeviceInfo(context).width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Total Number of product is : ${orderLines.length}",
                    style: GoogleFonts.urbanist(
                      color: ColorTheme.text,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                color: ColorTheme.secondary,
                width: DeviceInfo(context).width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: DeviceInfo(context).width! / 1.6,
                        child: Text(
                          "Product ID & Name",
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: DeviceInfo(context).width! / 7,
                        child: Text(
                          "Qty.",
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontSize:14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Amount",
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.white,
                            width: DeviceInfo(context).width,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: DeviceInfo(context).width! / 1.6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "#ID ${orderLines[index].orderLineId}",
                                          style: GoogleFonts.urbanist(
                                            color: ColorTheme.secondary,
                                            fontSize:12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "${index + 1}. ${orderLines[index].productName}",
                                          style: GoogleFonts.urbanist(
                                            color: ColorTheme.text,
                                            fontSize:15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.sp,
                                    child: Text(
                                      orderLines[index].quantity.toString(),
                                      style: GoogleFonts.urbanist(
                                        color: ColorTheme.text,
                                        fontSize: DeviceInfo(context).width! / 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    orderLines[index].sellingPrice.toString(),
                                    style: GoogleFonts.urbanist(
                                      color: ColorTheme.text,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                              color: ColorTheme.backGround,
                              height: 0,
                            ),
                        itemCount: orderLines.length),
                    Divider(color: ColorTheme.secondaryBlue,),
                    const SizedBox(height: 10,),
                    Row(
                      children: [const SizedBox(width: 28,),
                        Text("Sub Total",style: GoogleFonts.urbanist(
                          color: ColorTheme.text,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),),const Spacer(), Text("${orderLines?.length.toString()??" "}  Products",style: GoogleFonts.urbanist(
                          color: ColorTheme.text,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),),const SizedBox(width: 28,),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(color: ColorTheme.secondaryBlue,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [const SizedBox(width: 10,),
                              Text("Grand Total",style: GoogleFonts.urbanist(
                                color: ColorTheme.text,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),),const Spacer(),Text(orderDetails?.totalPrice.toString()??"",style: GoogleFonts.urbanist(
                                color: ColorTheme.text,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),),const SizedBox(width: 16,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
