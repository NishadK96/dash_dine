
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/auth/data/user_data_source.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/order_app_bar.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/utils/colors.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key,required this.userId});
 final String userId;
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isConfirm=false;
  bool isNew=false;
  TextEditingController passController=TextEditingController();
  TextEditingController passConfirmController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: ColorTheme.backGround,appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CommonAppBar(title: "")),body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(width: double.infinity,
                child: Text(
                  'Change Password',
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF1E232C),
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(width: double.infinity,
                child: Text(
                  'Set a new password for the manager. Make it unique and different from the previous password.',
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF1E232C),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              CurvedTextField(title: "New Password",controller: passController,isPassword: true,isVisible: isNew,
                  onView: () {
                    isNew = !isNew;
                    setState(() {});
                  }),
              const SizedBox(height: 10,),
              CurvedTextField(title: "Confirm Password",controller: passConfirmController,isPassword: true,isVisible: isConfirm,
                onView: () {
                  isConfirm = !isConfirm;
                  setState(() {});
                },),
              const SizedBox(height: 5,),
              SizedBox(width: double.infinity,
                child: Text(
                  ' Both password must match.',
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF1E232C),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 35,),
              CommonButton(title: "Change Password",onTap: () {
                if(passConfirmController.text.trim()==passController.text.trim()) {
                  UserDataSource().changePassword(
                      password: passConfirmController.text, id: widget.userId).then((
                      value) {
                    if (value.data1 == true) {
                      Fluttertoast.showToast(msg: value.data2);
                      Navigator.pop(context);
                    }else
                      {
                        Fluttertoast.showToast(msg: value.data2);
                      }
                  },);
                }else
                  {
                    Fluttertoast.showToast(msg: "Passwords do not match");
                  }
              },)
                ],),
          ),
        ),);
  }
}
