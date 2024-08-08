import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/stores/data/store_data_soure.dart';
import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/stores/widgets/stock_acceptance_bottomsheet.dart';
import 'package:pos_app/stores/widgets/stock_manage_card.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';

import '../../stock_adjustments/widgets/stock_accept_by_admin_popup.dart';

class StockManageByInventory extends StatefulWidget {
  const StockManageByInventory({super.key});

  @override
  State<StockManageByInventory> createState() => _StockManageByInventoryState();
}

class _StockManageByInventoryState extends State<StockManageByInventory> {
  List<ReceiveStockModel> receiveStock = [];

  @override
  void initState() {
    context.read<ManageStoreBloc>().add(GetListReceivingStockInventory());
    super.initState();
  }
bool isLoading=true;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<ManageStoreBloc,ManageStoreState>(listener: (context, state) {
        if(state is ListReceivingStockInventorySuccess)
          {
            receiveStock=  state.variantList;
            isLoading=false;
            setState(() {

            });
          }if(state is ListReceivingStockInventoryFailed)
            {
              isLoading=false;
              setState(() {

              });
            }
      },)
    ],
      child: Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: CommonAppBar(title: "Manage Stock")),
        body:
        isLoading? LoadingPage():receiveStock.isEmpty  && isLoading==false
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.string(CommonSvgFiles().emptyCommonSvg),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'No data found here!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(padding: EdgeInsets.only(bottom: 40),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 8,
                        ),
                        itemCount: receiveStock.length,
                        itemBuilder: (context, index) {
                          return StockManageCard(
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return StockAcceptancePopUpByAdmin(
                                        receiveStockModel: receiveStock[index],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            productCard: receiveStock[index],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
