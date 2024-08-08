import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/auth/bloc/bloc/login_bloc.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/screens/dashboard.dart';
import 'package:pos_app/utils/size_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void reload() {
    setState(() {});
  }

//snack bar to display as well as execute an action on clicking snackbar
//   final snackBar = SnackBar(

//   content: const Text('Yay! A SnackBar!'),

//   duration: Duration(milliseconds: 100),
//   action: SnackBarAction(

//     label: 'Undo',
//     onPressed: () {
//      PersistentNavBarNavigator.pushNewScreen(context,
//                                 withNavBar: false, screen:  DashBoard());
//     },
//   ),
// );
  bool changeView = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          isLoading = false;
          setState(() {});
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoard(),
              ),
              (route) => false);
        } else if (state is SignInFailed) {
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(msg: state.message ?? "");    
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            // alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            padding:  EdgeInsets.symmetric(horizontal:isTab(context)?35: 25),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 77.h,),
                SizedBox(width: double.infinity,
                  child: Text(
                    'Welcome back!\nGlad to see you, Again!',
                    style: GoogleFonts.roboto(
                      color: const Color(0xFF1E232C),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                heightGap(context, 20),
                CurvedTextField(
                  controller: emailController,
                  title: "Enter Login ID",
                ),
                heightGap(context, 50),
                CurvedTextField(
                  controller: passwordController,
                  isVisible: changeView,
                  onView: () {
                    changeView = !changeView;
                    setState(() {});
                  },
                  isPassword: true,
                  title: "Enter your password",
                ),
                heightGap(context, 50),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: Padding(
                //     padding: const EdgeInsets.only(right: 16.0),
                //     child: Text(
                //       'Change Password?',
                //       textAlign: TextAlign.right,
                //       style: GoogleFonts.urbanist(
                //         color: const Color(0xFF6A707C),
                //         fontSize: 14,
                //         fontWeight: FontWeight.w600,
                //         height: 0,
                //       ),
                //     ),
                //   ),
                // ),
                heightGap(context, 30),
                CommonButton(
                  isLoading: isLoading,
                  title: "Login",
                  onTap: ()  {
                    isLoading = true;
                    setState(() {});
                    // var data = await http.get(Uri.parse(
                    //     "http://api-posorder.dhoomaworksbench.site/media/invoice/order-invoice_iJA3AId.pdf"));
                    // await Printing.layoutPdf(onLayout: (_) => data.bodyBytes);
                    context.read<LoginBloc>().add(SignInEvent(
                        email: emailController.text,
                        password: passwordController.text));
                  },
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      'Terms and Condition and Privacy Policy',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF6A707C),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 180,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
