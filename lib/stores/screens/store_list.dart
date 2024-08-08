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
        .add(GetAllStores(warehouseId: widget.warehouseId));
    super.initState();
  }

  List<StoreModel> stores = [];

  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return BlocListener<ManageStoreBloc, ManageStoreState>(
      listener: (context, state) {
        if (state is ListStoresLoading) {}
        if (state is ListStoresSuccess) {
          isLoading = false;
          stores.clear();
          stores = state.productList;
          setState(() {});
        }
        if (state is ListStoresFailed) {
          isLoading = false;
          stores = [];
          setState(() {});
        }
      },
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
                    onTap: () {},
                    isButton: authentication.authenticatedUser.userType ==
                            "admin" ||
                        authentication.authenticatedUser.userType == "wmanager")
                : SingleChildScrollView(
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
                                    authentication.authenticatedUser.userType !=
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
                        authentication.authenticatedUser.userType ==
                                    "wmanager" ||
                                stores.isEmpty && _searchController == ""
                            ? SizedBox()
                            : Container(
                                padding: EdgeInsets.only(
                                    left: isTab(context) ? 30 : 16,
                                    right: isTab(context) ? 30 : 16,
                                    bottom: 0),
                                child: CurvedTextField(
                                  controller: _searchController,
                                  onChanged: (p0) {
                                    context.read<ManageStoreBloc>().add(
                                        GetAllStores(
                                            searchKey: _searchController.text));
                                  },
                                  title: "Search stores",
                                  isSearch: true,
                                )),
                        authentication.authenticatedUser.userType == "wmanager"
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
    );
  }
}
