import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/stock_adjustments/model/stock_adjust_admin_model.dart';
import 'package:pos_app/stores/data/store_data_soure.dart';
import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';

class StockAcceptancePopUpByAdmin extends StatelessWidget {
  final ReceiveStockModel receiveStockModel;
  const StockAcceptancePopUpByAdmin({super.key, required this.receiveStockModel});

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Container(height: h/2.4,
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
            Center(
                child: Container(
                  width: 35,
                  height: 7,
                  decoration: BoxDecoration(
                      color: ColorTheme.secondaryBlue,
                      borderRadius: BorderRadius.circular(5)),
                )),
            const SizedBox(
              height: 10,
            ),
             Text(
              'Stock Acceptance',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 2,
              color: ColorTheme.backGround,
              width: widthDouble(context, 1),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              // width: w1 - 140,
              child: Text(
                "Allocated By ${receiveStockModel.allocatedBy}",
                style: GoogleFonts.urbanist(
                  color: const Color(0xFF1C1B1F),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 1,
              color: ColorTheme.backGround,
              width: widthDouble(context, 1),
            ),
            const SizedBox(
              height: 15,
            ),
             Text(
               "Current Stock 0",
              style: GoogleFonts.urbanist(
                color: Color(0xFF1C1B1F),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 1,
              color: ColorTheme.backGround,
              width: widthDouble(context, 1),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: 187,
              height: 46,
              decoration: ShapeDecoration(
                color: const Color(0xFFE8ECF4),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFE8ECF4)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child:  Text(
                'Allocated Quantity: ${receiveStockModel.recievingQty}',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF1C1B1F),
                  fontSize: 16,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(

                    child: CommonButton(onTap: (){
                      Navigator.pop(context);
                    },
                      cancel: true,
                      title: "cancel",
                    ),
                  ),
                  const SizedBox(width: 6,),
                  Expanded(
                    child: CommonButton(
                      onTap: (){
                        StoreDataSource()
                            .receiveStockByInventory(
                            inventoryId: authentication.authenticatedUser.businessData?.businessId??0,
                            variantName:
                            receiveStockModel.variantData?.name ?? "",
                            receivingId: receiveStockModel.id ?? 0)
                            .then((value) {
                          if (value.data1) {
                            Fluttertoast.showToast(msg: value.data2);
                            context.read<ManageStoreBloc>().add(GetListReceivingStockInventory());
                          } else {
                            Fluttertoast.showToast(msg: value.data2);
                          }
                          Navigator.pop(context);
                        });
                      },
                      title: "Confirm",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
