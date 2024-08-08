import 'dart:async';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:pos_app/auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {
     Timer(
      const Duration(seconds: 3), // Adjust the duration as needed
      () {
        PersistentNavBarNavigator.pushNewScreen(context,
            screen: const LoginPage(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.slideUp);
            },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1E232C),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
        
        Image.asset("assets/splash.png",height: 200,),
        SizedBox(height: 200,),
        CircularProgressIndicator(color: Colors.white,)
            ],),
      ),);
  }
}