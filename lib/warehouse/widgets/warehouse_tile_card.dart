import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/products/widgets/products_grid_card.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';

class WarehouseTileCard extends StatelessWidget {
  final String? imagePro;
  final String? name;
  final String? email;
  final String? city;
  final String? address;
  final VoidCallback? onTap;
  const WarehouseTileCard({super.key, this.imagePro, this.onTap,this.name, this.email, this.address, this.city});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 16),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ),
                      child: SvgPicture.string(
                        CommonSvgFiles().warehouseSvgNewTile,
                        height: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width:  widthDouble(context,1.7),
                          child: Text(
                            name.toString().toTitleCase(),maxLines: 2,overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.urbanist(height:1.1,
                             color: const Color(0xFF1C1B1F),
                              fontSize:16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                       const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.string(CommonSvgFiles().locationSvg),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                 width:  widthDouble(context,1.7),
                                  child: Text(
                                    "${address.toString().toTitleCase()},",
                                    style: GoogleFonts.urbanist(
                                      color: const Color(0xFF8390A1),
                                      fontSize:15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                 SizedBox(
                             width:  widthDouble(context,1.7),
                              child: Text(
                                "${city.toString().toTitleCase()}, Saudi Arabia",
                                style: GoogleFonts.urbanist(
                                  color: const Color(0xFF8390A1),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                              ],
                            ),
                           
                          ],
                        )
                      ],
                    )
                  ],
                ),
            // SvgPicture.string(CommonSvgFiles().moreSvg)
          ],
        ),
      ),
    );
  }
}
