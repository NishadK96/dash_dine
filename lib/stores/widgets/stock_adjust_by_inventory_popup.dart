import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/variants/data/data_source.dart';
import 'package:pos_app/variants/model/stock_adjustment_model.dart';

class StockAdjustByInventoryPopup extends StatefulWidget {
  final StockAdjustmentModel stockAdjustData;
  const StockAdjustByInventoryPopup({super.key, required this.stockAdjustData});

  @override
  State<StockAdjustByInventoryPopup> createState() =>
      _StockAdjustByInventoryPopupState();
}

class _StockAdjustByInventoryPopupState
    extends State<StockAdjustByInventoryPopup> {
  final TextEditingController stockController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  bool isAdd = false;
  bool isReduce = false;
  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;

    return Container(   height: heightDouble(context, 1.9),
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              width: 50.w,
              height: 7.h,
              decoration: BoxDecoration(
                  color: ColorTheme.secondaryBlue,
                  borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(
              height: 10,
            ),
             Text(
              'Stock Adjust Request',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
                // width: w1 - 140,
                child: Text(
                  'You can allocate a maximum of the total.',
                  style: GoogleFonts.urbanist(
                    color: const Color(0xFF8390A1),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(onTap: () {
                  isAdd = true;
                  isReduce = false;
                  setState(() {});
                },
                  child: Row(
                    children: [
                      SvgPicture.string(isAdd
                          ? CommonSvgFiles().activeRadioButton
                          : CommonSvgFiles().inactiveRadioButton),
                       Text(
                        'Add Stock',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                InkWell(onTap: () {
                  isReduce = true;
                  isAdd = false;
                  setState(() {});
                },
                  child: Row(
                    children: [
                      SvgPicture.string(isReduce
                          ? CommonSvgFiles().activeRadioButton
                          : CommonSvgFiles().inactiveRadioButton),
                       Text(
                        'Reduce Stock',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     CurvedTextField(textType: TextInputType.number,
                      controller: stockController,
                      title: "Enter stock"),
                    const SizedBox(
                      height: 15,
                    ),
                     CurvedTextField(
                      controller: reasonController,
                      title: "Enter reason"),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'You can allocate a maximum of the total.',
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF8390A1),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    CommonButton(
                      onTap: () {
                        VariantDataSource()
                            .createStockAdjustment(
                                adjustmentType: isAdd==false ? "Decrease" : "Increase",
                                inventoryStockId: widget.stockAdjustData
                                        .inventoryStockData?.id ??
                                    1,
                                quantity:
                                    int.tryParse(stockController.text) ?? 0,
                                reason: reasonController.text)
                            .then((value) {
                          Fluttertoast.showToast(msg: value.data2);
                          Navigator.pop(context);
                        });
                      },
                      title: "Send Request",
                    )
                  ],
                ))
          ],
        ));
  }
}
