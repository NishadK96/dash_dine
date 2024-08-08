import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';

class StockManageCard extends StatelessWidget {
  final ReceiveStockModel? productCard;
  final VoidCallback? onTap;
  const StockManageCard({super.key, this.productCard, this.onTap});

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadows: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 2,
              offset: Offset(1, 0),
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        color: Color(0x33D9D9D9),
                        shape: BoxShape.circle,
                      ),child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.string(CommonSvgFiles().bell),
                      ),

                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: w1 - 135,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${productCard?.allocatedBy} ",
                                  style: GoogleFonts.urbanist(
                                    color: const Color(0xFF1C1B1F),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: "requested a stock update",
                                  style: GoogleFonts.urbanist(
                                    color: const Color(0xFF1C1B1F),
                                    fontSize: 16.sp,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: w1 / 1.6,
                          child: Text(
                            "item : ${productCard?.variantData?.name}",
                            style: GoogleFonts.urbanist(
                              color: const Color(0xFF8390A1),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
