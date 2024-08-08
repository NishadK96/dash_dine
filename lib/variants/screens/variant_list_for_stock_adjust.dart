import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/stores/widgets/stock_adjust_by_inventory_popup.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/variants/model/stock_adjustment_model.dart';
import 'package:pos_app/variants/screens/widgets/variant_stock_adjust_card.dart';
import 'package:pos_app/variants/variant_bloc.dart';

class VariantsListForStockAdjust extends StatefulWidget {
  const VariantsListForStockAdjust({super.key});

  @override
  State<VariantsListForStockAdjust> createState() =>
      _VariantsListForStockAdjustState();
}

class _VariantsListForStockAdjustState
    extends State<VariantsListForStockAdjust> {
  final List<String> images = [];
  bool isLoading = true;
  @override
  void initState() {
    context.read<VariantBloc>().add(GetAllVariantsByInventoryForStockAdjust());
    super.initState();
  }

  List<StockAdjustmentModel> variantList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Adjust Stock")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<VariantBloc, VariantState>(
            listener: (context, state) {
              if (state is VariantsListForStockAdjustLoading) {}
              if (state is VariantsListForStockAdjustSuccess) {
                isLoading = false;
                variantList = state.variantsList;
                setState(() {});
              }
              if (state is VariantsListFailed) {
                isLoading = false;
                variantList = [];
                setState(() {});
              }
            },
          )
        ],
        child: isLoading
            ? const LoadingPage()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 43,
                      decoration: const BoxDecoration(color: Color(0xFFF7F7F7)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Products: ${variantList.length}',
                            style: GoogleFonts.poppins(
                              color: ColorTheme.primary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.30,
                            ),
                          ),
                         
                        ],
                      ),
                    ),
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
                        itemCount: variantList.length,
                        itemBuilder: (context, index) {
                          return VariantsTileCardStockAdjustment(
                            onAssignStock: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return StockAdjustByInventoryPopup(
                                          stockAdjustData: variantList[index],
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            variantCard: variantList[index],
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
