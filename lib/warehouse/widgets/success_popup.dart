import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audioplayers package

class SuccessPopup {
  final AudioPlayer _audioPlayer = AudioPlayer(); // Create an AudioPlayer instance

  Future<dynamic> successAlert(BuildContext context, String description) async {
    // Play audio when the dialog is shown

    Future.delayed(Duration(milliseconds: 800)).then((value) {
       _playSuccessSound();
    },);


    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 323.h,
                width: 285.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        height: 310.h,
                        width: 285.w,
                        child: Column(
                          children: [
                            Spacer(),
                            Container(
                              height: 310.h,
                              width: 285.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 100.h,
                                    height: 100.h,
                                    child: Lottie.asset("assets/succes.json",repeat: false),
                                  ),
                                  // SizedBox(height: 50),
                                  Text(
                                    "Success!",
                                    style: GoogleFonts.urbanist(
                                      color: Colors.black,
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      description,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.urbanist(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                    child: CommonButton(
                                      title: "OK",
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   child:
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _playSuccessSound() async {
    try {
      // Play audio from assets
      await _audioPlayer.play(AssetSource('success.wav'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }
}
