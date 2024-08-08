
import 'package:flutter/material.dart';
import 'package:pos_app/utils/device_info.dart';
bool isTab(BuildContext context){
  var shortestSide=MediaQuery.of(context).size.width;
  return shortestSide>=600;
}
Widget heightGap(BuildContext context, double height) {
  return SizedBox(
    height: DeviceInfo(context).height! / height,
  );
}
Widget widthGap(BuildContext context, double width) {
  return SizedBox(
    width: DeviceInfo(context).height! / width,
  );
}
double widthDouble(BuildContext context, double width) {
  return DeviceInfo(context).width! / width;
  
}
double heightDouble(BuildContext context, double width) {
  return DeviceInfo(context).height! / width;
  
}
