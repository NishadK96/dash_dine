import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/products/data/data_source.dart';
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';

class EditAttribute extends StatefulWidget {
  const EditAttribute({super.key, required this.productList});
  final ProductList? productList;
  @override
  State<EditAttribute> createState() => _EditAttributeState();
}

class _EditAttributeState extends State<EditAttribute> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ImagePicker picker = ImagePicker();
  File? pickedImage;
  bool isButtonLoading=false;
  Future<void> getCoverImage(source) async {
    try {
      final pickedFile =
          await picker.pickImage(source: source, maxHeight: 512, maxWidth: 512);

      if (pickedFile != null) {
        pickedImage = File(pickedFile.path);
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    productNameController =
        TextEditingController(text: widget.productList?.name);
    descriptionController =
        TextEditingController(text: widget.productList?.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Edit Attribute")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductListBloc, ProductListState>(
            listener: (context, state) {
              if (state is CreateAttributeLoading) {}
              if (state is CreateAttributeSuccess) {
                Fluttertoast.showToast(msg: state.message);
                context.read<ProductListBloc>().add(GetAllAttributes());
                Navigator.pop(context);
              }
              if (state is CreateAttributeFailed) {
                Fluttertoast.showToast(msg: state.message);
                setState(() {});
              }
            },
          )
        ],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // InkWell(onTap: () {
                //   getCoverImage(ImageSource.gallery,);
                // },
                //   child: Container(
                //     width: 106,
                //     height: 106,
                //     decoration: const ShapeDecoration(
                //       color: Color(0xFFF7F7F7),
                //       shape: OvalBorder(),
                //     ),
                //     padding: const EdgeInsets.all(22),
                //     child:pickedImage!=null? ClipRRect(borderRadius: BorderRadius.circular(22),child: Image.file(pickedImage!,fit: BoxFit.cover,)):SvgPicture.string(CommonSvgFiles().addImageSvg),
                //   ),
                // ),
                SvgPicture.string(
                  CommonSvgFiles().attributeSvgImg,
                  height: 80,
                ),
                SizedBox(
                  height: 20,
                ),

                CurvedTextField(
                  controller: productNameController,
                  title: "Enter Attribute name",
                ),
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  controller: descriptionController,
                  title: "Enter description",
                  maxLines: 3,
                ),
                const SizedBox(
                  height: 26,
                ),

                // productScreenWidget.note(),
                // const SizedBox(
                //   height: 20,
                // ),
                SizedBox(
                    width: ScreenUtil().screenWidth - 32,
                    child: CommonButton(isLoading: isButtonLoading,
                      onTap: () {
                        isButtonLoading=true;
                        setState(() {
                          
                        });
                        ProductDataSource()
                            .editAttribute(
                                id: widget.productList?.id ?? 0,
                                description: descriptionController.text,
                                name: productNameController.text)
                            .then((value) {
                          if (value.data1 == true) {
                            context
                                .read<ProductListBloc>()
                                .add(GetAllAttributes());
                                isButtonLoading=false;
                                setState(() {
                                  
                                });
                            Fluttertoast.showToast(msg: value.data2);
                            Navigator.pop(context);
                          } else {
                              isButtonLoading=false;
                                setState(() {
                                  
                                });
                            Fluttertoast.showToast(msg: value.data2);
                          }
                        });
                      },
                      title: "Update",
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
