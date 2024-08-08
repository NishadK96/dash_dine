
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';

class NoDataPage extends StatelessWidget {
  const NoDataPage({super.key,required this.name,required this.onTap,required this.isButton});
final String name;
final VoidCallback onTap;
final bool isButton;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            height: 10,
          ),
          const SizedBox(height: 10,),
        isButton==true?  SizedBox(width: 300.w,
            child: CommonButton(
              title: name,
              onTap: onTap
            ),
          ):const SizedBox(),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
