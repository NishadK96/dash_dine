import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/products/model/model.dart';

class ItemCard extends StatelessWidget {
  final ProductList productData;
 final VoidCallback productTap;
 final bool isSelected;
  const ItemCard({super.key, required this.productData,required this.productTap,required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: productTap,
      child: Container(
        width: 110.w,
        height: 110.w,
        padding: const EdgeInsets.all(5),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side:  BorderSide(width:1.50, color:isSelected? Colors.black:const Color(0xFFE8ECF4)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 3,
            ),
            Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(productData.image ??
                            "https://www.hiphopshakespeare.com/wp-content/uploads/2013/11/dummy-image-portrait.jpg"),
                        fit: BoxFit.fill))),
            const SizedBox(
              height: 3,
            ),
            Text(
              productData.name,textAlign: TextAlign.center,
              style: GoogleFonts.poppins(height: 1.1,
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
