import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/products/data/data_source.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';

class AddDynamicProductCosting extends StatefulWidget {
  final int prodId;
  final dynamic price;
  final VoidCallback onAdd;
   final Function(String)? onChanged;
    final TextEditingController priceController;
  const AddDynamicProductCosting(
      {super.key, required this.prodId, required this.price,required this.onAdd,required this.onChanged,required this.priceController});

  @override
  State<AddDynamicProductCosting> createState() => _AddDynamicProductCostingState();
}

class _AddDynamicProductCostingState extends State<AddDynamicProductCosting> {

  bool isAdd = false;
  bool isReduce = false;
  bool isButtonLoading=false;
  dynamic? price;
    @override
  void initState()
  {
price=widget.price;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;

    return Container(
      height: heightDouble(context, 2.3),
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Column(
          children: [
             const SizedBox(
              height: 10,
            ),
            Container(width: 35,height: 7,decoration: BoxDecoration(color: ColorTheme.secondaryBlue, borderRadius: BorderRadius.circular(5)),),
            const SizedBox(
              height: 15,
            ),
             Text(
              'Add Price',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 20.sp, 
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'You can add price for per product',
              style: GoogleFonts.urbanist(
                color: const Color(0xFF8390A1),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            RichText(textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: widget.price.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 60,
                        fontWeight: FontWeight.w600,
                      )),
                   TextSpan(
                      text: ' SAR',
                      style: TextStyle(
                          color: const Color(0xFF8390A1),
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                )),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CurvedTextField(textType: TextInputType.number,onChanged:widget.onChanged,
                      title: "Enter Updated Price",
                      controller: widget.priceController,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    CommonButton( isLoading: isButtonLoading,
                    onTap: widget.onAdd,
                    title: "Add Price",
                    )
                  ],
                ))
          ],
        ));
  }
}
