
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';

class NoSearchData extends StatelessWidget {
  const NoSearchData({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50,),
          SvgPicture.string(CommonSvgFiles().emptyCommonSvg),
          const SizedBox(
            height: 10,
          ),
          Text(
            'No data found here!',
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
