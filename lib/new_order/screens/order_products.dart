import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/cart_page/your_cart.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/order_app_bar.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/products/widgets/attribute_tile_card.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/variants/model/order_lines.dart';
import 'package:pos_app/variants/model/variant_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

List<OrderLines> productCartList = [];
List<int> productAddedListIds = [];

class OrderProducts extends StatefulWidget {
  const OrderProducts({super.key});

  @override
  State<OrderProducts> createState() => _OrderProductsState();
}

class _OrderProductsState extends State<OrderProducts> {
  @override
  void initState() {
    productCartList.clear();
    productAddedListIds.clear();
    context.read<ProductListBloc>().add(GetAllProducts(
        fromOrder: true,
        inventoryId:
            authentication.authenticatedUser.businessData?.businessId ?? 0));
    super.initState();
  }

  bool variantLoading = true;
  TextEditingController quantityController = TextEditingController();
  int pageNo = 1;
  String? count;
  bool isLoading = true;
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool hasNextPage = false;
  List<ProductList> productList = [];
  List<VariantsListModel> variantList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: productCartList.isEmpty
          ? const SizedBox()
          : Stack(
              children: [
                FloatingActionButton(
                  backgroundColor: const Color(0xff1E232C),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => YourCartPage(
                        orderLines: productCartList,
                      ),),
                    ).then((result) {
                      if (result == true) {
                        setState(() {

                        });
                      }
                    });
                  },
                ),
                productCartList.isEmpty
                    ? const SizedBox()
                    : Positioned(
                        top: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: ColorTheme.secondaryBlue,
                          child: Text(
                            productCartList.length.toString(),
                            style: GoogleFonts.urbanist(
                                fontSize: 10, fontWeight: FontWeight.w700),
                          ),
                        ))
              ],
            ),
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: OrderAppBar(title: "Order")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductListBloc, ProductListState>(
              listener: (context, state) {
            if (state is ProductListLoading) {}
            if (state is ProductListSuccess) {
              isLoading = false;
              count = state.productList.count;
              isLoading = false;
              setState(() {});
              if (state.productList.nextPageUrl == null) {
                hasNextPage = false;
                setState(() {});
              } else {
                hasNextPage = true;
                setState(() {});
              }
              for (int i = 0; i < state.productList.data.length; i++) {
                productList.add(state.productList.data[i]);
              }

              setState(() {});
            }
            if (state is ProductListFailed) {
              // isLoading = false;
              setState(() {});
            }
            if (state is VariantByProductLoading) {
              variantList = [];
              setState(() {});
            }
            if (state is VariantByProductSuccess) {
              variantLoading = false;
              variantList = state.variantList;
              setState(() {});
            }
            if (state is VariantByProductFailed) {}
          })
        ],
        child: isLoading
            ? const LoadingPage()
            : SmartRefresher(
                controller: refreshController,
                enablePullUp: hasNextPage == false ? false : true,
                footer: CustomFooter(
                  builder: (context, mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(
                                color: ColorTheme.primary,
                                strokeWidth: 2,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Loading..",
                            style: GoogleFonts.urbanist(
                              color: ColorTheme.secondary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      );
                    } else if (mode == LoadStatus.loading) {
                      body = Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(
                                color: ColorTheme.primary,
                                strokeWidth: 2,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Loading..",
                            style: GoogleFonts.urbanist(
                              color: ColorTheme.secondary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      );
                    } else {
                      body = Text("No more Data",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ));
                    }
                    return SizedBox(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                onLoading: () {
                  if (hasNextPage == true) {
                    context
                        .read<ProductListBloc>()
                        .add(GetAllProducts(pageNo: ++pageNo));
                  } else {
                    log(1.1);
                  }
                },
                enablePullDown: false,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Add a Product',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Total $count product in this item',
                          style: GoogleFonts.urbanist(
                            color: const Color(0xFF8390A1),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GridView.builder(
                          itemCount: productList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 0.78),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => StatefulBuilder(
                                            builder: (context, setState1) {
                                          return AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.white,
                                            surfaceTintColor: Colors.white,
                                            content: Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8))),
                                              height: 246.h,
                                              width: 284.w,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: const BoxDecoration(
                                                        color:
                                                            Color(0xFFE8ECF4),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                topRight: Radius
                                                                    .circular(
                                                                        8))),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15,
                                                        vertical: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Select quantity',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: Colors.black,
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 18,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12),
                                                    child: Column(
                                                      children: [
                                                        CurvedTextField(
                                                          textType:
                                                              TextInputType
                                                                  .number,
                                                          controller:
                                                              quantityController,
                                                          title:
                                                              "Enter quantity",
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        CommonButton(
                                                            title: "Countinue",
                                                            onTap: () {
                                                              if (quantityController
                                                                          .text ==
                                                                      "" ||
                                                                  quantityController
                                                                          .text ==
                                                                      "0") {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Please enter quantity!");
                                                              } else {
                                                                Navigator.pop(
                                                                    context);
                                                                context
                                                                    .read<
                                                                        ProductListBloc>()
                                                                    .add(GetVariantByProduct(
                                                                        productId:
                                                                            productList[index].id));
                                                                showModalBottomSheet(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return StatefulBuilder(builder:
                                                                        (context,
                                                                            setState) {
                                                                      return VariantListForOrder(
                                                                          qty: int.parse(quantityController
                                                                              .text),
                                                                          productDetails:
                                                                              productList[index]);
                                                                    });
                                                                  },
                                                                ).whenComplete(
                                                                  () {
                                                                    quantityController
                                                                        .clear();
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                );
                                                              }
                                                            })
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }));
                              },
                              child: Container(
                                width: 122.w,
                                decoration: BoxDecoration(
                                  color: ColorTheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 150.w,
                                      height: 105.h,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(7),
                                            topRight: Radius.circular(7)),
                                        color: Colors.white,
                                      ),
                                      child: ClipRRect(borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                    topRight: Radius.circular(7)),
                                        child: Image.network(
                                          productList[index].image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      productList[index].name.toTitleCase(),
                                      style: GoogleFonts.urbanist(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "SAR ${productList[index].price}",
                                      style: GoogleFonts.urbanist(
                                        color: ColorTheme.secondary,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class VariantListForOrder extends StatefulWidget {
  const VariantListForOrder(
      {super.key, required this.productDetails, required this.qty});
  final ProductList productDetails;
  final int qty;
  @override
  State<VariantListForOrder> createState() => _VariantListForOrderState();
}

class _VariantListForOrderState extends State<VariantListForOrder> {
  bool isLoading = true;
  List<VariantsListModel> variantList = [];
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductListBloc, ProductListState>(
            listener: (context, state) {
          if (state is VariantByProductLoading) {
            variantList = [];
            setState(() {});
          }
          if (state is VariantByProductSuccess) {
            isLoading = false;
            variantList = state.variantList;
            setState(() {});
          }
          if (state is VariantByProductFailed) {
            isLoading = false;
            setState(() {});
          }
        })
      ],
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        height: 500.h,
        width: double.infinity,
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(30.0),
                child: LoadingPage(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                                color: ColorTheme.backGround,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.network(widget.productDetails.image),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                widget.productDetails.name
                                    .toString()
                                    .toTitleCase(),
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "SAR",
                                style: GoogleFonts.urbanist(
                                  color: ColorTheme.secondary,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: ColorTheme.secondaryBlue,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 500.h,
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 150),
                          physics: const AlwaysScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          shrinkWrap: true,
                          itemCount: variantList.length,
                          itemBuilder: (context, index) {
                            return VariantCard(
                              qty: widget.qty,
                              variantDetails: variantList[index],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class VariantCard extends StatefulWidget {
  const VariantCard(
      {super.key, required this.variantDetails, required this.qty});
  final VariantsListModel variantDetails;
  final int qty;
  @override
  State<VariantCard> createState() => _VariantCardState();
}

class _VariantCardState extends State<VariantCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorTheme.backGround, borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        trailing: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: InkWell(
            onTap: () {
              if (
              productAddedListIds.contains(widget.variantDetails.id)) {
                productAddedListIds.remove(widget.variantDetails.id ?? 1);
                productCartList.removeWhere((orderLine) =>
                    orderLine.variantId == (widget.variantDetails.id ?? 0));
                setState(() {});
              } else {
                productAddedListIds.add(widget.variantDetails.id ?? 1);
                productCartList.add(OrderLines(
                    image: widget.variantDetails.image ?? '',
                    variantId: widget.variantDetails.id ?? 0,
                    productId: widget.variantDetails.productId ?? 1,
                    quantity: widget.qty,
                    sellingPrice:
                        widget.variantDetails.priceData?.sellingPrice ?? 0,
                    variantName: widget.variantDetails.name ?? "",
                    productName: widget.variantDetails.productName ?? "",
                    deliveryNote: ""));
                Navigator.pop(context);
              }
            },
            child: Container(
              height: 34.h,
              width: 79.h,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                child: Center(
                  child: productAddedListIds.contains(widget.variantDetails.id)
                      ? Icon(
                          Icons.delete_outline,
                          color: ColorTheme.text,
                          size: 18,
                        )
                      : Text(
                          "Add",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 31.w,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.network(
              widget.variantDetails.image ?? "",
              fit: BoxFit.fill,
            ),
          ),
        ),
        title: Text(
          widget.variantDetails.name ?? "",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
