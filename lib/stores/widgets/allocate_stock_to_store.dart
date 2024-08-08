import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/stores/cards/assign_stock_store_card.dart';
import 'package:pos_app/stores/data/store_data_soure.dart';
import 'package:pos_app/stores/models/allocate_stock_to_store_model.dart';
import 'package:pos_app/stores/models/store_model.dart';

class AllocateStockToStore extends StatefulWidget {
  final StockAllocateModel? stockData;

  const AllocateStockToStore({super.key, this.stockData});

  @override
  State<AllocateStockToStore> createState() => _AllocateStockToStoreState();
}

class _AllocateStockToStoreState extends State<AllocateStockToStore> {
  List<AllocateStockToStoreModel> assignStock = [];
  int stockCount = 0;
  bool isButtonLoading = false;
  @override
  void initState() {
    for (var i = 0; i < widget.stockData!.storeStockList!.length; i++) {
      assignStock.add(AllocateStockToStoreModel(
          inventoryId: widget.stockData!.storeStockList?[i].inventoryId ?? 0,
          inventoryName: "asga",
          stockCount: 0,
          variantName: widget.stockData?.name));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.stockData!.storeStockList!.isEmpty? SizedBox():Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: ShapeDecoration(
            color: const Color(0xFF8390A1),
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
            children: [
              Text(
                'Store Name',
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              Text(
                'Quantity',
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 10,),
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return AssignStockInStoreCard(
                onIncrease: () {
                  assignStock[index].stockCount =
                      assignStock[index].stockCount! + 1;
                  setState(() {});
                },
                onDecrease: () {
                  assignStock[index].stockCount =
                      assignStock[index].stockCount! - 1;
                  setState(() {});
                },
                storeName: widget.stockData?.storeStockList?[index].storeName
                        .toString() ??
                    "",
                stockCount: widget.stockData!.storeStockList?[index].stockCount,
                value: assignStock[index].stockCount!,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 5,
              );
            },
            itemCount: widget.stockData!.storeStockList?.length ?? 0),
        const SizedBox(
          height: 8,
        ),
        Text(
          'You can allocate a maximum of the total stock allotted for this product to different stores.',
          style: GoogleFonts.urbanist(
            color: const Color(0xFF8390A1),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CommonButton(isLoading: isButtonLoading,
          onTap: () {
            isButtonLoading=true;
            setState(() {

            });
            StoreDataSource().allocateStockToStore(
                stockId: widget.stockData?.stockId ?? 0, stockList: assignStock).then((value) {
                  if(value.data1==true){
                    Fluttertoast.showToast(msg: value.data2);
                    Navigator.pop(context);
                    isButtonLoading=false;

                    setState(() {

                    });
                  }else
                    {
                      isButtonLoading=false;
                      setState(() {

                      });
                      Fluttertoast.showToast(msg: value.data2);
                    }


                });
          },
          title: "Update Stock",
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
