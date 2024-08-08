import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/warehouse/widgets/success_popup.dart';

class CreateNewProduct extends StatefulWidget {
  const CreateNewProduct({super.key});

  @override
  State<CreateNewProduct> createState() => _CreateNewProductState();
}

class _CreateNewProductState extends State<CreateNewProduct> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ImagePicker picker = ImagePicker();
  File? pickedImage;
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

  bool isButtonLoading = false;
  String? priceType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Create New Product")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductListBloc, ProductListState>(
            listener: (context, state) {
              if (state is CreateProductLoading) {}
              if (state is CreateProductSuccess) {
                isButtonLoading = false;
                setState(() {});
                Fluttertoast.showToast(msg: state.message);
                context.read<ProductListBloc>().add(GetAllProducts());
                Navigator.pop(context);
                SuccessPopup().successAlert(context, "Product has been created successfully!");
              }
              if (state is CreateProductFailed) {
                isButtonLoading = false;
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
                InkWell(
                  onTap: () {
                     _buildPopupDialog();
                    // getCoverImage(
                    //   ImageSource.gallery,
                    // );
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 106,
                        height: 106,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFD9D9D9).withOpacity(0.5),
                          shape: const OvalBorder(),
                        ),
                        // padding: const EdgeInsets.all(22),
                        child: pickedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  pickedImage!,
                                  fit: BoxFit.cover,
                                ))
                            : Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SvgPicture.string(
                                    CommonSvgFiles().addImageSvg),
                              ),
                      ),
                      pickedImage != null
                          ? Positioned(
                              right: 0,
                              bottom: 0,
                              child: SvgPicture.string(CommonSvgFiles().camera))
                          : const SizedBox()
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  controller: productNameController,
                  title: "Enter product name",
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
                Row(
                  children: [
                    Text(
                      "Price Type",
                      style: GoogleFonts.urbanist(
                        color: ColorTheme.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {
                        priceType = "normal price";
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 27,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              priceType == "normal price"
                                  ? Icon(
                                      Icons.radio_button_checked_rounded,
                                      color: ColorTheme.primary,
                                    )
                                  : Icon(
                                      Icons.radio_button_off_rounded,
                                      color: ColorTheme.secondary,
                                    ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Normal Price",
                                style: GoogleFonts.urbanist(
                                  color: ColorTheme.primary,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {
                        priceType = "dynamic price";
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 27,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              priceType == "dynamic price"
                                  ? Icon(
                                      Icons.radio_button_checked_rounded,
                                      color: ColorTheme.primary,
                                    )
                                  : Icon(
                                      Icons.radio_button_off_rounded,
                                      color: ColorTheme.secondary,
                                    ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Instant Price",
                                style: GoogleFonts.urbanist(
                                  color: ColorTheme.primary,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.info_outline,
                        size: 15.sp,
                        color: ColorTheme.secondary,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 50,
                          child: Text(
                            'The normal price is the standard price that is already listed.The instant price means the price is applied immediately upon purchase.',
                            style: GoogleFonts.urbanist(
                              color: ColorTheme.secondary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: ScreenUtil().screenWidth - 32,
                    child: CommonButton(
                      isLoading: isButtonLoading,
                      onTap: () {
                        if (isButtonLoading == true) {
                        } else if (descriptionController.text == ""||
                            productNameController.text == ""|| pickedImage==null ) {
                          Fluttertoast.showToast(msg: "All fields are mandatory");
                        } else {
                          isButtonLoading = true;
                          setState(() {});
                          context.read<ProductListBloc>().add(
                              CreateProductEvent(
                                  costingType: priceType ?? "normal price",
                                  image: pickedImage ?? File(""),
                                  updatedBy: "",
                                  description: descriptionController.text,
                                  name: productNameController.text));
                        }
                      },
                      title: "Create new Products",
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
  
Future<dynamic> _buildPopupDialog() {
    return showDialog(context: context,
      builder: (context) {
        return AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)) ,
          backgroundColor: Colors.white,
          surfaceTintColor:  Colors.white,
          title:  Text('Upload Image From', style: GoogleFonts.urbanist(
                        color: ColorTheme.primary,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),),
          content: Container(color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
            
                CommonButton( onTap: ()
                {

                  getCoverImage( ImageSource.camera);
                    Navigator.pop(context);
                },title: "Camera",),
                SizedBox(height: 10,),
             CommonButton( onTap: ()
                {
                
                  getCoverImage( ImageSource.gallery);
                  Navigator.pop(context);
                },title: "Gallery",),
            
              ],
            ),
          ),
        );
      }
    );
  }
 }


