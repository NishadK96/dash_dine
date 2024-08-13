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
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/products/screens/create_product.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/products/widgets/products_tile_card.dart';

class SpecialProductsListScreen extends StatefulWidget {
  const SpecialProductsListScreen({super.key, this.fromWareHouse,this.wareHouseId});
final bool? fromWareHouse;
final int? wareHouseId;
  @override
  State<SpecialProductsListScreen> createState() => _SpecialProductsListScreenState();
}

class _SpecialProductsListScreenState extends State<SpecialProductsListScreen> {
  final List<String> images = [];
  bool isLoading = true;
  @override
  void initState() {
    context.read<ProductListBloc>().add(GetAllProducts(underWareHouse: widget.fromWareHouse,inventoryId: widget.wareHouseId));
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
                productList = state.productList.data;
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
            : SingleChildScrollView(
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
                      'Total Products: ${productList.length}',
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
              // Container(
              //     padding:  EdgeInsets.only(
              //         left:isTab(context)?30: 16, right:isTab(context)?30: 16, bottom: 0),
              //     child: CurvedTextField(
              //       onChanged: (val) {
              //         context
              //             .read<ProductListBloc>()
              //             .add(GetAllProducts(element: val));
              //       },
              //       title: "Search products",
              //       isSearch: true,
              //     )),
              // const SizedBox(
              //   height: 10,
              // ),
              productList.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100,)
,                    SvgPicture.string(
                        CommonSvgFiles().emptyCommonSvg),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'No data found here!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // authentication.authenticatedUser.userType ==
                    //     "admin"
                    //     ? Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: w / 4),
                    //   child: CommonButton(
                    //     title: "Create new Product",
                    //     onTap: () {
                    //       PersistentNavBarNavigator
                    //           .pushNewScreen(context,
                    //           withNavBar: false,
                    //           screen:
                    //           const CreateNewProduct());
                    //     },
                    //   ),
                    // )
                    //     : Container(),
                    // const SizedBox(
                    //   height: 40,
                    // ),
                  ],
                ),
              )
                  : Container(
                padding:  EdgeInsets.symmetric(horizontal:isTab(context)?30: 15),
                child: ListView.separated(
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
    );
  }
}
