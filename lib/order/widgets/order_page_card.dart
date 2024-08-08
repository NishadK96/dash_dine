import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/variants/model/variant_model.dart';

class OrderPageProductCard extends StatelessWidget {
  const OrderPageProductCard(
      {super.key,
      required this.variantList,
      required this.onTap,
      required this.isAdded,
      required this.isConfirmed});
  final VariantsListModel? variantList;
  final VoidCallback onTap;
  final bool isAdded;
  final bool isConfirmed;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    // var h = MediaQuery.of(context).size.height;
    return Container(
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
              height: 60.w,
              width: 60.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                        variantList?.image.toString() ?? "",
                      ),
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
                  variantList?.name.toString() ?? "",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                 variantList?.costingType=="dynamic price"? "Dynamic price":"AED ${variantList?.priceData?.sellingPrice??0}",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width:isTab(context)?w/1.3: w / 2.1,
                      child: Text(
                        "",
                        style: GoogleFonts.poppins(
                          color: const Color(0xff8391A1),
                          fontSize: w / 30,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onTap,
                      child: Container(height: 34.h,width: 79.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(100)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 0, bottom: 0),
                          child: isAdded
                              ? const Icon(
                                  Icons.shopping_cart_outlined,
                                   size: 18,
                                )
                              :isConfirmed? const Icon(Icons.delete):Center(
                                child: Text(
                                    "Add",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
