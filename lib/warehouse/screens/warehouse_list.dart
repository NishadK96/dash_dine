import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/no_search_data.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/warehouse/bloc/manage_warehouse/manage_warehouse_bloc.dart';
import 'package:pos_app/warehouse/models/warehouse_model.dart';
import 'package:pos_app/warehouse/screens/create_Warehouse.dart';
import 'package:pos_app/warehouse/screens/ware_house_detail.dart';
import 'package:pos_app/warehouse/widgets/delete_popup.dart';
import 'package:pos_app/warehouse/widgets/warehouse_tile_card.dart';

class WarehouseList extends StatefulWidget {
  const WarehouseList({super.key});

  @override
  State<WarehouseList> createState() => _WarehouseListState();
}

class _WarehouseListState extends State<WarehouseList> {
  TextEditingController _searchController=TextEditingController();
  final List<String> images = [];
  @override
  void initState() {
    context.read<ManageWarehouseBloc>().add(GetAllWarehouses(""));
    super.initState();
  }

  List<WareHouseModel> warehouses = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Warehouses")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ManageWarehouseBloc, ManageWarehouseState>(
            listener: (context, state) {
              if (state is ListWareHouseLoading) {}
              if (state is ListWareHouseSuccess) {
                warehouses.clear();
                isLoading = false;
                warehouses = state.productList;
                setState(() {});
              }
              if (state is ListWareHouseFailed) {
                isLoading = false;
                warehouses = [];
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
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding:  EdgeInsets.symmetric(horizontal:isTab(context)?30: 16),
                      height: 43,
                      decoration: const BoxDecoration(color: Color(0xFFF7F7F7)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Warehouse: ${warehouses.length}',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF6D6D6D),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.30,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(context,
                                  withNavBar: false,
                                  screen: const CreateNewWareHouse());

                            },
                            child: Row(
                              children: [
                                SvgPicture.string(CommonSvgFiles().addIconSvg),
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
                        ],
                      ),
                    ),
                      const SizedBox(
                  height: 10,
                ),
                Container(
                   padding:  EdgeInsets.only(
                                left:isTab(context)?30: 16, right:isTab(context)?30: 16, bottom: 0),
                  child: CurvedTextField(controller: _searchController,
                    onChanged: (p0) {
                      context.read<ManageWarehouseBloc>().add(GetAllWarehouses(_searchController.text));
                    },
                    // controller: productNameController,
                    title: "Search warehouse..",
                  ),
                ),
                    const SizedBox(
                      height: 20,
                    ),
                    warehouses.isEmpty? NoSearchData():  Container(
                      padding:  EdgeInsets.symmetric(horizontal:isTab(context)?30: 16),
                      child: ListView.separated(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return WarehouseTileCard(
                              email: warehouses[index].email,
                              city: warehouses[index].city,
                              address: warehouses[index].addressLine,
                              name: warehouses[index].name,
                              onTap: () {
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    withNavBar: false,
                                    screen: WareHouseDetailPage(
                                      warehouses: warehouses[index],
                                    ));
                              },
                              imagePro:
                                  "https://png.pngtree.com/thumb_back/fh260/background/20230516/pngtree-person-with-sunglasses-and-beard-image_2563737.jpg",
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 8,
                              ),
                          itemCount: warehouses.length),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
