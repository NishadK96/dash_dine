import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/products/widgets/products_tile_card.dart';
import 'package:pos_app/stores/data/store_data_soure.dart';
import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/stores/screens/edit_store.dart';
import 'package:pos_app/stores/screens/store_list.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/variants/screens/widgets/variant_product_card.dart';
import 'package:pos_app/warehouse/widgets/delete_popup.dart';

class StoreTileCard extends StatefulWidget {
  final String? imagePro;
  final VoidCallback? onTap;
  final StoreModel storeData;
  const StoreTileCard(
      {super.key, this.imagePro, this.onTap, required this.storeData});

  @override
  State<StoreTileCard> createState() => _StoreTileCardState();
}

class _StoreTileCardState extends State<StoreTileCard> {
  final List<BottomSheetModel> bottomSheetList = [
    const BottomSheetModel(
      value: "edit",
      name: "Edit Store",
    ),
    const BottomSheetModel(
        value: "delete", name: "Delete Store", isAlert: true),
  ];
  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;

    return InkWell(
      // onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Color(0x33D9D9D9),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.string(
                    CommonSvgFiles().warehouseSvgNewTile,
                    height: 1,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.storeData.name.toString().toTitleCase(),
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF1C1B1F),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "${widget.storeData.address.toString().toTitleCase()},",
                            style: GoogleFonts.urbanist(
                              color: ColorTheme.secondary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text:
                                widget.storeData.city.toString().toTitleCase(),
                            style: GoogleFonts.urbanist(
                              color: ColorTheme.secondary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.string(CommonSvgFiles().storeWareHouseSvg),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.storeData.warehouseName ?? "",
                          style: GoogleFonts.urbanist(
                            color: const Color(0xFF8390A1),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            authentication.authenticatedUser.userType != "manager"
                ? InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                height: isTab(context) ? 170 : 160,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10))),
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
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
                                                      .pushNewScreen(context,
                                                          withNavBar: false,
                                                          screen: EditStore(
                                                            storeData: widget
                                                                .storeData,
                                                          ));
                                                }
                                                if (bottomSheetList[index]
                                                        .value ==
                                                    "delete") {
                                                  DeletePopup().deleteAlert(
                                                    context,
                                                    "Are you sure you want to delete\nStore",
                                                    () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      StoreDataSource()
                                                          .deleteStore(
                                                              storeId: widget
                                                                  .storeData.id
                                                                  .toString())
                                                          .then(
                                                        (value) {
                                                          if (value.data1 ==
                                                              true) {
                                                            stores.clear();
                                                            setState(()
                                                            {

                                                            });

                                                            context
                                                                .read<
                                                                    ManageStoreBloc>()
                                                                .add(
                                                                    GetAllStores(pageNo: 1));
                                                            Fluttertoast
                                                                .showToast(
                                                                    msg: value
                                                                        .data2);
                                                            setState(()
                                                            {

                                                            });
                                                          } else {
                                                            Fluttertoast
                                                                .showToast(
                                                                    msg: value
                                                                        .data2);
                                                          }
                                                        },
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    bottomSheetList[index]
                                                            .name ??
                                                        "",
                                                    style: GoogleFonts.urbanist(
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
                                          separatorBuilder: (context, index) =>
                                              Divider(
                                                height: 8,
                                                color: ColorTheme.backGround,
                                              ),
                                          itemCount: bottomSheetList.length),
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
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 8),
                      child: SvgPicture.string(CommonSvgFiles().moreSvg),
                    ))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
