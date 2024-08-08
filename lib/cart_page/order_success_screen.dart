import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/invoice/invoice_details.dart';
import 'package:pos_app/screens/dashboard.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key,required this.orderId});
final int orderId;
  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer(); //
  Future<void> _playSuccessSound() async {
    try {
      // Play audio from assets
      await _audioPlayer.play(AssetSource('success.wav'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 800)).then(
      (value) {
        _playSuccessSound();
      },
    );
    Future.delayed(Duration(milliseconds: 3500)).then(
          (value) {
       PersistentNavBarNavigator.pushNewScreen(context, screen: InvoiceDetails(id: widget.orderId,),pageTransitionAnimation: PageTransitionAnimation.slideUp,);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150.w,
                  width: 150.w,
                  child: Lottie.asset("assets/succes.json", repeat: false),
                ),
                Text(
                  "Order Created",
                  style: GoogleFonts.urbanist(
                    color: ColorTheme.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 26.sp,
                    height: 0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "The order has been created, and the invoice\nhas been sent to the printer.",
                  style: GoogleFonts.urbanist(
                    color: ColorTheme.secondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                    height: 0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 40,
                ),
                // CommonButton(
                //   onTap: () {
                //     Navigator.pushAndRemoveUntil(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => DashBoard(),
                //         ),
                //         (route) => false);
                //   },
                //   title: "Back to Home",
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
