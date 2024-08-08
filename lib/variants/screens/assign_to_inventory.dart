import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/manager/screens/create_manager.dart';
import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/variants/data/data_source.dart';
import 'package:pos_app/variants/model/assign_model.dart';
import 'package:pos_app/variants/model/variant_model.dart';
import 'package:pos_app/variants/variant_bloc.dart';
import 'package:pos_app/warehouse/bloc/manage_warehouse/manage_warehouse_bloc.dart';
import 'package:pos_app/warehouse/models/warehouse_model.dart';

class AssignToInventory extends StatefulWidget {
  const AssignToInventory({Key? key, required this.variantCard})
      : super(key: key);
  final VariantsListModel? variantCard;

  @override
  State<AssignToInventory> createState() => _AssignToInventoryState();
}

class _AssignToInventoryState extends State<AssignToInventory> {
   VariantsListModel? variantDetails;
  @override
  void initState() {
    VariantDataSource()
        .getVariantDetails(id: widget.variantCard?.id ?? 0)
        .then((value) {
      isLoading=false;
      if (value.data1 == true) {
        variantDetails = value.data2;
        setState(() {});
      } else {
        setState(() {});
      }
    });
    context.read<ManageWarehouseBloc>().add(GetAllWarehouses(""));
    super.initState;
  }

  List<WareHouseModel> warehouses = [];
  bool isLoading = true;
  bool isWareHouse = false;
  int? seletedId;
  String? seletedWareHouse;
  List<InventoryId> stores = [];
  List<AssignToStock> alreadyAssignedStores = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Assign to Inventories")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ManageStoreBloc, ManageStoreState>(
            listener: (context, state) {
              if (state is ListStoresUnderWareHouseLoading) {}
              if (state is ListStoresUnderWareHouseSuccess) {
                stores.clear();
                stores = state.productList;
                setState(() {});
              }
              if (state is ListStoresUnderWareHouseFailed) {
                isLoading = false;
                stores = [];
                setState(() {});
              }
            },
          ),
          BlocListener<VariantBloc, VariantState>(
            listener: (context, state) {
              if (state is AlreadyAssignedInventoryLoading) {}
              if (state is AlreadyAssignedInventorySuccess) {
                alreadyAssignedStores.clear();
                alreadyAssignedStores = state.alreadyAssignedList;
                setState(() {});
              }
              if (state is AlreadyAssignedInventoryFailed) {
                // isLoading = false;
                alreadyAssignedStores = [];
                setState(() {});
              }
            },
          ),
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
          ),
        ],
        child: isLoading
            ? const LoadingPage()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
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
                            child: ListTile(
                              leading: Container(
                                height: 51.w,
                                width: 51.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          widget.variantCard?.image ?? ""),
                                      fit: BoxFit.fill),
                                  color: const Color(0x33D9D9D9),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Text(
                                widget.variantCard?.name ?? "",
                                style: GoogleFonts.urbanist(
                                  color: const Color(0xFF1C1B1F),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                              subtitle: Text(
                                widget.variantCard?.description ?? "",
                                style: GoogleFonts.urbanist(
                                  color: const Color(0xFF8390A1),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )),
                      ),
                      //  -----------------------------
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Assign to",
                        style: GoogleFonts.urbanist(
                          color: ColorTheme.text,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          isWareHouse = !isWareHouse;
                          setState(() {});
                        },
                        child: Container(
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF7F8F9),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color(0xFFE8ECF4), width: 0.0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  seletedWareHouse ?? "Select WareHouse",
                                  style: GoogleFonts.urbanist(
                                    color: ColorTheme.text,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 0.08,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  isWareHouse
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: ColorTheme.secondary,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      isWareHouse
                          ? AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.bounceIn,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFF7F8F9),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color(0xFFE8ECF4), width: 0.0),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: warehouses.length,
                                itemBuilder: (context, index) {
                                  return ManagerCard(
                                      attributeData: warehouses[index],
                                      onAdd: () {
                                        if (seletedId == warehouses[index].id) {
                                          seletedId = null;
                                          seletedWareHouse = null;
                                        } else {
                                          isWareHouse = false;
                                          seletedId = warehouses[index].id;
                                          seletedWareHouse =
                                              warehouses[index].name;
                                          context.read<ManageStoreBloc>().add(
                                              GetAllStoresUserWareHouse(
                                                  warehouseId: seletedId ?? 0,variantId: widget.variantCard?.id??0));
                                          context.read<VariantBloc>().add(
                                              (GetAlreadyAssignedInventory(
                                                  variantId:
                                                      widget.variantCard?.id ??
                                                          0,
                                                  wareHouseId:
                                                      seletedId ?? 0)));
                                        }
                                        setState(() {});
                                      },
                                      isAdded:
                                          seletedId == warehouses[index].id);
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  height: 0,
                                  color: Color(0xFFE8ECF4),
                                ),
                              ),
                            )
                          : const SizedBox(),

                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: stores.length,
                          itemBuilder: (context, index) {
                            return AssignedStoreListCard(
                              storeDetails: stores[index],
                              assignTap: () {
                                print("shjdjfgcvdhxjcgn ${ widget.variantCard?.productId}");
                                VariantDataSource()
                                    .assignToInventory(
                                        warehouseId: seletedId ?? 0,
                                        variantId: widget.variantCard?.id ?? 0,
                                        inventoryId: stores[index].id ?? 0,
                                        productId:
                                        variantDetails?.variantData?.productId?.id ?? 1)
                                    .then((value) {
                                  if (value.data1 == true) {
                                    Fluttertoast.showToast(msg: value.data2);
                                    context.read<VariantBloc>().add(
                                        (GetAlreadyAssignedInventory(
                                            variantId:
                                                widget.variantCard?.id ?? 0,
                                            wareHouseId: seletedId ?? 0)));
                                    context.read<ManageStoreBloc>().add(
                                        GetAllStoresUserWareHouse(
                                            warehouseId: seletedId ?? 0,variantId: widget.variantCard?.id??0));
                                  } else {
                                    Fluttertoast.showToast(msg: value.data2);
                                  }
                                });
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 5,
                              )),

                      const SizedBox(
                        height: 15,
                      ),
                      alreadyAssignedStores.isEmpty
                          ? const SizedBox()
                          : Text(
                              "Already Assign to",
                              style: GoogleFonts.urbanist(
                                color: ColorTheme.text,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      alreadyAssignedStores.isEmpty
                          ? const SizedBox()
                          : ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: alreadyAssignedStores.length,
                              itemBuilder: (context, index) {
                                return AlreadyAssignedStoreListCard(
                                  storeDetails: alreadyAssignedStores[index],
                                  assignTap: () {
                                    VariantDataSource()
                                        .deleteAlreadyAssignToInventory(
                                      variantId: widget.variantCard?.id ?? 0,
                                      inventoryId: alreadyAssignedStores[index]
                                              .inventoryId
                                              ?.id ??
                                          0,
                                    )
                                        .then((value) {
                                      if (value.data1 == true) {
                                        Fluttertoast.showToast(
                                            msg: value.data2);
                                        context.read<VariantBloc>().add(
                                            (GetAlreadyAssignedInventory(
                                                variantId:
                                                    widget.variantCard?.id ?? 0,
                                                wareHouseId: seletedId ?? 0)));
                                        context.read<ManageStoreBloc>().add(
                                            GetAllStoresUserWareHouse(
                                                warehouseId: seletedId ?? 0,variantId: widget.variantCard?.id??0));
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: value.data2);
                                      }
                                    });
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(
                                    height: 5,
                                  )),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class AlreadyAssignedStoreListCard extends StatelessWidget {
  const AlreadyAssignedStoreListCard(
      {super.key, required this.storeDetails, required this.assignTap});
  final AssignToStock storeDetails;
  final VoidCallback assignTap;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 2,
              offset: Offset(1, 0),
              spreadRadius: 1,
            )
          ],
        ),
        child: ListTile(
          leading: Container(
            height: 35.w,
            width: 35.w,
            decoration: const BoxDecoration(
              image: DecorationImage(image: NetworkImage(""), fit: BoxFit.fill),
              color: Color(0x33D9D9D9),
              shape: BoxShape.circle,
            ),
          ),
          title: Text(
            storeDetails.inventoryId?.name ?? "",
            style: GoogleFonts.urbanist(
              color: const Color(0xFF1C1B1F),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          contentPadding: const EdgeInsets.only(right: 10, left: 10),
          trailing: InkWell(
            onTap: assignTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.string(CommonSvgFiles().delete),
            ),
          ),
        ));
  }
}
class AssignedStoreListCard extends StatelessWidget {
  const AssignedStoreListCard(
      {Key? key, required this.storeDetails, required this.assignTap})
      : super(key: key);
  final InventoryId storeDetails;
  final VoidCallback assignTap;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 2,
              offset: Offset(1, 0),
              spreadRadius: 1,
            )
          ],
        ),
        child: ListTile(
          leading: Container(
            height: 35.w,
            width: 35.w,
            decoration: const BoxDecoration(
              image: DecorationImage(image: NetworkImage(""), fit: BoxFit.fill),
              color: Color(0x33D9D9D9),
              shape: BoxShape.circle,
            ),
          ),
          title: Text(
            storeDetails.name ?? "",
            style: GoogleFonts.urbanist(
              color: const Color(0xFF1C1B1F),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          contentPadding: const EdgeInsets.only(right: 10, left: 10),
          trailing: InkWell(
            onTap: assignTap,
            child: Container(
              decoration: BoxDecoration(
                  color: ColorTheme.primary,
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Assign",
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
          ),
        ))));
  }
}
