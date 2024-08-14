import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/auth/login_page.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/manager/bloc/manager_bloc.dart';
import 'package:pos_app/manager/screens/create_manager.dart';
import 'package:pos_app/manager/services/model/model.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/products/screens/products_list.dart';
import 'package:pos_app/products/screens/special_products.dart';
import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
import 'package:pos_app/stores/screens/store_list.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/manager/widgets/manager_tile_card.dart';
import 'package:pos_app/warehouse/bloc/manage_warehouse/manage_warehouse_bloc.dart';
import 'package:pos_app/warehouse/data/warehouse_datasource.dart';
import 'package:pos_app/warehouse/models/warehouse_model.dart';
import 'package:pos_app/warehouse/screens/edit_warehouse.dart';
import 'package:pos_app/warehouse/widgets/delete_popup.dart';

class WareHouseDetailPage extends StatefulWidget {
  const WareHouseDetailPage({super.key, required this.warehouses});
  final WareHouseModel? warehouses;

  @override
  State<WareHouseDetailPage> createState() => _WareHouseDetailPageState();
}

class _WareHouseDetailPageState extends State<WareHouseDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ManageStoreBloc>().add(GetAllStores(warehouseId: widget.warehouses?.id.toString()));
    context
        .read<ManagerBloc>()
        .add(GetAllMangers(managerType: "wmanager",wareHouseId: widget.warehouses?.id.toString()));
    context.read<ProductListBloc>().add(GetAllProducts(
        underWareHouse: true, inventoryId: widget.warehouses?.id));
  }
String productCount="0";
String storeCount="0";
  List<ManagerList> managerList=[];
  bool isLoading=true;
  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Color(0xffF5F5F5),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(
            title: "Warehouse",
            popUp: PopupMenuButton(
              surfaceTintColor: Colors.white,
              position: PopupMenuPosition.under,
              itemBuilder: (context) => [
                PopupMenuItem(
                  height: 35,
                  child: const Text("Edit"),
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: EditWareHouse(
                          warehouses: widget.warehouses,
                        ));
                  },
                ),
                PopupMenuItem(
                  height: 35,
                  child: const Text("Delete"),
                  onTap: () {
                    DeletePopup().deleteAlert(
                      context,
                      "Are you sure you want to delete\nWareHouse",
                      () {
                        Navigator.pop(context);
                        WareHouseDataSource()
                            .deleteWarehouse(
                                storeId: widget.warehouses?.id.toString() ?? "")
                            .then(
                          (value) {
                            if (value.data1 == true) {
                              context
                                  .read<ManageWarehouseBloc>()
                                  .add(GetAllWarehouses(""));
                              Fluttertoast.showToast(msg: value.data2);
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(msg: value.data2);
                            }
                          },
                        );
                      },
                    );
                  },
                )
              ],
            ),
          )),
      body: MultiBlocListener(listeners: [
        BlocListener<ManagerBloc, ManagerState>(
          listener: (context, state) {
            if (state is ManagerListLoading) {}
            if (state is ManagerListSuccess) {
              isLoading=false;
              managerList = state.managerList;
              setState(() {});
            }
            if (state is ManagerListFailed) {
              isLoading=false;
              managerList = [];
              setState(() {});
            }
          },
        ),
    BlocListener<ManageStoreBloc, ManageStoreState>(
    listener: (context, state) {
    if (state is ListStoresSuccess) {
    storeCount = state.stores.count??"0";
    setState(() {});
    }
    },),
        BlocListener<ProductListBloc,ProductListState>(listener: (context, state) {
          if(state is ProductListSuccess)
            {
              productCount=state.productList.count??"0";
              setState(() {

              });
            }
        },)
      ],
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, left: 15, right: 15),
                  width: w1,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0xFF565656), Color(0xFF1C1B1F)],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x05000000),
                        blurRadius: 2,
                        offset: Offset(1, 0),
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 55.h,
                            width: 55.h,
                            decoration: const BoxDecoration(
                              color: Color(0x33D9D9D9),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.string(
                              CommonSvgFiles().warehouseSvgNew,
                              height: 1,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.warehouses?.name ?? "",
                                style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.string(CommonSvgFiles().locationSvg),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${widget.warehouses?.addressLine}, \n${widget.warehouses?.city}, Saudi Arabia ',
                                    style: GoogleFonts.urbanist(
                                      color: Colors.white
                                          .withOpacity(0.6000000238418579),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10, right: 10),
                              decoration: ShapeDecoration(
                                color:
                                    Colors.white.withOpacity(0.10000000149011612),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x05000000),
                                    blurRadius: 2,
                                    offset: Offset(1, 0),
                                    spreadRadius: 1,
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        storeCount.toString(),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.urbanist(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Stores',
                                        style: GoogleFonts.urbanist(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10, right: 10),
                              decoration: ShapeDecoration(
                                color:
                                    Colors.white.withOpacity(0.10000000149011612),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x05000000),
                                    blurRadius: 2,
                                    offset: Offset(1, 0),
                                    spreadRadius: 1,
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        productCount.toString(),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.urbanist(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Products',
                                        style: GoogleFonts.urbanist(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(context,
                            withNavBar: false, screen:  StoreList(warehouseId: widget.warehouses?.id.toString(),));
                      },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x05000000),
                                blurRadius: 2,
                                offset: Offset(1, 0),
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.string(CommonSvgFiles().store),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'View Stores',
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 0.08,
                                  letterSpacing: -0.30,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              SvgPicture.string(CommonSvgFiles().arrowRight)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: InkWell(onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(context,
                            withNavBar: false,
                            screen: SpecialProductsListScreen(
                              fromWareHouse: true,
                              wareHouseId: widget.warehouses?.id,
                            ));
                      },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x05000000),
                                blurRadius: 2,
                                offset: Offset(1, 0),
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.string(CommonSvgFiles().store),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'View Products',
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 0.08,
                                  letterSpacing: -0.30,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              SvgPicture.string(CommonSvgFiles().arrowRight)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              managerList.isEmpty && isLoading==false?  Container(
                  height: h / 2.2,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Manager list is empty!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w1 / 4),
                        child: CommonButton(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreen(context,
                                withNavBar: false,
                                screen: const CreateManagerPage(
                                  managerType: "wmanager",
                                ));
                          },
                          title: "Create a Manager",
                        ),
                      )
                    ],
                  ),
                ):managerList.isEmpty && isLoading==true?SizedBox():
              Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Warehouse Managers',
                          style: GoogleFonts.urbanist(
                            color: const Color(0xFF1E232C),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 15),
                      child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return ManagerTileCard(managerDetails: managerList[index],
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 8,
                              ),
                          itemCount: managerList.length),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
