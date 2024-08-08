
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/common_widgets/buttons.dart';

class DeletePopup
{
  Future<dynamic> deleteAlert(BuildContext context, String description,VoidCallback onDelete) async {
    return showDialog(barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content:   Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,    mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 243.h,
                width: 285.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Are You Sure!",
                      style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
                      child: Row(
                        children: [Spacer(),
                          SizedBox(width: 122.w,height: 46.h,
                            child: CommonButton(cancel: true,
                              title: "CANCEL",
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),Spacer(),
                          SizedBox(width: 122.w,height: 46.h,
                            child: CommonButton(
                              title: "CONFIRM",
                              onTap: onDelete
                            ),
                          ),Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}