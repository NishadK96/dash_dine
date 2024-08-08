import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/stores/screens/assign_stock.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/variants/model/variant_model.dart';
import 'package:pos_app/variants/screens/widgets/variant_product_card.dart';

class VariantsListByProductScreen extends StatefulWidget {
  final int? prodId;
  final String? title;
  const VariantsListByProductScreen({super.key, this.prodId, this.title});

  @override
  State<VariantsListByProductScreen> createState() =>
      _VariantsListByProductScreenState();
}

class _VariantsListByProductScreenState
    extends State<VariantsListByProductScreen> {
  final List<String> images = [];
  bool isLoading = true;
  @override
  void initState() {
    context
        .read<ProductListBloc>()
        .add(GetVariantByProduct(productId: widget.prodId ?? 0));
    super.initState();
  }

  List<VariantsListModel> variantList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(title: widget.title)),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductListBloc, ProductListState>(
            listener: (context, state) {
              if (state is VariantByProductSuccess) {
                isLoading = false;
                variantList = state.variantList;
                setState(() {});
              }
            },
          )
        ],
        child: isLoading
            ? const LoadingPage() :variantList.isEmpty? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.string(CommonSvgFiles().emptyCommonSvg),
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
                    height: 40,
                  ),
                ],
              ),
            )
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
                            'Total Products: ${variantList.length}',
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
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 30),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 8,
                        ),
                        itemCount: variantList.length,
                        itemBuilder: (context, index) {
                          return VariantsTileCard(
                            onAssignStock: () {
                              PersistentNavBarNavigator.pushNewScreen(context,
                                  withNavBar: false,
                                  screen: AssignStock(
                                    variantData: variantList[index],
                                  ));
                            },
                            variantCard: variantList[index],
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
