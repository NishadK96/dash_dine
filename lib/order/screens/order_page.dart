import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/cart_page/your_cart.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/order_app_bar.dart';
import 'package:pos_app/order/widgets/item_card.dart';
import 'package:pos_app/order/widgets/order_page_card.dart';
import 'package:pos_app/order/widgets/widgets.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/products/screens/add_dynamic_price.dart';
import 'package:pos_app/stores/widgets/product_costing_popup.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/variants/model/order_lines.dart';
import 'package:pos_app/variants/model/variant_model.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<ProductList> productList = [];
  List<OrderLines> productAddedList = [];
  OrderLines? productAdded;
  int? productAddedId;
  List<int> productAddedListIds = [];
  int price = 0;
  List<int> productConfirmedIds = [];
  List<VariantsListModel> variantList = [];
  int? productId;
  @override
  void initState() {
    context.read<ProductListBloc>().add(GetAllProducts(
        fromOrder: true,
        inventoryId:
            authentication.authenticatedUser.businessData?.businessId ?? 0));
    super.initState();
  }

  final TextEditingController priceController = TextEditingController();
  int count = 1;
  bool variantLoading = true;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return BlocListener<ProductListBloc, ProductListState>(
      listener: (context, state) {
        if (state is ProductListLoading) {}
        if (state is ProductListSuccess) {
          productList = state.productList.data;
          productId = productList[0].id;
          context
              .read<ProductListBloc>()
              .add(GetVariantByProduct(productId: productId ?? 0));
          setState(() {});
        }
        if (state is ProductListFailed) {
          // isLoading = false;
          productList = [];
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
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8F9),
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: OrderAppBar(title: "Order")),
        body: Stack(
          children: [
            SizedBox(
              height: h,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 110.w,
                      child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return ItemCard(
                              isSelected: productId == productList[index].id,
                              productTap: () {
                                productId = productList[index].id;
                                context.read<ProductListBloc>().add(
                                    GetVariantByProduct(
                                        productId: productList[index].id));
                                setState(() {});
                              },
                              productData: productList[index],
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                width: 5,
                              ),
                          itemCount: productList.length),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: w,
                      height: h / 1.09,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 2,
                            offset: Offset(1, 0),
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              OrderPageWidgets().addVariantSearch(context,
                                  count: variantList.length.toString()),
                              //  ----------------
                              const SizedBox(
                                height: 10,
                              ),
                              //---------------------------------------
                              variantLoading
                                  ? const LoadingPage()
                                  : SizedBox(
                                      height: h / 1.7,
                                      child: ListView.separated(
                                          padding:
                                              const EdgeInsets.only(bottom: 70),
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return OrderPageProductCard(
                                              isConfirmed:
                                                  productAddedListIds.contains(
                                                      variantList[index].id),
                                              isAdded:
                                                  productAddedListIds.contains(
                                                          variantList[index].id)
                                                      ? false
                                                      : productAddedId ==
                                                          variantList[index].id,
                                              onTap: () {
                                                if (productAddedListIds
                                                    .contains(variantList[index]
                                                        .id)) {
                                                  productAddedListIds.remove(
                                                      variantList[index].id);
                                                  productAddedList
                                                      .removeWhere((product) {
                                                    return variantList.any(
                                                        (variant) =>
                                                            product.variantId ==
                                                            variantList[index]
                                                                .id);
                                                  });
                                                  productAddedId = 0;
                                                  setState(() {});
                                                } else {
                                                  if (variantList[index]
                                                          .costingType ==
                                                      "dynamic price") {
                                                    showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.white,
                                                      context: context,
                                                      builder: (context) {
                                                        return Padding(
                                                          padding: EdgeInsets.only(
                                                              bottom: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets
                                                                  .bottom),
                                                          child:
                                                              StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                              return AddDynamicProductCosting(
                                                                onChanged:
                                                                    (text) {
                                                                  setState(() {
                                                                    price = int
                                                                        .parse(
                                                                            text);
                                                                  });
                                                                },
                                                                priceController:
                                                                    priceController,
                                                                onAdd: () {
                                                                  productAddedId =
                                                                      variantList[index]
                                                                              .id ??
                                                                          0;

                                                                  productAdded = OrderLines(
                                                                      image:
                                                                          variantList[index].image ??
                                                                              '',
                                                                      variantId:
                                                                          variantList[index].id ??
                                                                              0,
                                                                      productId:
                                                                          variantList[index].productId ??
                                                                              1,
                                                                      quantity:
                                                                          1,
                                                                      sellingPrice:
                                                                          price,
                                                                      variantName:
                                                                          variantList[index].name ??
                                                                              "",
                                                                      productName:
                                                                          variantList[index].productName ??
                                                                              "",
                                                                      deliveryNote:
                                                                          "");
                                                                  priceController
                                                                      .clear();
                                                                  price = 0;
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                price: price,
                                                                prodId:
                                                                    productId ??
                                                                        0,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else if (variantList[index]
                                                              .priceData
                                                              ?.sellingPrice ==
                                                          null &&
                                                      variantList[index]
                                                              .costingType !=
                                                          "dynamic price") {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Oops! please add cost to this product");
                                                  } else {
                                                    productAdded = null;
                                                    setState(() {});
                                                    productAddedId =
                                                        variantList[index].id ??
                                                            0;

                                                    productAdded = OrderLines(
                                                        image: variantList[
                                                                    index]
                                                                .image ??
                                                            '',
                                                        variantId: variantList[
                                                                    index]
                                                                .id ??
                                                            0,
                                                        productId:
                                                            variantList[
                                                                        index]
                                                                    .productId ??
                                                                1,
                                                        quantity: 1,
                                                        sellingPrice: variantList[
                                                                    index]
                                                                .priceData
                                                                ?.sellingPrice ??
                                                            0,
                                                        variantName:
                                                            variantList[index]
                                                                    .name ??
                                                                "",
                                                        productName: variantList[
                                                                    index]
                                                                .productName ??
                                                            "",
                                                        deliveryNote: "");
                                                  }
                                                  setState(() {});
                                                }
                                              },
                                              variantList: variantList[index],
                                            );
                                          },
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                                height: 10,
                                              ),
                                          itemCount: variantList.length),
                                    )
                              //  ---------------------------------------------
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            productAdded != null
                ? Container(
                    width: w,
                    height: h,
                    color: Colors.black26,
                  )
                : SizedBox(),
            Positioned(
              bottom: productAdded == null ? 30 : 75,
              right: 10,
              child: Stack(
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
                          MaterialPageRoute(
                            builder: (context) => YourCartPage(
                              orderLines: productAddedList,
                            ),
                          ));
                    },
                  ),
                  productAddedList.isEmpty
                      ? const SizedBox()
                      : Positioned(
                          top: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: ColorTheme.secondaryBlue,
                            child: Text(
                              productAddedList.length.toString(),
                              style: GoogleFonts.urbanist(
                                  fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ))
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: w,
                    height: productAdded == null ? 0 : 108,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              productAdded = null;
                              productAddedId = 0;
                              setState(() {});
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.close_rounded,
                                color: ColorTheme.text,
                                size: 18,
                              ),
                            )),
                        Spacer(),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: w,
                          height: productAdded == null ? 0 : 65,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 2)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 13),
                            child: Row(
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              // const CircleAvatar(
                              //   backgroundColor: Color(0xFFF7F8F9),
                              //   radius: 14,
                              //   child: Icon(
                              //     Icons.remove,
                              //     size: 18,
                              //   ),
                              // ),
                              // const SizedBox(
                              //   width: 5,
                              // ),
                              // Container(
                              //   decoration: BoxDecoration(
                              //       color: const Color(0xFFE8ECF4),
                              //       borderRadius: BorderRadius.circular(2)),
                              //   child: const Padding(
                              //     padding: EdgeInsets.only(
                              //         right: 10.0, left: 10, top: 5, bottom: 5),
                              //     child: Text("30"),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   width: 5,
                              // ),
                              // const CircleAvatar(
                              //   backgroundColor: Color(0xFFF7F8F9),
                              //   radius: 14,
                              //   child: Icon(
                              //     Icons.add,
                              //     size: 18,
                              //   ),
                              // ),
                              // const Spacer(),
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (count != 1) {
                                          count--;
                                        }
                                        setState(() {});
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            ColorTheme.secondaryBlue,
                                        radius: 15,
                                        child:
                                            const Icon(Icons.remove, size: 15),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      width: 40,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                          color: ColorTheme.secondaryBlue,
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child:
                                          Center(child: Text(count.toString())),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (count != 30) {
                                          count++;
                                        }
                                        setState(() {});
                                      },
                                      child: CircleAvatar(
                                        backgroundColor:
                                            ColorTheme.secondaryBlue,
                                        radius: 15,
                                        child: const Icon(
                                          Icons.add,
                                          size: 15,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                SizedBox(
                                    width: w / 2,
                                    child: CommonButton(
                                      onTap: () {
                                        productAddedListIds
                                            .add(productAdded?.variantId ?? 0);
                                        productAddedList.add(OrderLines(
                                            image: productAdded?.image ?? '',
                                            variantId:
                                                productAdded?.variantId ?? 0,
                                            productId:
                                                productAdded?.productId ?? 1,
                                            quantity: count,
                                            sellingPrice:
                                                productAdded?.sellingPrice ?? 0,
                                            variantName:
                                                productAdded?.variantName ?? "",
                                            productName:
                                                productAdded?.productName ?? "",
                                            deliveryNote: ""));
                                        productConfirmedIds
                                            .add(productAdded?.variantId ?? 0);
                                        productAdded = null;
                                        count = 1;
                                        setState(() {});
                                      },
                                      title: "Add to Cart",
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
