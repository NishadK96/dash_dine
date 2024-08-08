import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderPageWidgets {
  Widget addVariantSearch(BuildContext context, {required String count}) {
    var w = MediaQuery.of(context).size.width;
    // var h = MediaQuery.of(context).size.height;
    return SizedBox(
      width: w,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 5,),
              Text(
                'Add a variant',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Total $count product in this item',
                style: GoogleFonts.urbanist(
                  color: const Color(0xFF8390A1),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5,)
            ],
          ),
          const Spacer(),
          // CircleAvatar(
          //   backgroundColor: Color(0xFFF7F8F9),
          //   radius: 17,
          //   child: Icon(
          //     Icons.search_rounded,
          //     size: 18,
          //   ),
          // )
        ],
      ),
    );
  }
}