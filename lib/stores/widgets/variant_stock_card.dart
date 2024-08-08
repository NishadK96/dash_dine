import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/stores/data/store_data_soure.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/variants/model/variant_model.dart';
import 'package:pos_app/variants/variant_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VariantStockCard extends StatefulWidget {
  final VariantsListModel? variantData;

  final StockAllocateModel? stockData;

  const VariantStockCard({super.key, this.stockData, this.variantData});

  @override
  State<VariantStockCard> createState() => _VariantStockCardState();
}

class _VariantStockCardState extends State<VariantStockCard> {
  TextEditingController quantityController = TextEditingController();
  StockAllocateModel? stockDataNew;
  bool isAdd = false;
  bool isReduce = false;
  @override
  void initState() {
    context.read<VariantBloc>().add(GetAllVariantsByInventoryForStockAllocate(
        variantId: widget.variantData?.id, wareHouseId: authentication.authenticatedUser.businessData?.businessId));
    // StoreDataSource()
    //     .readVariantForStockAllocate(variantId: 1, wareHouseId: 1)
    //     .then((value) {
    //   stockDataNew = value.data2;
    //   // print("stockkk day ${stockData!.storeStockList?[0].storeName}");
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                          image: NetworkImage(widget.variantData?.image ?? ""),
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
                        child: Row(
                          children: [
                            Text(
                              widget.variantData?.name ?? "",
                              style: GoogleFonts.urbanist(
                                color: const Color(0xFF1C1B1F),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: w1 / 1.6,
                        child: Text(
                          widget.variantData?.description ?? "",
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
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<VariantBloc, VariantState>(
                builder: (context, state) {
                  if (state is VariantsListForStockAllocateSuccess) {
                      return Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Current stock :',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w300),
                        ),
                        TextSpan(
                          text: ' ',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: state.variantsList.warehouseStockData==null? "0":state.variantsList.warehouseStockData.toString()??"",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                  }
                  return Skeletonizer(
        enabled: true,
        enableSwitchAnimation: true,

                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Current stock:',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w300),
                          ),
                          TextSpan(
                            text: ' ',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: "",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) =>
                          StatefulBuilder(builder: (context, setState1) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              surfaceTintColor: Colors.white,
                              content: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                height: 339.h,width: 284.w,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFE8ECF4),
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Update Stock',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              size: 18,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Column(
                                        children: [
                                          InkWell( onTap: () {
                                            isAdd = true;
                                            isReduce = false;
                                            setState1(() {});
                                          },
                                            child: Row(
                                              children: [
                                                SvgPicture.string(isAdd
                                                    ? CommonSvgFiles()
                                                        .activeRadioButton
                                                    : CommonSvgFiles()
                                                        .inactiveRadioButton),SizedBox(width: 10,),
                                                 Text(
                                                  'Add Stock',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(onTap: () {
                                            isReduce = true;
                                            isAdd = false;
                                            setState1(() {});
                                          },
                                            child: Row(
                                              children: [
                                                SvgPicture.string(isReduce
                                                    ? CommonSvgFiles()
                                                        .activeRadioButton
                                                    : CommonSvgFiles()
                                                        .inactiveRadioButton),SizedBox(width: 10,),
                                                 Text(
                                                  'Reduce Stock',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          CurvedTextField(textType: TextInputType.number,
                                            controller: quantityController,
                                            title: "Enter Stock",
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          CommonButton(
                                            title: "Update Quantity",
                                            onTap: () {
                                              StoreDataSource()
                                                  .allocateStockToWareHouse(
                                                      add: isAdd,
                                                      variantId: widget.variantData?.id??0,
                                                      wareHouseId: authentication.authenticatedUser.businessData?.businessId??0,
                                                      quantity: int.tryParse(
                                                              quantityController
                                                                  .text) ??
                                                          0)
                                                  .then((value) {
                                                if (value.data1) {
                                                  Fluttertoast.showToast(msg: "Stock Updated!");
                                                 context.read<VariantBloc>().add(GetAllVariantsByInventoryForStockAllocate( variantId: widget.variantData?.id??0,
                                                   wareHouseId: authentication.authenticatedUser.businessData?.businessId??0,));
                                                }else
                                                  {
                                                    Fluttertoast.showToast(msg: value.data2);
                                                  }
                                                quantityController.clear();
                                                Navigator.pop(context);
                                              });

                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }));
                },
                child: Row(
                  children: [
                    SvgPicture.string(CommonSvgFiles().iconPlusSvg),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Update Stock',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
