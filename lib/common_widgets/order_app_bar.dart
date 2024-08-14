import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/screens/dashboard.dart';

class OrderAppBar extends StatelessWidget {
  final String? title;
  final bool? toDashboard;
  final bool?  isBack;
  final VoidCallback? isBackAction;
  const OrderAppBar({super.key, this.title,this.toDashboard=false,this.isBack=false,this.isBackAction});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff1E232C),
        automaticallyImplyLeading: false,
        surfaceTintColor: const Color(0x0f1e232c),
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap:isBack==true? isBackAction:(){
            if(toDashboard==true)
              {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashBoard(),
                    ),
                        (route) => false);
              }else {
              Navigator.pop(context);
            }
          },
          child: const Icon(Icons.arrow_back,color: Color(0xFFFFFFFF),)),
        title: Text(
          title??"",
          style: GoogleFonts.urbanist(
            color: const Color(0xFFFFFFFF),
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
  }
}