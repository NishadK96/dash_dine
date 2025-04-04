
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
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/products/widgets/products_tile_card.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/variants/data/data_source.dart';
import 'package:pos_app/variants/model/attribute_model.dart';
import 'package:pos_app/variants/model/variant_model.dart';
import 'package:pos_app/variants/screens/variant_list.dart';
import 'package:pos_app/variants/variant_bloc.dart';

// import 'package:pos_app/variants/variant_bloc.dart';
List<AttributeModel> newList = [];

class EditVariant extends StatefulWidget {
  const EditVariant({super.key, required this.variantCard});
  final VariantsListModel? variantCard;
  @override
  State<EditVariant> createState() => _EditVariantState();
}

class _EditVariantState extends State<EditVariant> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ImagePicker picker = ImagePicker();
  File? pickedImage;
  String? priceType;
  Future<void> getCoverImage(source) async {
    try {
      final pickedFile =
      await picker.pickImage(source: source, maxHeight: 512, maxWidth: 512);

      if (pickedFile != null) {
        pickedImage = File(pickedFile.path);
        // VariantDataSource()
        //     .editImage(
        //         image: pickedImage, variantId: widget.variantCard?.id ?? 0)
        //     .then((value) {
        //       print("vsluuuuu eee $value");
        //   if (value.data1 == true) {
        //     // Navigator.pop(context);
        //     Fluttertoast.showToast(msg: value.data2,backgroundColor: Colors.white,textColor: Colors.black);
        //     setState(() {
        //       isCreating = false;
        //     });
        //   } else {
        //     setState(() {
        //       isCreating = false;
        //     });
        //     Fluttertoast.showToast(msg: value.data2);
        //   }
        // });
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  VariantsListModel? variantDetails;

  @override
  void initState() {
    newList.clear();
    VariantDataSource()
        .getVariantDetails(id: widget.variantCard?.id ?? 0)
        .then((value) {
      if (value.data1 == true) {
        isDetailLoading = false;
        variantDetails = value.data2;
        priceType = variantDetails?.variantData?.stockType;
        selctedProduct = variantDetails?.variantData?.productId?.id;
        selctedProductName = variantDetails?.variantData?.productId?.name;
        for (int i = 0;
        i < variantDetails!.variantData!.attributeId!.length;
        i++) {
          selectedAttributeList
              .add(variantDetails?.variantData?.attributeId?[i].id ?? 0);
          updatedAttributeList
              .add(variantDetails?.variantData?.attributeId?[i].id ?? 0);
          newList.add(AttributeModel(
              id: variantDetails?.variantData?.attributeId?[i].id,
              isActive: true));
        }
        setState(() {});
      } else {
        print("hjsdhfjhjshcjhjsvhb $selctedProductName ,$selctedProduct");
        isDetailLoading = false;
        setState(() {});
      }
    });
    context.read<VariantBloc>().add(GetAllAttributeList());
    context.read<ProductListBloc>().add(const GetAllProducts());
    productNameController =
        TextEditingController(text: widget.variantCard?.name);
    descriptionController =
        TextEditingController(text: widget.variantCard?.description);
    super.initState();
  }

  void updateSelectedProduct(int product, String name) {
    setState(() {
      selctedProduct = product;
      selctedProductName = name;
    });
  }

  List<AttributeList> attributeList = [];
  List<int> selectedAttributeList = [];
  List<int> updatedAttributeList = [];
  List<ProductList> productList = [];
  int? selctedProduct;
  String? selctedProductName;
  bool isLoading = true;
  bool isDetailLoading = true;
  bool isCreating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Edit Variant")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductListBloc, ProductListState>(
            listener: (context, state) {
              if (state is ProductListLoading) {}
              if (state is ProductListSuccess) {
                productList = state.productList.data;
                setState(() {});
              }
              if (state is ProductListFailed) {
                isLoading = false;
                productList = [];
                setState(() {});
              }
            },
          ),
          BlocListener<VariantBloc, VariantState>(
            listener: (context, state) {
              if (state is CreateVariantFailed) {
                isCreating = false;
                Fluttertoast.showToast(msg: state.message);
                setState(() {});
              }
              if (state is CreateVariantSuccess) {
                isCreating = false;
                Fluttertoast.showToast(msg: state.message);
                context.read<VariantBloc>().add(GetAllVariants());
                Navigator.pop(context);
                setState(() {});
              }
              if (state is AttributesListLoading) {}
              if (state is AttributesListSuccess) {
                isLoading = false;
                attributeList = state.attributeList;
                setState(() {});
              }
              if (state is AttributesListFailed) {
                isLoading = false;
                setState(() {});
              }
            },
          ),
          BlocListener<ProductListBloc, ProductListState>(
            listener: (context, state) {
              if (state is CreateProductLoading) {}
              if (state is CreateProductSuccess) {
                Fluttertoast.showToast(msg: state.message);
                context.read<ProductListBloc>().add(const GetAllProducts());
                Navigator.pop(context);
              }
              if (state is CreateProductFailed) {
                Fluttertoast.showToast(msg: state.message);
                setState(() {});
              }
            },
          )
        ],
        child: isLoading || isDetailLoading
            ? const LoadingPage()
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    _buildPopupDialog(widget.variantCard?.id ?? 0);
                    // getCoverImage(ImageSource.gallery);
                    //  setState(() {

                    //  });
                  },
                  child: Container(
                      width: 106,
                      height: 106,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFF7F7F7),
                        shape: OvalBorder(),
                      ),
                      padding: const EdgeInsets.all(0),
                      child: pickedImage != null
                          ? Stack(
                        children: [
                          SizedBox(
                            width: 106,
                            height: 106,
                            child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(100),
                                child: Image.file(
                                  pickedImage!,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: SvgPicture.string(
                                  CommonSvgFiles().camera))
                        ],
                      )
                          : Stack(
                        children: [
                          SizedBox(
                            width: 106,
                            height: 106,
                            child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(100),
                                child: Image.network(
                                  widget.variantCard?.image ?? "",
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor:
                                  Colors.grey.shade100,
                                  // color: Colors.grey.shade100,
                                  // padding: EdgeInsets.all(3),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 16,
                                  )))
                        ],
                      )
                    //  Padding(
                    //     padding: const EdgeInsets.all(20.0),
                    //     child: SvgPicture.string(
                    //         CommonSvgFiles().addImageSvg),
                    //   ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  controller: productNameController,
                  title: "Enter Variant name*",
                ),
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  controller: descriptionController,
                  title: "Enter description*",
                ),
                const SizedBox(
                  height: 26,
                ),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {
                        priceType = "normal stock";
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          width:
                          MediaQuery.of(context).size.width / 2 - 27,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              priceType == "normal stock"
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
                                "Normal Stock",
                                style: GoogleFonts.urbanist(
                                  color: ColorTheme.primary,
                                  fontSize: isTab(context) ? 18 : 16.sp,
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
                        priceType = "dynamic stock";
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: SizedBox(
                          width:
                          MediaQuery.of(context).size.width / 2 - 27,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              priceType == "dynamic stock"
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
                                "Dynamic Stock",
                                style: GoogleFonts.urbanist(
                                  color: ColorTheme.primary,
                                  fontSize: isTab(context) ? 18 : 16.sp,
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
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      "Select Product*",
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF1E232C),
                        fontSize: isTab(context) ? 20 : 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();

                    showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Container(
                              height: MediaQuery.of(context).size.height /
                                  2.5,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                          child: Container(
                                            width: 35,
                                            height: 7,
                                            decoration: BoxDecoration(
                                                color:
                                                ColorTheme.secondaryBlue,
                                                borderRadius:
                                                BorderRadius.circular(5)),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Select a Product",
                                        style: GoogleFonts.urbanist(
                                          color: const Color(0xFF1E232C),
                                          fontSize:
                                          isTab(context) ? 20 : 18.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFF7F8F9),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Color(0xFFE8ECF4),
                                                width: 0.0),
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                        ),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                          const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount: productList.length,
                                          itemBuilder: (context, index) {
                                            return ProductCard(
                                                productData:
                                                productList[index],
                                                onAdd: () {
                                                  updateSelectedProduct(
                                                      productList[index]
                                                          .id,
                                                      productList[index]
                                                          .name);
                                                  Navigator.pop(context);
                                                },
                                                isAdded: selctedProduct ==
                                                    productList[index]
                                                        .id);
                                          },
                                          separatorBuilder:
                                              (context, index) =>
                                          const Divider(
                                            height: 0,
                                            color: Color(0xFFE8ECF4),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    // width: 382.w,
                    height: isTab(context) ? 56 : 56.h,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF7F8F9),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color(0xFFE8ECF4), width: 0.0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(
                                selctedProduct == null
                                    ? "Select Product"
                                    : selctedProductName
                                    .toString()
                                    .toTitleCase() ??
                                    "",
                                style: GoogleFonts.urbanist(
                                  color: selctedProduct == null
                                      ? const Color(0xFF8390A1)
                                      : ColorTheme.text,
                                  fontSize: isTab(context) ? 16 : 15.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 0.08,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                Row(
                  children: [
                    Text(
                      "Select Attribute*",
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF1E232C),
                        fontSize: isTab(context) ? 20 : 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF7F8F9),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Color(0xFFE8ECF4), width: 0.0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: ListView.separated(physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: attributeList.length,
                    itemBuilder: (context, index) {
                      return AttributeCard(
                          attributeData: attributeList[index],
                          onAdd: () {
                            if (selectedAttributeList
                                .contains(attributeList[index].id)) {
                              if (updatedAttributeList
                                  .contains(attributeList[index].id)) {
                                updatedAttributeList
                                    .remove(attributeList[index].id);
                                newList.setAll(index, [
                                  AttributeModel(
                                      id: attributeList[index].id,
                                      isActive: false)
                                ]);
                              } else {
                                updatedAttributeList
                                    .add(attributeList[index].id ?? 0);
                                newList.add(AttributeModel(
                                    id: attributeList[index].id,
                                    isActive: true));
                              }
                            } else {
                              if (updatedAttributeList
                                  .contains(attributeList[index].id)) {
                                updatedAttributeList
                                    .remove(attributeList[index].id);
                                newList.remove(AttributeModel(
                                    id: attributeList[index].id,
                                    isActive: true));
                              } else {
                                updatedAttributeList
                                    .add(attributeList[index].id ?? 0);
                                newList.add(AttributeModel(
                                    id: attributeList[index].id,
                                    isActive: true));
                              }
                            }
                            setState(() {});
                          },
                          isAdded: updatedAttributeList
                              .contains(attributeList[index].id));
                    },
                    separatorBuilder: (context, index) => const Divider(
                      height: 0,
                      color: Color(0xFFE8ECF4),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    width: ScreenUtil().screenWidth - 32,
                    child: CommonButton(
                      isLoading: isCreating,
                      onTap: () {
                        // if (productNameController.text == "" ||
                        //     pickedImage == null ||
                        //     descriptionController.text == "" ||
                        //     selctedProduct == null ||
                        //     selectedAttributeList.isEmpty) {
                        //   Fluttertoast.showToast(
                        //       msg: "Please Fill All Fields");
                        // } else {
                        isCreating = true;
                        setState(() {});
                        if(pickedImage!=null){
                          VariantDataSource()
                              .editImage(
                              image: pickedImage,
                              variantId: widget.variantCard?.id ?? 0)
                              .then((value) {
                            print("vsluuuuu eee $value");
                            if (value.data1 == true) {
                              // Navigator.pop(context);
                              VariantDataSource()
                                  .editVariant(
                                  name: productNameController.text,
                                  description:
                                  descriptionController.text,
                                  updatedBy: "",
                                  image: pickedImage,
                                  stockType:
                                  priceType ?? "normal stock",
                                  attributes: newList,
                                  productId: selctedProduct ?? 0,
                                  variantId:
                                  widget.variantCard?.id ?? 0)
                                  .then((value) {
                                if (value.data1 == true) {

                                  // setState(() {

                                  // });

                                  // Navigator.pop(context);
                                  // variantList.clear();
                                  // context
                                  //     .read<VariantBloc>()
                                  //     .add(GetAllVariants(pageNo: 1));
                                  Fluttertoast.showToast(msg: value.data2);
                                  setState(() {
                                    isCreating = false;
                                  });
                                } else {
                                  setState(() {
                                    isCreating = false;
                                  });
                                  Fluttertoast.showToast(msg: value.data2);
                                }
                              });
                            } else {
                              Fluttertoast.showToast(msg: value.data2);
                            }
                          });
                        }
                        else{
                          VariantDataSource()
                              .editVariant(
                              name: productNameController.text,
                              description:
                              descriptionController.text,
                              updatedBy: "",
                              image: pickedImage,
                              stockType:
                              priceType ?? "normal stock",
                              attributes: newList,
                              productId: selctedProduct ?? 0,
                              variantId:
                              widget.variantCard?.id ?? 0)
                              .then((value) {
                            if (value.data1 == true) {
                            
                              // context
                              //     .read<VariantBloc>()
                              //     .add(GetAllVariants(pageNo: 1));
                              Fluttertoast.showToast(msg: value.data2);
                              setState(() {
                                isCreating = false;
                              });
                              // Navigator.pop(context);

                            } else {
                              setState(() {
                                isCreating = false;
                              });
                              Fluttertoast.showToast(msg: value.data2);
                            }
                          });
                        }
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

  Future<dynamic> _buildPopupDialog(int variantId) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Text(
              'Upload Image From',
              style: GoogleFonts.urbanist(
                color: ColorTheme.primary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CommonButton(
                    onTap: () {
                      getCoverImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    title: "Camera",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonButton(
                    onTap: () {
                      getCoverImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    title: "Gallery",
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class AttributeCard extends StatelessWidget {
  AttributeCard(
      {super.key,
        required this.attributeData,
        required this.onAdd,
        required this.isAdded});
  AttributeList? attributeData;
  VoidCallback onAdd;
  bool isAdded;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAdd,
      child: Padding(
        padding:
        const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: [
            Text(
              attributeData?.name?.toTitleCase() ?? "",
              style: GoogleFonts.urbanist(
                color: ColorTheme.text,
                fontSize: isTab(context) ? 20 : 18.sp,
                fontWeight: FontWeight.w500,
                height: 0.08,
              ),
            ),
            const Spacer(),
            Icon(isAdded
                ? Icons.check_box
                : Icons.check_box_outline_blank_outlined)
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  ProductCard(
      {super.key,
        required this.productData,
        required this.onAdd,
        required this.isAdded});
  ProductList? productData;
  VoidCallback onAdd;
  bool isAdded;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAdd,
      child: Padding(
        padding:
        const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: [
            Text(
              productData?.name.toTitleCase() ?? "",
              style: GoogleFonts.urbanist(
                color: ColorTheme.text,
                fontSize: isTab(context) ? 20 : 18.sp,
                fontWeight: FontWeight.w500,
                height: 0.08,
              ),
            ),
            const Spacer(),
            Icon(isAdded
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked_rounded)
          ],
        ),
      ),
    );
  }
}

class AttributeModel {
  int? id;
  bool? isActive;

  AttributeModel({
    this.isActive,
    this.id,
  });

  AttributeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_active'] = isActive;
    data['id'] = id;
    return data;
  }
}
