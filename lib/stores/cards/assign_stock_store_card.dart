import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';

class AssignStockInStoreCard extends StatelessWidget {
  final String? storeName;
  final int? stockCount;
  final int? value;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  const AssignStockInStoreCard(
      {super.key,
      this.storeName,
      this.stockCount,
      this.value,
      this.onIncrease,
      this.onDecrease});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                storeName ?? "",
                style: GoogleFonts.urbanist(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                stockCount==null?'Current stock is 0': 'Current stock is $stockCount',
                style: GoogleFonts.urbanist(
                  color: const Color(0xFF8390A1),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          Row(
            children: [
              InkWell(
                  onTap: onDecrease,
                  child: SvgPicture.string(CommonSvgFiles().stockAddSvg)),
              const SizedBox(
                width: 4,
              ),
              Container(width: 59.w,height: 38.h,
                  // padding: const EdgeInsets.all(9),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Colors.black.withOpacity(0.15000000596046448),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    value.toString(),
                    style: GoogleFonts.urbanist(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  )),
              const SizedBox(
                width: 4,
              ),
              InkWell(
                  onTap: onIncrease,
                  child: SvgPicture.string(CommonSvgFiles().stockMinusSvg))
            ],
          )
        ],
      ),
    );
  }
}
