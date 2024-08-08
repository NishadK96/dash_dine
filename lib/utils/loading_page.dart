
import 'package:flutter/material.dart';
import 'package:pos_app/utils/colors.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(width:MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,color: Colors.white,child:  Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: ColorTheme.primary,),
        const SizedBox(height: 100,)
      ],
    ),);
  }
}
