import 'package:flutter/material.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/stores/data/store_data_soure.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/stores/widgets/allocate_stock_to_store.dart';
import 'package:pos_app/stores/widgets/variant_stock_card.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/variants/model/variant_model.dart';

class AssignStock extends StatefulWidget {
  final VariantsListModel? variantData;
  const AssignStock({super.key, this.variantData});

  @override
  State<AssignStock> createState() => _AssignStockState();
}

class _AssignStockState extends State<AssignStock> {
  StockAllocateModel? stockData;
  @override
  void initState() {
    StoreDataSource()
        .readVariantForStockAllocate(variantId: widget.variantData?.id??0, wareHouseId: authentication.authenticatedUser.businessData?.businessId??0)
        .then((value) {
      stockData = value.data2;
      // print("stockkk day ${stockData!.storeStockList?[0].storeName}");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Assign Stock")),
      body: stockData == null
          ?  const LoadingPage()
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    stockData != null
                        ? VariantStockCard(
                            variantData: widget.variantData,
                            stockData: stockData,
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    stockData != null
                        ? AllocateStockToStore(
                            stockData: stockData,
                          )
                        : Container()
                  ],
                ),
              ),
            ),
    );
  }
}
