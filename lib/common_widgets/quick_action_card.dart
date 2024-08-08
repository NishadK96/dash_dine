import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/utils/size_config.dart';

class QuickActionCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String svgIcon;
  final String title;
  const QuickActionCard(
      {super.key, required this.svgIcon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Column(
        children: [
          Container(width:isTab(context)?90.w: 70.w,height:isTab(context)?90.w: 70.w,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color(0x33D9D9D9),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: SvgPicture.string(svgIcon),
            ),

          ),
          const SizedBox(height: 5,),
          Text(
            title,
            style: GoogleFonts.urbanist(
              color: Colors.black,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 0,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
