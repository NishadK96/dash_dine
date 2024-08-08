import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/products/widgets/attribute_tile_card.dart';
import 'package:pos_app/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Profile Details")),
      body: SizedBox(width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
          children: [SizedBox(height: 50.h,),
            CircleAvatar(radius: 70.w,backgroundColor: Colors.black12,),
            SizedBox(height: 20,),
            Text(
              "${authentication.authenticatedUser.lastName?.toTitleCase()}",
              style: GoogleFonts.urbanist(
                color: ColorTheme.text,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5,),
            Text(
              "${authentication.authenticatedUser.email?.toTitleCase()}",
              style: GoogleFonts.urbanist(
                color: ColorTheme.text,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5,),
            Text(
              "${authentication.authenticatedUser.contactNumber?.toTitleCase()}",
              style: GoogleFonts.urbanist(
                color: ColorTheme.text,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
