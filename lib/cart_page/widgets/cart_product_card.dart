import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/variants/model/order_lines.dart';

class CartPageProductCard extends StatelessWidget {
  const CartPageProductCard({super.key,this.fromHistory=false, required this.orderLinesDetails,required this.onAdd,required this.onRemove});
  final OrderLines? orderLinesDetails;
  final VoidCallback onAdd;
  final bool? fromHistory;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    // var h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          width: w,
          // height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE8ECF4)),
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF7F8F9)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  height: 70.h,
                  width: 70.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(orderLinesDetails?.image ?? ""),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderLinesDetails?.variantName ?? "",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "AED ${orderLinesDetails?.sellingPrice}",
                      style: GoogleFonts.poppins(
                        color: ColorTheme.secondary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: w / 2.3,
                      child: Text(
                        "",
                        style: GoogleFonts.poppins(
                          color: const Color(0xff8391A1),
                          fontSize: w / 30,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                fromHistory==false? Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(onTap: onRemove,
                      child: Container(
                        height: 30.h,
                        width: 30.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(100)),
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                          child: Center(
                            child: Icon(
                              Icons.delete_outline,
                              color: ColorTheme.text,
                              size: 18,
                            )
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(onTap: onAdd,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 5),
                        child: Container(
                          padding: EdgeInsets.only(
                            bottom: 0.5, // Space between underline and text
                          ),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                color: Colors.black,
                                width: 1.0, // Underline thickness
                              ))
                          ),
                          child:  Text("Update Qty",style: GoogleFonts.urbanist(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          )),
                        )
                      ),
                    ),
                  ],
                ):Column(
                  children: [
                    InkWell(onTap: onAdd,
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff1E232C)),
                            shape: BoxShape.circle),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xff1E232C),
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(onTap: onRemove,
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff1E232C)),
                            shape: BoxShape.circle),
                        child: const Icon(
                          Icons.remove,
                          color: Color(0xff1E232C),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top:isTab(context)?15: 8,
          left:isTab(context)?12: 8,
          child: CircleAvatar(
            backgroundColor: const Color(0xFF8391A1),
            radius: 11.5,
            child: Text(
            orderLinesDetails?.quantity>999? "999+": orderLinesDetails?.quantity.toString()??"",
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontSize: orderLinesDetails?.quantity>999? 10.sp: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
