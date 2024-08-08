import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/auth/change_password.dart';
import 'package:pos_app/manager/bloc/manager_bloc.dart';
import 'package:pos_app/manager/screens/edit_manager.dart';
import 'package:pos_app/manager/services/datasource.dart';
import 'package:pos_app/manager/services/model/model.dart';
import 'package:pos_app/products/widgets/products_tile_card.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/variants/screens/widgets/variant_product_card.dart';
import 'package:pos_app/warehouse/widgets/delete_popup.dart';

class ManagerTileCard extends StatefulWidget {
  final ManagerList? managerDetails;
  const ManagerTileCard({super.key, required this.managerDetails});

  @override
  State<ManagerTileCard> createState() => _ManagerTileCardState();
}

class _ManagerTileCardState extends State<ManagerTileCard> {


  @override
  Widget build(BuildContext context) {

    final List<BottomSheetModel> bottomSheetList =authentication.authenticatedUser.userType=="wmanager" && widget.managerDetails?.userType=="wmanager"?[]: [
      const BottomSheetModel(
        value: "edit",
        name: "Edit Manager",
      ),
      const BottomSheetModel(
        value: "changepass",
        name: "Change Password",
      ),
      const BottomSheetModel(
          value: "delete", name: "Delete Manager", isAlert: true),
    ];
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: 220.h,
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
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (bottomSheetList[index].value == "edit") {
                                    Navigator.pop(context);
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: EditManagerPage(
                                            managerType: widget
                                                    .managerDetails?.userType ??
                                                "",
                                            managerDetails:
                                                widget.managerDetails));
                                  }
                                  if (bottomSheetList[index].value ==
                                      "delete") {
                                    DeletePopup().deleteAlert(context, "Are you sure you want to delete\nManager",
                                    () {
                                      Navigator.pop(context);
                                      ManagerDataSource()
                                          .deleteManager(
                                          userId: widget.managerDetails?.id
                                              .toString() ??
                                              "")
                                          .then((value) {
                                        if (value.data1 == true) {
                                          Fluttertoast.showToast(
                                              msg: value.data2);
                                          Navigator.pop(context);
                                          context.read<ManagerBloc>().add(
                                              GetAllMangers(
                                                  managerType: widget
                                                      .managerDetails
                                                      ?.userType ??
                                                      ""));
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: value.data2);
                                        }
                                      });
                                    },);

                                  }
                                  if (bottomSheetList[index].value =="changepass")
                                    {
                                      Navigator.pop(context);
                                      PersistentNavBarNavigator.pushNewScreen(context, screen: ChangePassword(userId: widget.managerDetails?.id.toString()??"",));
                                    }
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      bottomSheetList[index].name ?? "",
                                      style: GoogleFonts.urbanist(
                                        color: bottomSheetList[index].isAlert ==
                                                true
                                            ? ColorTheme.red
                                            : ColorTheme.text,
                                        fontSize:16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                    image: DecorationImage(
                        image: NetworkImage(""), fit: BoxFit.fill),
                    color: Color(0x33D9D9D9),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Text(
                    widget.managerDetails?.firstName == ""
                        ? ""
                        : widget.managerDetails?.firstName
                                .toString()
                                .substring(0, 1)
                                .toTitleCase() ??
                            "",
                    style: GoogleFonts.urbanist(
                      color: ColorTheme.text,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: ${widget.managerDetails?.id}',
                      style: TextStyle(
                        color: const Color(0xFF1C1B1F),
                        fontSize:12.sp,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: isTab(context)?300: 240.w,
                      child: Text(
                        "${widget.managerDetails?.firstName.toString().toTitleCase()} ${widget.managerDetails?.lastName.toString().toTitleCase()}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SvgPicture.string(CommonSvgFiles().emailSvg),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width:isTab(context)?300: 240.w,
                          child: Text(
                            widget.managerDetails?.email ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.urbanist(
                              color: const Color(0xFF8390A1),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.string(CommonSvgFiles().warehouseSvg),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.managerDetails?.userType == "wmanager"
                              ? widget.managerDetails?.operationValue
                                      ?.warehouseName ??
                                  ""
                              : widget.managerDetails?.operationValue
                                      ?.inventoryName ??
                                  "",
                          style: GoogleFonts.urbanist(
                            color: const Color(0xFF8390A1),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
