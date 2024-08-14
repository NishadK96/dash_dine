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
import 'package:pos_app/common_widgets/drop_down_widget.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/no_data.dart';
import 'package:pos_app/no_search_data.dart';
import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/stores/screens/create_store.dart';
import 'package:pos_app/stores/widgets/store_tile_card.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/warehouse/bloc/manage_warehouse/manage_warehouse_bloc.dart';
import 'package:pos_app/warehouse/models/warehouse_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StoreList extends StatefulWidget {
  const StoreList({super.key, this.warehouseId});
  final String? warehouseId;

  @override
  State<StoreList> createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  @override
  void initState() {
    context
        .read<ManageStoreBloc>()
        .add(GetAllStores(warehouseId: widget.warehouseId, pageNo: 1));
    context.read<ManageWarehouseBloc>().add(GetAllWarehouses(""));
    super.initState();
  }

  List<WareHouseModel> warehouses = [];
  String? selectedValue;

  List<StoreModel> stores = [];
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  bool hasNextPage = false;
  int pageNo = 1;
  String? count;
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return MultiBlocListener(
      listeners: [
        BlocListener<ManageWarehouseBloc, ManageWarehouseState>(
          listener: (context, state) {
            if (state is ListWareHouseLoading) {}
            if (state is ListWareHouseSuccess) {
              warehouses.clear();
              // isLoading = false;
              warehouses = state.productList;
              setState(() {});
            }
            if (state is ListWareHouseFailed) {
              // isLoading = false;
              warehouses = [];
              setState(() {});
            }
          },
        ),
        BlocListener<ManageStoreBloc, ManageStoreState>(
          listener: (context, state) {
            print("ressssss //");
            if (state is ListStoresLoading) {
            } else if (state is ListStoresSuccess) {
              print("ressssss ${state.stores.data.length}");

              isLoading = false;
              count = state.stores.count;
              isLoading = false;
              setState(() {});
              if (state.stores.nextPageUrl == null) {
                hasNextPage = false;
                setState(() {});
              } else {
                hasNextPage = true;
                setState(() {});
              }
              for (int i = 0; i < state.stores.data.length; i++) {
                stores.add(state.stores.data[i]);
              }

              setState(() {});
              print("resssss ");
            } else if (state is ListStoresFailed) {
              isLoading = false;
              setState(() {});
            } else if (state is SearchStoresSuccess) {
              stores.clear();
              for (int i = 0; i < state.stores.data.length; i++) {
                stores.add(state.stores.data[i]);
              }
              setState(() {});
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: CommonAppBar(title: "Stores")),
        body: isLoading
            ? const LoadingPage()
            : stores.isEmpty &&
                    _searchController.text == "" &&
                    isLoading == false
                ? NoDataPage(
                    name: "Create new Store",
                    onTap: () {
                      FocusScope.of(context)
                          .requestFocus(
                          new FocusNode());
                      PersistentNavBarNavigator
                          .pushNewScreen(context,
                          withNavBar: false,
                          screen:
                          const CreateNewStore());
                    },
                    isButton: authentication.authenticatedUser.userType ==
                            "admin" ||
                        authentication.authenticatedUser.userType == "wmanager")
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
                        context.read<ManageStoreBloc>().add(GetAllStores(
                            warehouseId: widget.warehouseId, pageNo: ++pageNo));
                      } else {
                        log(1.1);
                      }
                    },
                    enablePullDown: false,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          stores.isEmpty && _searchController == ""
                              ? SizedBox()
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isTab(context) ? 30 : 16),
                                  height: 43,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFF7F7F7)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Stores: ${stores.length}',
                                        style: GoogleFonts.poppins(
                                          color: ColorTheme.text,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      authentication
                                                  .authenticatedUser.userType !=
                                              "manager"
                                          ? InkWell(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                PersistentNavBarNavigator
                                                    .pushNewScreen(context,
                                                        withNavBar: false,
                                                        screen:
                                                            const CreateNewStore());
                                              },
                                              child: Row(
                                                children: [
                                                  SvgPicture.string(
                                                      CommonSvgFiles()
                                                          .addIconSvg),
                                                  Text(
                                                    'Add New',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                          authentication.authenticatedUser.userType ==
                                      "wmanager" ||
                                  stores.isEmpty && _searchController == ""
                              ? SizedBox()
                              : Container(
                                  padding: EdgeInsets.only(
                                      left: isTab(context) ? 30 : 16,
                                      right: isTab(context) ? 30 : 16,
                                      bottom: 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: CurvedTextField(
                                          controller: _searchController,
                                          onChanged: (p0) {
                                            context
                                                .read<ManageStoreBloc>()
                                                .add(SearchStore(
                                                  searchKey:
                                                      _searchController.text,
                                                ));
                                          },
                                          title: "Search stores",
                                          isSearch: true,
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: DropDownWidget(
                                            value: selectedValue,
                                            items: warehouses,
                                            onChange: (val) {
                                              stores.clear();
                                              context
                                                  .read<ManageStoreBloc>()
                                                  .add(GetAllStores(
                                                      warehouseId: val,
                                                      searchKey: null,
                                                      pageNo: 1));
                                              selectedValue = val;
                                              setState(() {});
                                            },
                                          )),
                                    ],
                                  )),
                          authentication.authenticatedUser.userType ==
                                  "wmanager"
                              ? SizedBox()
                              : const SizedBox(
                                  height: 20,
                                ),
                          stores.isEmpty
                              ? NoSearchData()
                              : Container(
                                  padding: EdgeInsets.only(
                                      bottom: 30,
                                      left: isTab(context) ? 30 : 16,
                                      right: isTab(context) ? 30 : 16),
                                  child: ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (context, index) {
                                        return StoreTileCard(
                                          storeData: stores[index],
                                          onTap: () {
                                            // PersistentNavBarNavigator.pushNewScreen(context,
                                            //     withNavBar: false,
                                            //     screen: const WareHouseDetailPage());
                                          },
                                          imagePro:
                                              "https://png.pngtree.com/thumb_back/fh260/background/20230516/pngtree-person-with-sunglasses-and-beard-image_2563737.jpg",
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                            height: 8,
                                          ),
                                      itemCount: stores.length),
                                )
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
