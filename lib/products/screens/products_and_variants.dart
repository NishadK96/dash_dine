import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/products/screens/create_product.dart';
import 'package:pos_app/products/screens/variant_list_by_products.dart';
import 'package:pos_app/products/widgets/products_grid_card.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';

class ProductsAndVariants extends StatefulWidget {
  const ProductsAndVariants({super.key});

  @override
  State<ProductsAndVariants> createState() => _ProductsAndVariantsState();
}

class _ProductsAndVariantsState extends State<ProductsAndVariants> {
  final List<String> images = [];
  bool isLoading = true;
  @override
  void initState() {
    context.read<ProductListBloc>().add(GetAllProducts(costing: false,isInventory: true,inventoryId: authentication.authenticatedUser.businessData?.businessId));
    super.initState();
  }

  List<ProductList> productList = [];
  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: GridView.builder(
                          itemCount: productList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          gridDelegate:
                               SliverGridDelegateWithFixedCrossAxisCount(
                                   crossAxisSpacing:isTab(context)?8: 4,
                                  // mainAxisExtent: 1,
                                  mainAxisSpacing:isTab(context)?8: 4,
                                  childAspectRatio:isTab(context)?1: 0.8,
                                  crossAxisCount:isTab(context)?4: 3),
                          itemBuilder: (context, index) {
                            return ProductsGridCard(
                              onTap: () {
                              
                                           PersistentNavBarNavigator.pushNewScreen(context,
                                  withNavBar: false,
                                  screen: VariantsListByProductScreen(
                                    title: productList[index].name,
                                    prodId: productList[index].id,
                                  ));
                              },
                              productCard: productList[index],
                            );
                          },
                        ))
                  ],
                ),
              ),
      ),
    );
  }
}
