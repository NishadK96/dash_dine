import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/cart_page/bloc/cart_bloc.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/order_app_bar.dart';
import 'package:pos_app/order/screens/edit_order.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/variants/model/orderDetails.dart';
import 'package:pos_app/variants/model/order_lines.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key, required this.orderHistoryList});
  final OrderDetailsModel? orderHistoryList;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState() {
    context.read<CartBloc>().add(GetOrderDetails(
        inventoryId: authentication.authenticatedUser.businessData?.businessId??0, orderId: widget.orderHistoryList?.id ?? 0));
    super.initState();
  }

  bool isLoading = true;
  OrderDetailsModel? orderDetails;
  List<OrderLines> orderLines = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 64.h,
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
            child: Row(
              children: [
                const Spacer(),
                SizedBox(
                    height: 50.h,
                    width: 187.w,
                    child: CommonButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditOrderScreen(orderID: orderDetails?.id??0,
                                orderLines: orderLines,phone: orderDetails?.customerId?.phoneNumber??"",billTo: orderDetails?.customerId?.name??"",note: orderDetails?.deliveryNote??"",
                              ),
                            ));
                      },
                      title: "Edit Order",
                      cancel: true,
                    )),
                const Spacer(),
                const Spacer(),
                const Spacer(),
                SizedBox(
                    height: 50.h,
                    width: 187.w,
                    child: const CommonButton(
                      title: "Print Invoice",
                    )),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ColorTheme.backGround,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: OrderAppBar(title: "Order Details")),
      body: MultiBlocListener(
        listeners: [
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
        child: isLoading
            ? const LoadingPage()
            : SingleChildScrollView(
              child: Column(
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x05000000),
                              blurRadius: 2,
                              offset: Offset(1, 0),
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Order ID :",
                                    style: GoogleFonts.urbanist(
                                      color: ColorTheme.text,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "Date and Time",
                                    style: GoogleFonts.urbanist(
                                      color: ColorTheme.text,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "#${widget.orderHistoryList?.id}",
                                    style: GoogleFonts.urbanist(
                                      color: ColorTheme.text,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${widget.orderHistoryList?.orderDate?.day}-${widget.orderHistoryList?.orderDate?.month}-${widget.orderHistoryList?.orderDate?.year}",
                                    style: GoogleFonts.urbanist(
                                      color: ColorTheme.secondary,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x05000000),
                              blurRadius: 2,
                              offset: Offset(1, 0),
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Bill To",
                                    style: GoogleFonts.urbanist(
                                      color: ColorTheme.text,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: ColorTheme.backGround,
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.orderHistoryList?.customerName ?? "",
                                    style: GoogleFonts.urbanist(
                                      color: ColorTheme.text,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  RotatedBox(
                                      quarterTurns: 5,
                                      child: Icon(
                                        Icons.phone_enabled_outlined,
                                        color: ColorTheme.secondary,
                                        size: 16.sp,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    orderDetails?.customerId?.phoneNumber
                                            .toString() ??
                                        "",
                                    style: GoogleFonts.urbanist(
                                      color: ColorTheme.secondary,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 2,
                            offset: Offset(1, 0),
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Products (Total ${orderDetails?.lines?.length})",
                                style: GoogleFonts.urbanist(
                                  color: ColorTheme.text,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: ColorTheme.backGround,
                          ),
                          ListView.separated(
                            padding: const EdgeInsets.only(top: 5, bottom: 0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            separatorBuilder: (context, index) => Divider(
                              color: ColorTheme.backGround,
                            ),
                            itemCount: orderDetails?.lines!.length ?? 0,
                            itemBuilder: (context, index) {
                              return OrderDetailsProductsTile(
                                productCard: orderDetails!.lines?[index],
                              );
                            },
                          ),
                          Divider(
                            color: ColorTheme.backGround,
                            thickness: 2,
                          ),
                          Row(
                            children: [
                              Text(
                                "Grand Total",
                                style: GoogleFonts.urbanist(
                                  color: ColorTheme.text,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "${orderDetails?.totalPrice} SAR",
                                style: GoogleFonts.urbanist(
                                  color: ColorTheme.text,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
            ),
      ),
    );
  }
}

class OrderDetailsProductsTile extends StatelessWidget {
  final bool costing;
  final Line? productCard;
  final Function(TapDownDetails)? onTap;
  const OrderDetailsProductsTile(
      {super.key, this.productCard, this.costing = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(productCard?.variantId?.image??""), fit: BoxFit.fill),
                      color: const Color(0x33D9D9D9),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: w1 - 95,
                        child: Row(
                          children: [
                            Text(
                              productCard?.productId.toString() ?? "",
                              style: GoogleFonts.urbanist(
                                color: ColorTheme.secondary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Qty: ${productCard?.quantity}",
                              style: GoogleFonts.urbanist(
                                color: ColorTheme.text,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: w1 / 1.6,
                        child: Text(
                          productCard?.variantId?.name??"",
                          style: GoogleFonts.urbanist(
                            color: ColorTheme.text,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
