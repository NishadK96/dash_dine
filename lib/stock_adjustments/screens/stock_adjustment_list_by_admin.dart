import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/manager/bloc/manager_bloc.dart';
import 'package:pos_app/stock_adjustments/data/admin_data_source.dart';
import 'package:pos_app/stock_adjustments/model/stock_adjust_admin_model.dart';
import 'package:pos_app/stock_adjustments/screens/stock_accept_admin.dart';
import 'package:pos_app/stock_adjustments/widgets/stock_accept_by_admin_popup.dart';
import 'package:pos_app/stock_adjustments/widgets/stock_accept_card.dart';
import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';

class StockAdjustmentListByAdmin extends StatefulWidget {
  const StockAdjustmentListByAdmin({super.key});

  @override
  State<StockAdjustmentListByAdmin> createState() =>
      _StockAdjustmentListByAdminState();
}

class _StockAdjustmentListByAdminState
    extends State<StockAdjustmentListByAdmin> {
  List<StockAdjustmentListAdminModel> stockAdjustList = [];

  @override
  void initState() {
    context.read<ManageStoreBloc>().add(ListStockAdjustmentByAdmin());
    super.initState();
  }
bool isLoading=true;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
     BlocListener<ManageStoreBloc,ManageStoreState>(listener: (context, state) {
       if(state is ListStockAdjustmentByAdminSuccess)
       {
         isLoading=false;
         stockAdjustList=state.variantList;
         setState(() {

         });
     }if(state is ListStockAdjustmentByAdminFailed)
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
            child: CommonAppBar(title: "Stock Adjustment List")),
        body: stockAdjustList.isEmpty && isLoading==false
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
            :isLoading==true? LoadingPage():SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 8,
                        ),
                        itemCount: stockAdjustList.length,
                        itemBuilder: (context, index) {
                          return StockAcceptCard(
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AdminStockAcceptancePopUp(
                                        receiveStockModel: stockAdjustList[index],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            productCard: stockAdjustList[index],
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
