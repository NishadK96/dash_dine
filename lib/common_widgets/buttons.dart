import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final bool? isLoading;
  
  final bool cancel;
  const CommonButton({super.key, this.onTap, this.title, this.isLoading, this.cancel=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(overlayColor: MaterialStateProperty.all(Colors.white54),focusColor: Colors.white,hoverColor: Colors.white,splashColor: Colors.white,
      onTap: onTap,
      child: Container(
        // width: 382.w,
        height: 56.h,
        decoration:
        cancel?BoxDecoration(color: Colors.white,border: Border.all(color:const Color(0xFF1E232C) ),borderRadius: BorderRadius.circular(8)):
         ShapeDecoration(
          color: const Color(0xFF1E232C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        alignment: Alignment.center,
        child: isLoading == true
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Colors.white,
                ))
            : Text(
                title ?? "",
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  color:cancel?Colors.black: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
      ),
    );
  }
}
