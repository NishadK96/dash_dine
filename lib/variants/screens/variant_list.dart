import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/no_search_data.dart';
import 'package:pos_app/stores/screens/assign_stock.dart';
import 'package:pos_app/stores/widgets/search_field.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/variants/model/variant_model.dart';
import 'package:pos_app/variants/screens/create_variant.dart';
import 'package:pos_app/variants/screens/widgets/variant_product_card.dart';
import 'package:pos_app/variants/variant_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
List<VariantsListModel> variantList = [];
class VariantsListScreen extends StatefulWidget {
  const VariantsListScreen({super.key});

  @override
  State<VariantsListScreen> createState() => _VariantsListScreenState();
}

class _VariantsListScreenState extends State<VariantsListScreen> {
  final List<String> images = [];
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool isLoading = true;
  bool hasNextPage = false;
  int pageNo = 1;
  String? count;


  @override
  void initState() {
    variantList.clear();
    if (authentication.authenticatedUser.userType == "wmanager") {
      context.read<VariantBloc>().add(GetAllVariants(
          pageNo: 1,
          fromWarehouse: true,
          id: authentication.authenticatedUser.businessData?.businessId
                  .toString() ??
              ""));
    } else {
      context.read<VariantBloc>().add(GetAllVariants(pageNo: 1));
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Variants")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<VariantBloc, VariantState>(
            listener: (context, state) {

              if (state is CreateVariantSuccess) {
                pageNo=1;
                variantList.clear();
                context.read<VariantBloc>().add(GetAllVariants());
                setState(() {});
              }
              if (state is DeleteVariantSuccess) {
                pageNo=1;
                variantList.clear();
                setState(() {

                });
                Fluttertoast.showToast(msg: state.message);
                context.read<VariantBloc>().add(GetAllVariants());
              }
              if (state is DeleteVariantFailed) {
                Fluttertoast.showToast(msg: "Something Went Wrong :(");
              }
              if (state is VariantsListLoading) {}
              if (state is VariantsListSuccess) {
               count= state.variantsList.count;
                isLoading = false;
                setState(() {});
                print("|kdhfbj ${state.variantsList.nextPageUrl}");
                if (state.variantsList.nextPageUrl == null) {
                  hasNextPage = false;
                  setState(() {});
                } else {
                  hasNextPage = true;
                  setState(() {});
                }
                for (int i = 0; i < state.variantsList.data.length; i++) {
                  variantList.add(state.variantsList.data[i]);
                }

                setState(() {});
              }

              if (state is VariantsListFailed) {
                isLoading = false;
                setState(() {});
              }
            },
          )
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
pageNo++;
                  if (hasNextPage == true) {
                    if (authentication.authenticatedUser.userType ==
                        "wmanager") {
                      context.read<VariantBloc>().add(GetAllVariants(
                          pageNo: pageNo,
                          fromWarehouse: true,
                          id: authentication
                                  .authenticatedUser.businessData?.businessId
                                  .toString() ??
                              ""));
                    } else {
                      print("paahsfgh $pageNo");
                      context
                          .read<VariantBloc>()
                          .add(GetAllVariants(pageNo: pageNo));
                    }
                    if (mounted) {
                      refreshController.loadComplete();
                    }
                  } else {
                    log(1.1);
                  }
                },
                enablePullDown: false,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: isTab(context) ? 30 : 16),
                        height: 43,
                        decoration:
                            const BoxDecoration(color: Color(0xFFF7F7F7)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Variants: ${count}',
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
                                          screen: const CreateNewVariant());
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
                                : SizedBox()
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: isTab(context) ? 30 : 16,
                              right: isTab(context) ? 30 : 16,
                              bottom: 0),
                          child: CurvedTextField(
                            title: "Search variants",
                            onChanged: (val) {
                              variantList.clear();
                              context
                                  .read<VariantBloc>()
                                  .add(GetAllVariants(element: val,pageNo: 1));
                            },
                            isSearch: true,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      variantList.isEmpty
                          ? NoSearchData()
                          : Container(
                              padding: EdgeInsets.only(
                                  left: isTab(context) ? 30 : 16,
                                  right: isTab(context) ? 30 : 16,
                                  bottom: 30),
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                primary: false,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 8,
                                ),
                                itemCount: variantList.length,
                                itemBuilder: (context, index) {
                                  return VariantsTileCard(
                                    onAssignStock: () {
                                      PersistentNavBarNavigator.pushNewScreen(
                                          context,
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
      ),
    );
  }
}
