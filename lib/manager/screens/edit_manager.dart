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
import 'package:pos_app/manager/bloc/manager_bloc.dart';
import 'package:pos_app/manager/services/model/model.dart';
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/products/widgets/products_tile_card.dart';
import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/warehouse/bloc/manage_warehouse/manage_warehouse_bloc.dart';
import 'package:pos_app/warehouse/models/warehouse_model.dart';
// import 'package:pos_app/variants/variant_bloc.dart';

class EditManagerPage extends StatefulWidget {
  const EditManagerPage(
      {super.key, required this.managerDetails, required this.managerType});
  final String managerType;
  final ManagerList? managerDetails;

  @override
  State<EditManagerPage> createState() => _EditManagerPageState();
}

class _EditManagerPageState extends State<EditManagerPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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

  @override
  void initState() {
    firstNameController =
        TextEditingController(text: widget.managerDetails?.firstName);
    lastNameController =
        TextEditingController(text: widget.managerDetails?.lastName);
    phoneController =
        TextEditingController(text: widget.managerDetails?.contactNumber);
    emailController = TextEditingController(text: widget.managerDetails?.email);
    // if (widget.managerType == "wmanager") {
    //   context.read<ManageWarehouseBloc>().add(GetAllWarehouses());
    // } else {
    //   context.read<ManageStoreBloc>().add(GetAllStores());
    // }
    super.initState;
  }

  void updateSelectedProduct(ProductList product) {
    setState(() {
      selctedProduct = product;
    });
  }

  List<WareHouseModel> warehouses = [];
  List<int> selectedAttributeList = [];
  int? seletedId;
  String? selectedStore;
  ProductList? selctedProduct;
  bool isLoading = false;
  bool isPassword = false;
  bool isCreationLoading = false;
  bool isCreating = false;
  bool isStore = false;
  List<StoreModel> stores = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(
              title: widget.managerDetails?.userType == "wmanager"
                  ? "Edit Warehouse Manager"
                  : "Edit Store Manager")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ManageStoreBloc, ManageStoreState>(
              listener: (context, state) {
            if (state is ListStoresLoading) {}
            if (state is ListStoresSuccess) {
              isLoading = false;
              stores.clear();
              stores = state.stores.data;
              setState(() {});
            }
            if (state is ListStoresFailed) {
              isLoading = false;
              stores = [];
              setState(() {});
            }
          }),
          BlocListener<ManagerBloc, ManagerState>(
            listener: (context, state) {
              if (state is ManagerEditSuccess) {
                isCreating = false;
                Fluttertoast.showToast(msg: state.message);
                Navigator.pop(context);
                context.read<ManagerBloc>().add(GetAllMangers(
                    managerType: widget.managerDetails?.userType ?? ""));
                setState(() {});
              }
              if (state is ManagerEditFailed) {
                isCreating = false;
                Fluttertoast.showToast(msg: state.message);
                setState(() {});
              }
            },
          ),
          BlocListener<ManageWarehouseBloc, ManageWarehouseState>(
            listener: (context, state) {
              if (state is ListWareHouseLoading) {}
              if (state is ListWareHouseSuccess) {
                warehouses.clear();
                isLoading = false;
                warehouses = state.productList;
                setState(() {});
              }
              if (state is ListWareHouseFailed) {
                isLoading = false;
                warehouses = [];
                setState(() {});
              }
            },
          ),
          BlocListener<ProductListBloc, ProductListState>(
            listener: (context, state) {
              if (state is CreateProductLoading) {}
              if (state is CreateProductSuccess) {
                Fluttertoast.showToast(msg: state.message);
                context.read<ProductListBloc>().add(GetAllProducts());
                Navigator.pop(context);
              }
              if (state is CreateProductFailed) {
                Fluttertoast.showToast(msg: state.message);
                setState(() {});
              }
            },
          )
        ],
        child: isLoading
            ? const LoadingPage()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          _buildPopupDialog();
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
                              : SvgPicture.string(CommonSvgFiles().profile),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: CurvedTextField(
                                isTextLabel: true,
                                textLabel: "First Name",
                                controller: firstNameController,
                                title: "First name*",
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: CurvedTextField(
                                isTextLabel: true,
                                textLabel: "Last Name",
                                controller: lastNameController,
                                title: "Last name*",
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 3,
                      // ),
                      // Row(
                      //   children: [
                      //     Spacer(),
                      //     Text(
                      //       "Manager ID: MNG542",
                      //       style: GoogleFonts.urbanist(
                      //         color: const Color(0xFF1E232C),
                      //         fontSize: 13.sp,
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 0,
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      CurvedTextField(
                        isTextLabel: true,
                        textLabel: "Email Address",
                        controller: emailController,
                        title: "Enter email address*",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CurvedTextField(
                        isTextLabel: true,
                        textLabel: "Phone Number",
                        controller: phoneController,
                        title: "Enter phone number*",
                        textType: TextInputType.phone,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // CurvedTextField(
                      //   isPassword: true,
                      //   isVisible: isPassword,
                      //   onView: () {
                      //     isPassword = !isPassword;
                      //     setState(() {});
                      //   },
                      //   controller: passwordController,
                      //   title: "Enter password*",
                      // ),
                      Row(
                        children: [
                          Text(
                            widget.managerDetails?.userType == "wmanager"
                                ? "Warehouse Name"
                                : "Store Name",
                            style: GoogleFonts.urbanist(
                              color: const Color(0xFF1C1B1F),
                              fontSize: isTab(context)?20:14,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: ColorTheme.secondaryBlue,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                widget.managerDetails?.userType == "wmanager"
                                    ? widget.managerDetails?.operationValue
                                            ?.warehouseName ??
                                        ""
                                    : widget.managerDetails?.operationValue
                                            ?.inventoryName ??
                                        "",
                                style: GoogleFonts.urbanist(
                                  color: const Color(0xFF1E232C),
                                  fontSize: isTab(context)?22:16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                          width: ScreenUtil().screenWidth - 32,
                          child: CommonButton(
                            isLoading: isCreating,
                            onTap: () {
                              if (firstNameController.text == "" ||
                                  lastNameController.text == "" ||
                                  emailController.text == "" ||
                                  phoneController.text == "") {
                                Fluttertoast.showToast(
                                    msg: "All fields are mandatory");
                              } else {
                                isCreating = true;
                                setState(() {});
                                context.read<ManagerBloc>().add(EditManager(
                                      userId: widget.managerDetails?.id
                                              .toString() ??
                                          "",
                                      managerType:
                                          widget.managerDetails?.userType ?? "",
                                      fName: firstNameController.text,
                                      lName: lastNameController.text,
                                      contact: phoneController.text,
                                      email: emailController.text,
                                    ));
                              }
                            },
                            title: "Update Manager",
                          )),
                      const SizedBox(
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<dynamic> _buildPopupDialog() {
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
                fontSize: isTab(context)?22:18,
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
                  SizedBox(
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

class ManagerCard extends StatelessWidget {
  ManagerCard(
      {super.key,
      required this.attributeData,
      required this.onAdd,
      required this.isAdded});
  WareHouseModel? attributeData;
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
            Icon(isAdded
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked_rounded),
            const SizedBox(
              width: 10,
            ),
            Text(
              attributeData?.name ?? "",
              style: GoogleFonts.urbanist(
                color: ColorTheme.text,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                height: 0.08,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  StoreCard(
      {Key? key,
      required this.attributeData,
      required this.onAdd,
      required this.isAdded})
      : super(key: key);
  StoreModel? attributeData;
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
            Icon(isAdded
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked_rounded),
            const SizedBox(
              width: 10,
            ),
            Text(
              attributeData?.name.toString().toTitleCase() ?? "",
              style: GoogleFonts.urbanist(
                color: ColorTheme.text,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                height: 0.08,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
