import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/utils/size_config.dart';

class DashboardCard extends StatelessWidget {
  final String? title;
  final String? count;
  final String? svgIcon;
  final Color? containerColor;
  const DashboardCard(
      {super.key, this.title, this.count, this.svgIcon, this.containerColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthDouble(context, 5),
        decoration: ShapeDecoration(
          color: containerColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? "",
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  count ?? "",
                  style: GoogleFonts.urbanist(
                    color: Colors.black,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SvgPicture.string(svgIcon ?? "")
              ],
            )
          ],
        ));
  }
}
