import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/products/widgets/products_tile_card.dart';
import 'package:pos_app/stores/screens/assign_stock.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/variants/model/variant_model.dart';
import 'package:pos_app/variants/screens/assign_to_inventory.dart';
import 'package:pos_app/variants/screens/edit_variant.dart';
import 'package:pos_app/variants/variant_bloc.dart';
import 'package:pos_app/warehouse/widgets/delete_popup.dart';

class VariantsTileCard extends StatelessWidget {
  final VariantsListModel? variantCard;
  final VoidCallback? onAssignStock;

  VariantsTileCard({super.key, this.variantCard, this.onAssignStock});

  final List<BottomSheetModel> bottomSheetList =
      authentication.authenticatedUser.userType == "wmanager"
          ? [
              const BottomSheetModel(
                value: "edit",
                name: "Edit Variant Details",
              ),
              // const BottomSheetModel(
              //   value: "atoi",
              //   name: "Assign to Inventories",
              // ),
              const BottomSheetModel(
                value: "atos",
                name: "Assign Stock",
              ),
              const BottomSheetModel(
                  value: "delete", name: "Delete Variant", isAlert: true),
            ]
          : [
              // const BottomSheetModel(
              //   value: "view",
              //   name: "View Variant",
              // ),
              const BottomSheetModel(
                value: "edit",
                name: "Edit Variant Details",
              ),
              const BottomSheetModel(
                value: "atoi",
                name: "Assign to Inventories",
              ),

              const BottomSheetModel(
                  value: "delete", name: "Delete Variant", isAlert: true),
            ];
  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(variantCard?.image ?? ""),
                            fit: BoxFit.fill),
                        color: const Color(0x33D9D9D9),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width:isTab(context)?w1-165:  w1 - 140,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: w1 / 2,
                                    child: Text(
                                      variantCard?.name
                                              .toString()
                                              .toTitleCase() ??
                                          "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.urbanist(
                                        color: const Color(0xFF1C1B1F),
                                        fontSize:18.sp,
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  variantCard?.description == null
                                      ? const SizedBox()
                                      : SizedBox(
                                          width:isTab(context)?w1-165: w1 - 160,
                                          child: Text(
                                            variantCard?.description ?? "",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.urbanist(
                                              color: const Color(0xFF8390A1),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                authentication.authenticatedUser.userType == "manager"
                    ? Container()
                    : InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    height: authentication
                                                .authenticatedUser.userType ==
                                            "wmanager"
                                        ? 260.h
                                        : 240.h,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10))),
                                    child: SingleChildScrollView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            width: 50.w,
                                            height: 7.h,
                                            decoration: BoxDecoration(
                                                color: ColorTheme.secondaryBlue,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          ListView.separated(
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              padding: const EdgeInsets.all(16),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    if (bottomSheetList[index]
                                                            .value ==
                                                        "edit") {
                                                      Navigator.pop(context);
                                                      PersistentNavBarNavigator
                                                          .pushNewScreen(
                                                              context,
                                                              screen:
                                                                  EditVariant(
                                                                variantCard:
                                                                    variantCard,
                                                              ));
                                                    }
                                                    if (bottomSheetList[index]
                                                            .value ==
                                                        "atos") {
                                                      PersistentNavBarNavigator
                                                          .pushNewScreen(
                                                              context,
                                                              screen:
                                                                  AssignStock(
                                                                variantData:
                                                                    variantCard,
                                                              ));
                                                    }
                                                    if (bottomSheetList[index]
                                                            .value ==
                                                        'atoi') {
                                                      PersistentNavBarNavigator
                                                          .pushNewScreen(
                                                              context,
                                                              screen:
                                                                  AssignToInventory(
                                                                variantCard:
                                                                    variantCard,
                                                              ));
                                                    }
                                                    if (bottomSheetList[index]
                                                            .value ==
                                                        'delete') {

                                                      DeletePopup().deleteAlert(context, "Are you sure you want to delete\nVariant",
                                                      () {
                                                        context
                                                            .read<VariantBloc>()
                                                            .add(DeleteVariantEvent(
                                                            variantId:
                                                            variantCard
                                                                ?.id ??
                                                                0));
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },);

                                                    }
                                                  },
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Text(
                                                        bottomSheetList[index]
                                                                .name ??
                                                            "",
                                                        style: GoogleFonts
                                                            .urbanist(
                                                          color: bottomSheetList[
                                                                          index]
                                                                      .isAlert ==
                                                                  true
                                                              ? ColorTheme.red
                                                              : ColorTheme.text,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) => Divider(
                                                        height: 8,
                                                        color: ColorTheme
                                                            .backGround,
                                                      ),
                                              itemCount:
                                                  bottomSheetList.length),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 10, right: 10),
                          child: SvgPicture.string(CommonSvgFiles().moreSvg),
                        ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetModel {
  final String? name;
  final String? value;
  final bool? isAlert;
  const BottomSheetModel({this.name, this.value, this.isAlert = false});
}
