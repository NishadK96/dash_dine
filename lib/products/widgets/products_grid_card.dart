import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/products/model/model.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class ProductsGridCard extends StatefulWidget {
  final bool costing;
  final ProductList? productCard;
  final VoidCallback? onTap;
  const ProductsGridCard(
      {super.key, this.productCard, this.costing = false, this.onTap});

  @override
  State<ProductsGridCard> createState() => _ProductsGridCardState();
}

class _ProductsGridCardState extends State<ProductsGridCard> {
  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade100,
                        blurRadius: 1.0,
                      ),
                    ],
                    image: DecorationImage(
                        image: NetworkImage(
                          widget.productCard?.image,
                        ),
                        fit: BoxFit.cover),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))),
                // width: 100,
                // color: Colors.grey,
                // child:
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  // width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                   
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8))),
                  child: Column(
                    children: [
                      Text(
                        widget.productCard?.name ?? "",
                        style: GoogleFonts.urbanist(
                          color: const Color(0xFF1C1B1F),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                       Text(
                        "${widget.productCard?.price.toString() ?? ""} SAR",
                        style: GoogleFonts.urbanist(
                          color: const Color(0xFF1C1B1F),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                )),
                
          ],
        ),
      ),
    );
  }
}
