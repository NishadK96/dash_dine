import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/attributes/screens/attribute_list.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/auth/login_page.dart';
import 'package:pos_app/auth/profile_page.dart';
import 'package:pos_app/common_widgets/linear_grad_container.dart';
import 'package:pos_app/manager/screens/managers_list.dart';
import 'package:pos_app/order/screens/order_history.dart';
import 'package:pos_app/order/screens/order_page.dart';
import 'package:pos_app/products/screens/product_list_costing.dart';
import 'package:pos_app/products/screens/products_and_variants.dart';
import 'package:pos_app/stock_adjustments/data/admin_data_source.dart';
import 'package:pos_app/stock_adjustments/model/dashboard_admin_model.dart';
import 'package:pos_app/stock_adjustments/screens/stock_adjustment_list_by_admin.dart';
import 'package:pos_app/stores/screens/stock_manage_by_inventory.dart';
import 'package:pos_app/stores/screens/store_list.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/products/screens/products_list.dart';
import 'package:pos_app/common_widgets/quick_action_card.dart';
import 'package:pos_app/utils/variables.dart';
import 'package:pos_app/variants/screens/variant_list.dart';
import 'package:pos_app/variants/screens/variant_list_for_stock_adjust.dart';
import 'package:pos_app/warehouse/screens/warehouse_list.dart';

class DashBoard extends StatefulWidget {
  DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final List<Widget> adminScreens = [
    const ManagersList(
      managerType: "wmanager",
    ),
    const WarehouseList(),
    const StoreList(),
    const ProductsListScreen(),
    const VariantsListScreen(),
    const StockAdjustmentListByAdmin(),
    const ManagersList(
      managerType: "manager",
    ),
    const AttributeList(),
  ];

  final List<DashBoardModel> dashData = [
    DashBoardModel(
        title: "Total orders",
        count: "05",
        containerColor: const Color(0xFFF8E9C8),
        svgIcon: CommonSvgFiles().fingersvg),
    DashBoardModel(
        title: "Total Warehouses",
        count: "05",
        containerColor: const Color(0xFFDEECEC),
        svgIcon: CommonSvgFiles().dashIcon2),
    DashBoardModel(
        title: "Total Employees",
        count: "16",
        containerColor: const Color(0xFFDEECEC),
        svgIcon: CommonSvgFiles().dashIcon3),
    DashBoardModel(
        title: "Total Stores",
        count: "08",
        containerColor: const Color(0xFFDED3FD),
        svgIcon: CommonSvgFiles().dashIcon4),
  ];

  final List<QuicKActionModel> quickDataAdmin = [
    QuicKActionModel(
        title: "Warehouse Managers",
        svgIcon: CommonSvgFiles().quickActtionSvg1),
    QuicKActionModel(
        title: "Warehouse", svgIcon: CommonSvgFiles().quickActtionSvg2),
    QuicKActionModel(
        title: "Stores", svgIcon: CommonSvgFiles().quickActtionSvg4),
    QuicKActionModel(
        title: "Products", svgIcon: CommonSvgFiles().quickActtionSvg3),
    QuicKActionModel(
        title: "Variants", svgIcon: CommonSvgFiles().quickActtionSvg4),
    QuicKActionModel(
        title: "Stock Adjust List",
        svgIcon: CommonSvgFiles().quickActtionSvg4),
    QuicKActionModel(
        title: "Store Managers", svgIcon: CommonSvgFiles().quickActtionSvg1),
    QuicKActionModel(
        title: "Attributes", svgIcon: CommonSvgFiles().attributeSvg),
  ];

  final List<QuicKActionModel> quickDataWareHouse = [
    QuicKActionModel(
        title: "Store Managers", svgIcon: CommonSvgFiles().quickActtionSvg1),
    QuicKActionModel(
        title: "Stores", svgIcon: CommonSvgFiles().quickActtionSvg4),
    QuicKActionModel(
        title: "Variants", svgIcon: CommonSvgFiles().quickActtionSvg4),
  ];

  final List<Widget> wareHouseScreens = [
    const ManagersList(
      managerType: "manager",
    ),
    const StoreList(),
    const VariantsListScreen(),
  ];

  final List<QuicKActionModel> quickDataStore = [
    QuicKActionModel(
        title: "Create order", svgIcon: CommonSvgFiles().quickActtionSvg4),
    QuicKActionModel(
        title: "Products And Variants",
        svgIcon: CommonSvgFiles().quickActtionSvg3),
    QuicKActionModel(
        title: "Stock Adjust", svgIcon: CommonSvgFiles().quickActtionSvg4),
    QuicKActionModel(
        title: "Order History", svgIcon: CommonSvgFiles().quickActtionSvg4),
    QuicKActionModel(
        title: "Add Costing", svgIcon: CommonSvgFiles().quickActtionSvg3),
    QuicKActionModel(
        title: "Manage Stock", svgIcon: CommonSvgFiles().quickActtionSvg2),
  ];

  final List<Widget> storeScreens = [
    const OrderPage(),
    const ProductsAndVariants(),
    const VariantsListForStockAdjust(),
    const OrderHistory(),
    const ProductsListCostingScreen(),
    const StockManageByInventory(),
  ];
  AdminDashboard? adminData;
  @override
  void initState() {
    AdminDataSource().adminDashboard().then((value) {
      adminData = value.data2;
      print("admin dataaa ${adminData?.productCount}");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "authhh ${authentication.authenticatedUser.businessData?.businessId}");
    print("authhh ${authentication.authenticatedUser.businessData?.name}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: ColorTheme.primary,
          content: Text(
            "Please double tap to exit the app!",
            style: GoogleFonts.urbanist(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
        ),
        child: Container(
          padding:  EdgeInsets.symmetric(horizontal:isTab(context)?25: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 60,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dashboard',
                          style: GoogleFonts.urbanist(
                            color: const Color(0xFF1E232C),
                            fontSize: 27.sp,
                            fontWeight: FontWeight.w700,
                            // height: 0.05,
                            letterSpacing: -0.27,
                          ),
                        ),
                        PopupMenuButton(color: Colors.white,
                          surfaceTintColor: Colors.white,
                          position: PopupMenuPosition.under,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              height: 35,
                              child: const Text("View Profile"),
                              onTap: () {
                               PersistentNavBarNavigator.pushNewScreen(context, screen: ProfileScreen());

                              },
                            ),
                            PopupMenuItem(
                              height: 35,
                              child: const Text("Log out"),
                              onTap: () {
                                authentication.clearAuthenticatedUser();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                        (route) => false);
                              },
                            )
                          ],
                        )
                        // InkWell(
                        //     onTap: () {
                        //       authentication.clearAuthenticatedUser();
                        //     },
                        //     child: const Icon(Icons.cached))
                      ],
                    ),
                    // isTab(context)
                    //     ? SizedBox(
                    //       height: heightDouble(context,8),
                    //       width: widthDouble(context, 1),
                    //       child: ListView(
                    //         // physics: NeverScrollableScrollPhysics(),
                    //         scrollDirection: Axis.horizontal,
                    //         primary: true,
                    //         shrinkWrap: true,
                    //           children: [
                    //             DashboardCard(
                    //               containerColor: dashData[0].containerColor,
                    //               title: "Warehouse count",
                    //               count: adminData?.warehouseCount.toString(),
                    //               svgIcon: dashData[0].svgIcon,
                    //             ),
                    //             SizedBox(width: 5,),
                    //             DashboardCard(
                    //               containerColor: dashData[1].containerColor,
                    //               title: "Product count",
                    //               count: adminData?.productCount.toString(),
                    //               svgIcon: dashData[1].svgIcon,
                    //             ),
                    //             SizedBox(width: 5,),
                    //             DashboardCard(
                    //               containerColor: dashData[2].containerColor,
                    //               title: "Variant count",
                    //               count: adminData?.variantCount.toString(),
                    //               svgIcon: dashData[2].svgIcon,
                    //             ),
                    //             SizedBox(width: 5,),
                    //             DashboardCard(
                    //               containerColor: dashData[3].containerColor,
                    //               title: "Inventory count",
                    //               count: adminData?.inventoryCount.toString(),
                    //               svgIcon: dashData[3].svgIcon,
                    //             ),
                    //             SizedBox(width: 5,),
                    //             DashboardCard(
                    //               containerColor: dashData[3].containerColor,
                    //               title: "Stock adjustment request count",
                    //               count: adminData?.stockAdjustmentRequestCount.toString(),
                    //               svgIcon: dashData[3].svgIcon,
                    //             ),
                    //           ],
                    //         ),
                    //     )
                    //     :
                    GridView.count(
                            padding: const EdgeInsets.only(top: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio:isTab(context)?2.7:  1.6,
                            children: [
                                DashboardCard(
                                  containerColor: dashData[0].containerColor,
                                  title: "Warehouse count",
                                  count: adminData?.warehouseCount.toString(),
                                  svgIcon: dashData[0].svgIcon,
                                ),
                                DashboardCard(
                                  containerColor: dashData[1].containerColor,
                                  title: "Product count",
                                  count: adminData?.productCount.toString(),
                                  svgIcon: dashData[1].svgIcon,
                                ),
                                DashboardCard(
                                  containerColor: dashData[2].containerColor,
                                  title: "Variant count",
                                  count: adminData?.variantCount.toString(),
                                  svgIcon: dashData[2].svgIcon,
                                ),
                                DashboardCard(
                                  containerColor: dashData[3].containerColor,
                                  title: "Inventory count",
                                  count: adminData?.inventoryCount.toString(),
                                  svgIcon: dashData[3].svgIcon,
                                ),
                              ]
                            //  List.generate(
                            //     4,
                            //     (index) => DashboardCard(
                            //           containerColor: dashData[index].containerColor,
                            //           title: adminData[index].title,
                            //           count: dashData[index].count,
                            //           svgIcon: dashData[index].svgIcon,
                            //         )),
                            )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SvgPicture.string(CommonSvgFiles().menuIcon),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Data is updated on daily basis',
                      style: GoogleFonts.urbanist(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: isTab(context)?20:16.sp,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Quick Actions',
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF1E232C),
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GridView.count(
                  padding: const EdgeInsets.only(top: 0, bottom: 30),
                  physics: const NeverScrollableScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  crossAxisCount:isTab(context)?5: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio:isTab(context)?1.2: 0.8,
                  children: List.generate(
                      authentication.authenticatedUser.userType == "admin"
                          ? quickDataAdmin.length
                          : authentication.authenticatedUser.userType ==
                                  "wmanager"
                              ? quickDataWareHouse.length
                              : quickDataStore.length,
                      (index) => QuickActionCard(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(context,
                                  withNavBar: false,
                                  screen: authentication
                                              .authenticatedUser.userType ==
                                          "admin"
                                      ? adminScreens[index]
                                      : authentication
                                                  .authenticatedUser.userType ==
                                              "wmanager"
                                          ? wareHouseScreens[index]
                                          : storeScreens[index]);
                            },
                            svgIcon: authentication
                                        .authenticatedUser.userType ==
                                    "admin"
                                ? quickDataAdmin[index].svgIcon ?? ""
                                : authentication.authenticatedUser.userType ==
                                        "wmanager"
                                    ? quickDataWareHouse[index].svgIcon ?? ""
                                    : quickDataStore[index].svgIcon ?? "",
                            title: authentication.authenticatedUser.userType ==
                                    "admin"
                                ? quickDataAdmin[index].title ?? ""
                                : authentication.authenticatedUser.userType ==
                                        "wmanager"
                                    ? quickDataWareHouse[index].title ?? ""
                                    : quickDataStore[index].title ?? "",
                          )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      'Effective stock adjustment is\ncrucial for maintaining accurate\ninventory.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFFE1E2E5),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      'Version 1.0.0',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.urbanist(
                        color: ColorTheme.text,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashBoardModel {
  final String? title;
  final String? count;
  final String? svgIcon;
  final Color? containerColor;
  DashBoardModel({
    this.title,
    this.count,
    this.svgIcon,
    this.containerColor,
  });
}

class QuicKActionModel {
  final String? title;
  final String? svgIcon;
  QuicKActionModel({
    this.title,
    this.svgIcon,
  });
}
