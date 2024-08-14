import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/no_search_data.dart';
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/products/screens/create_product.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/products/widgets/products_tile_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final List<String> images = [];
  bool isLoading = true;
  final RefreshController refreshController =
  RefreshController(initialRefresh: false);
  bool hasNextPage = false;
  int pageNo = 1;
  String? count;
  @override
  void initState() {
    context.read<ProductListBloc>().add(GetAllProducts(pageNo: 1));
    super.initState();
  }

  List<ProductList> productList = [];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Product List")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductListBloc, ProductListState>(
            listener: (context, state) {
              if (state is ProductListLoading) {}
              if (state is ProductListSuccess) {

                isLoading = false;
                count= state.productList.count;
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
                isLoading = false;
                productList = [];
                setState(() {});
              }
            },
          )
        ],
        child: isLoading
            ? const LoadingPage()
            : SmartRefresher( controller: refreshController,
          enablePullUp: hasNextPage == false ? false : true,
          footer: CustomFooter(
            builder: (context, mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20.w,height: 20.h,child: CircularProgressIndicator(color: ColorTheme.primary,strokeWidth: 2,)),
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
                    SizedBox(width: 20.w,height: 20.h,child: CircularProgressIndicator(color: ColorTheme.primary,strokeWidth: 2,)),
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
              context.read<ProductListBloc>().add(GetAllProducts(pageNo: ++pageNo));
            } else {
              log(1.1);
            }
          },
          enablePullDown: false,
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding:  EdgeInsets.symmetric(horizontal:isTab(context)?30: 15),
                        height: 43,
                        decoration: const BoxDecoration(color: Color(0xFFF7F7F7)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Products: ${count}',
                              style: GoogleFonts.poppins(
                                color: ColorTheme.primary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.30,
                              ),
                            ),
                            authentication.authenticatedUser.userType == "admin"
                                ? InkWell(
                                    onTap: () {
                                      PersistentNavBarNavigator.pushNewScreen(
                                          context,
                                          withNavBar: false,
                                          screen: const CreateNewProduct());
                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.string(
                                            CommonSvgFiles().addIconSvg),
                                        Text(
                                          'Add New',
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding:  EdgeInsets.only(
                              left:isTab(context)?30: 16, right:isTab(context)?30: 16, bottom: 0),
                          child: CurvedTextField(
                            onChanged: (val) {
                              context
                                  .read<ProductListBloc>()
                                  .add(GetAllProducts(element: val));
                            },
                            title: "Search products",
                            isSearch: true,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      productList.isEmpty
                          ? NoSearchData()
                          : Container(
                              padding:  EdgeInsets.symmetric(horizontal:isTab(context)?30: 15),
                              child: ListView.separated(padding: EdgeInsets.only(bottom: 40),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                primary: false,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 8,
                                ),
                                itemCount: productList.length,
                                itemBuilder: (context, index) {
                                  return ProductsTileCard(
                                    productCard: productList[index],
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
