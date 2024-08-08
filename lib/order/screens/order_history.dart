import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/cart_page/bloc/cart_bloc.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/order/screens/order_details.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/variants/model/orderDetails.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final List<String> images = [];
  bool isLoading = true;
  @override
  void initState() {
    context.read<CartBloc>().add(GetAllOrderHistory());
    super.initState();
  }

  List<OrderDetailsModel> orderHistoryList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Order History")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is OrderHistoryLoading) {}
              if (state is OrderHistorySuccess) {
                isLoading = false;
                orderHistoryList = state.orderHistoryList;
                setState(() {});
              }
              if (state is ProductListFailed) {
                isLoading = false;
                orderHistoryList = [];
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 43,
                      decoration: const BoxDecoration(color: Color(0xFFF7F7F7)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total ${orderHistoryList.length} Orders',
                            style: GoogleFonts.poppins(
                              color: ColorTheme.primary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),padding: EdgeInsets.only(bottom: 40),
                        shrinkWrap: true,
                        primary: false,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 8,
                        ),
                        itemCount: orderHistoryList.length,
                        itemBuilder: (context, index) {
                          return OrderHistoryCard(
                            orderHistoryList: orderHistoryList[index],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({super.key, required this.orderHistoryList});
  final OrderDetailsModel? orderHistoryList;
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {
      PersistentNavBarNavigator.pushNewScreen(context, screen: OrderDetails(orderHistoryList: orderHistoryList,),withNavBar: false);
    },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            shadows: const [
              BoxShadow(
                color: Color(0x05000000),
                blurRadius: 2,
                offset: Offset(1, 0),
                spreadRadius: 1,
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "#${orderHistoryList?.id.toString()}",
                    style: GoogleFonts.urbanist(
                      color: ColorTheme.text,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${orderHistoryList?.totalPrice.toString()} SAR",
                    style: GoogleFonts.urbanist(
                      color: ColorTheme.text,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
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
                    orderHistoryList?.customerName ?? "",
                    style: GoogleFonts.urbanist(
                      color: ColorTheme.text,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "${orderHistoryList?.orderDate?.day}-${orderHistoryList?.orderDate?.month}-${orderHistoryList?.orderDate?.year}",
                    style: GoogleFonts.urbanist(
                      color: ColorTheme.secondary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
