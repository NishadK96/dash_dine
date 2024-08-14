import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/stores/widgets/product_costing_popup.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/products/widgets/products_tile_card.dart';

class ProductsListCostingScreen extends StatefulWidget {
  const ProductsListCostingScreen({super.key});

  @override
  State<ProductsListCostingScreen> createState() =>
      _ProductsListCostingScreenState();
}

class _ProductsListCostingScreenState extends State<ProductsListCostingScreen> {
  _showPopupMenu(Offset offset, int? productId, dynamic price) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.white,
                context: context,
                builder: (context) {
                  return Padding(
                  padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return AddProductCosting(
                          price: price ?? 0,
                          prodId: productId ?? 0,
                        );
                      },
                    ),
                  );
                },
              );
            },
            child: const Text('Add price'),
            value: 'Add price'),
      ],
      elevation: 8.0,
    );
  }

  final List<String> images = [];
  bool isLoading = true;
  @override
  void initState() {
    context.read<ProductListBloc>().add(GetAllProducts(costing: true));
    super.initState();
  }

  List<ProductList> productList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Add Costing")),
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
                         
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 8,
                        ),
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          return ProductsTileCard(
                            onTap: () {
                               showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.white,
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Padding(
                          padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: AddProductCosting(
                          price: productList[index].price ?? 0,
                          prodId: productList[index].id ?? 0,
                        ),
                      );
                    },
                  );
                },
              );
                            },
                            costing: true,
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
