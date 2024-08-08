import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/utils/size_config.dart';

class CommonAppBar extends StatelessWidget {
  final String? title;
  final Widget? popUp;
  const CommonAppBar({super.key, this.title,this.popUp});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffF5F5F5),
        automaticallyImplyLeading: false,
        surfaceTintColor: const Color(0xFFB4E7F7),
        elevation: 0,
        centerTitle: true,actions: [SizedBox(child: popUp),SizedBox(width: 10,)],
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back)),
        // backgroundColor: const Color(0xFFfdebe2),
        title: Text(
          title??"",
          style: GoogleFonts.urbanist(
            color: const Color(0xFF1E232C),
            fontSize:isTab(context)?24: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
  }
}