import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/variants/model/stock_adjustment_model.dart';

class VariantsTileCardStockAdjustment extends StatelessWidget {
  final StockAdjustmentModel? variantCard;
  final VoidCallback? onAssignStock;
  const VariantsTileCardStockAdjustment({
    super.key, this.variantCard, this.onAssignStock
    });

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SizedBox(width: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(variantCard?.image ?? ""),
                            fit: BoxFit.fill),
                        color: const Color(0x33D9D9D9),
                        shape: BoxShape.circle,
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
                          width: w1 /1.45,
                          child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    variantCard?.name ?? "",
                                    style: GoogleFonts.urbanist(
                                      color: const Color(0xFF1C1B1F),
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                   Text(
                                     variantCard?.description ?? "",
                                     style: GoogleFonts.urbanist(
                                       color: const Color(0xFF8390A1),
                                       fontSize: 14.sp,
                                       fontWeight: FontWeight.w500,
                                     ),
                                   ),
                                ],
                              ),Spacer(),
                 InkWell(
                                  onTap: onAssignStock,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.string(CommonSvgFiles().moreSvg),
                                  )),
                      
                            ],
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
