import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/stock_adjustments/model/stock_adjust_admin_model.dart';

class StockAcceptCard extends StatelessWidget {
  final StockAdjustmentListAdminModel? productCard;
  final VoidCallback? onTap;
  const StockAcceptCard({super.key, this.productCard, this.onTap});

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
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(productCard?.variantData?.image ?? ""),
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
                            width: w1 - 140,
                          child: Text(
                            "${productCard?.inventoryName} allocated update stock" ,
                            style: GoogleFonts.urbanist(
                              color: const Color(0xFF1C1B1F),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: w1 / 1.6,
                          child: Text(
                            "item : ${productCard?.variantData?.name}",
                            style: GoogleFonts.urbanist(
                              color: const Color(0xFF8390A1),
                              fontSize: 14,
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
