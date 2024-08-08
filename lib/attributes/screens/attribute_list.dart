import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pos_app/attributes/screens/create_attribute.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/products/widgets/attribute_tile_card.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';

class AttributeList extends StatefulWidget {
  const AttributeList({super.key});

  @override
  State<AttributeList> createState() => _AttributeListState();
}

class _AttributeListState extends State<AttributeList> {
  final List<String> images = [];
  bool isLoading=true;
  @override
  void initState()
  {
    context.read<ProductListBloc>().add(GetAllAttributes());
    super.initState();
  }
  List<ProductList> productList=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Attributes")),
      body: MultiBlocListener(listeners: [
        BlocListener<ProductListBloc,ProductListState>(listener: (context, state) {
          if(state is AttributeListLoading)
            {

            }
          if(state is AttributeListSuccess)
            {
              isLoading=false;
             productList= state.productList;
             setState(() {

             });
            }
          if(state is AttributeListFailed)
            {
              isLoading=false;
              productList=[];
              setState(() {

              });
            }
        },)
      ],
        child:isLoading? const LoadingPage():SingleChildScrollView(
          child: Column(
            children: [

              Container(
                padding:  EdgeInsets.symmetric(horizontal:isTab(context)?30:  16),
                height: 43,
                decoration: const BoxDecoration(color: Color(0xFFF7F7F7)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                       'Total Attributes: ${productList.length}',
                      style: GoogleFonts.poppins(
                        color: ColorTheme.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.30,
                      ),
                    ),
                     InkWell(
                      onTap: (){
                        Navigator.push(context,  MaterialPageRoute(builder: (context) => CreateAttribute(),));
                      },
                       child: Row(
                        children: [
                          SvgPicture.string(CommonSvgFiles().addIconSvg),
                          Text(
                            'Add New',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                                         ),
                     )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding:  EdgeInsets.symmetric(horizontal:isTab(context)?30: 16),
                child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      return AttributeTileCard(productCard: productList[index],
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
