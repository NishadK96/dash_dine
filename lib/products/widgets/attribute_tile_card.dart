import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/attributes/screens/edit_attribute.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/products/data/data_source.dart';
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/variants/screens/widgets/variant_product_card.dart';
import 'package:pos_app/warehouse/widgets/delete_popup.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class AttributeTileCard extends StatefulWidget {
  final bool costing;
  final ProductList? productCard;
  final VoidCallback? onTap;
  const AttributeTileCard(
      {super.key, this.productCard, this.costing = false, this.onTap});

  @override
  State<AttributeTileCard> createState() => _AttributeTileCardState();
}

class _AttributeTileCardState extends State<AttributeTileCard> {
   final List<BottomSheetModel> bottomSheetList = [
    const BottomSheetModel(
      value: "edit",
      name: "Edit Attribute",
    ),
    const BottomSheetModel(
        value: "delete", name: "Delete Attribute", isAlert: true),
  ];
  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 12,
                  ),
                 SvgPicture .string(CommonSvgFiles().attributeSvgImg,),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width:isTab(context)?w1-140: w1 - 115,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(  width: w1 / 1.9,
                                  child: Text(
                                    widget.productCard?.name.toTitleCase() ??
                                        "",maxLines: 1,overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.urbanist(
                                      color: const Color(0xFF1C1B1F),
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: w1 / 1.9,
                                  child: Text(
                                    widget.productCard?.description
                                            .toString()
                                            .toTitleCase() ??
                                        "",
                                    style: GoogleFonts.urbanist(
                                      color: const Color(0xFF8390A1),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            authentication.authenticatedUser.userType ==
                                    "store"
                                ? PopupMenuButton(
                                    padding: EdgeInsets.zero,
                                    surfaceTintColor: Colors.white,
                                    position: PopupMenuPosition.under,
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        height: 35,
                                        child: const Text("Add Price"),
                                        onTap: widget.onTap,
                                      )
                                    ],
                                  )
                                : authentication.authenticatedUser.userType ==
                                          "admin"
                                      ? InkWell(onTap: ()
                                      {
                                        
 showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return Container(
                                                      height: 170.h,
                                                      width: double.infinity,
                                                      decoration: const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10))),
                                                      child:
                                                          SingleChildScrollView(
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
                                                                  color: ColorTheme
                                                                      .secondaryBlue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                            ),
                                                            ListView.separated(
                                                                physics:
                                                                    const AlwaysScrollableScrollPhysics(),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        16),
                                                                shrinkWrap:
                                                                    true,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      if (bottomSheetList[index]
                                                                              .value ==
                                                                          "delete") {
                                                                        DeletePopup().deleteAlert(context, "Are you sure you want to delete\nAttribute",
                                                                        () {
                                                                          Navigator.pop(context);
                                                                          ProductDataSource()
                                                                              .deleteAttribute(id: widget.productCard?.id ?? 0)
                                                                              .then((value) {
                                                                            if (value.data1 ==
                                                                                true) {
                                                                              context.read<ProductListBloc>().add(GetAllAttributes());
                                                                              Fluttertoast.showToast(msg: value.data2);
                                                                              Navigator.pop(context);
                                                                            } else {
                                                                              Fluttertoast.showToast(msg: value.data2);
                                                                            }
                                                                          });
                                                                        },);

                                                                      }
                                                                      if (bottomSheetList[index]
                                                                              .value ==
                                                                          "edit") {
                                                                            Navigator.pop(context);
                                                                        PersistentNavBarNavigator.pushNewScreen(
                                                                            context,
                                                                            screen:
                                                                                EditAttribute(
                                                                              productList: widget.productCard,
                                                                            ));
                                                                      }
                                                                    },
                                                                    child: Padding(
                                                                        padding: const EdgeInsets.all(10.0),
                                                                        child: Text(
                                                                          bottomSheetList[index].name ??
                                                                              "",
                                                                          style:
                                                                              GoogleFonts.urbanist(
                                                                            color: bottomSheetList[index].isAlert == true
                                                                                ? ColorTheme.red
                                                                                : ColorTheme.text,
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        )),
                                                                  );
                                                                },
                                                                separatorBuilder:
                                                                    (context,
                                                                            index) =>
                                                                        Divider(
                                                                          height:
                                                                              8,
                                                                          color:
                                                                              ColorTheme.backGround,
                                                                        ),
                                                                itemCount:
                                                                    bottomSheetList
                                                                        .length),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );

                                      },child: Padding(padding:  EdgeInsets.only(right: 10,top: 2,left: 10,bottom: 10),child: Icon(Icons.more_vert_rounded),),)
                                      : const SizedBox()
                          ],
                        ),
                      ),
                      widget.costing
                          ? SizedBox(
                              width: w1 - 130,
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Container(
                                      alignment: Alignment.bottomRight,
                                      // width: w1 / 1.6,
                                      child: Text(
                                        "${widget.productCard?.price.toString()} SAR",
                                        style: GoogleFonts.urbanist(
                                          color: const Color(0xFF1C1B1F),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )),
                                ],
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
