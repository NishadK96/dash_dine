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
import 'package:pos_app/products/bloc/product_list_bloc.dart';
import 'package:pos_app/products/model/model.dart';
import 'package:pos_app/products/widgets/products_tile_card.dart';
import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/stores/screens/create_store.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/warehouse/bloc/manage_warehouse/manage_warehouse_bloc.dart';
import 'package:pos_app/warehouse/models/warehouse_model.dart';
import 'package:pos_app/warehouse/widgets/success_popup.dart';

class CreateManagerPage extends StatefulWidget {
  const CreateManagerPage({super.key, required this.managerType});
  final String managerType;

  @override
  State<CreateManagerPage> createState() => _CreateManagerPageState();
}

class _CreateManagerPageState extends State<CreateManagerPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ImagePicker picker = ImagePicker();
  File? pickedImage;
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
    if (widget.managerType == "wmanager") {
      context.read<ManageWarehouseBloc>().add(GetAllWarehouses(""));
    } else {
      context.read<ManageStoreBloc>().add(GetAllStores());
    }
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
  bool isLoading = true;
  bool isPassword = false;
  bool isCreationLoading = false;
  bool isCreating = false;
  bool isStore = false;
  List<StoreModel> stores = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Create Manager")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ManageStoreBloc, ManageStoreState>(
              listener: (context, state) {
            if (state is ListStoresLoading) {}
            if (state is ListStoresSuccess) {
              isLoading = false;
              stores.clear();
              stores = state.productList;
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
              if (state is ManagerCreationSuccess) {
                isCreating = false;

                Navigator.pop(context);
                SuccessPopup().successAlert(context, "Manager has been created successfully!");
                context
                    .read<ManagerBloc>()
                    .add(GetAllMangers(managerType: widget.managerType));
                setState(() {});
              }
              if (state is ManagerCreationFailed) {
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
            : Form(
          key: formKey,
              child: SingleChildScrollView(
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
                                  controller: firstNameController,
                                  title: "First name*",
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2 - 20,
                                child: CurvedTextField(
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
                        CurvedTextField(textType: TextInputType.emailAddress,
                          controller: emailController,
                          title: "Enter email address*",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CurvedTextField(
                          controller: phoneController,
                          title: "Enter phone number*",textType: TextInputType.phone,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CurvedTextField(
                          isPassword: true,
                          isVisible: isPassword,
                          onView: () {
                            isPassword = !isPassword;
                            setState(() {});
                          },
                          controller: passwordController,
                          title: "Enter password*",
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                        widget.managerType == "wmanager"
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Select Warehouse",
                                        style: GoogleFonts.urbanist(
                                          color: const Color(0xFF1E232C),
                                          fontSize: 18.sp,
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
                                    child: ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: warehouses.length,
                                      itemBuilder: (context, index) {
                                        return ManagerCard(

                                            attributeData: warehouses[index],
                                            onAdd: () {
                                              if (seletedId ==
                                                  warehouses[index].id) {
                                                seletedId = null;
                                              } else {
                                                seletedId = warehouses[index].id;
                                              }
                                              setState(() {});
                                            },
                                            isAdded: seletedId ==
                                                warehouses[index].id);
                                      },
                                      separatorBuilder: (context, index) =>
                                          const Divider(
                                        height: 0,
                                        color: Color(0xFFE8ECF4),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      isStore = !isStore;
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: ColorTheme.secondaryBlue,
                                          borderRadius: BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 16),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${selectedStore ?? "Select Store"}",
                                              style: GoogleFonts.urbanist(
                                                color: const Color(0xFF1E232C),
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Spacer(),
                                            const Icon(Icons.keyboard_arrow_down)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AnimatedContainer(
                                    height: isStore
                                        ? MediaQuery.of(context).size.height / 4
                                        : 0,
                                    duration: const Duration(milliseconds: 300),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFF7F8F9),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: isStore
                                                ? const Color(0xFFE8ECF4)
                                                : Colors.transparent,
                                            width: 0.0),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      radius: const Radius.circular(5),
                                      child: ListView.separated(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: stores.length,
                                        itemBuilder: (context, index) {
                                          return StoreCard(
                                              attributeData: stores[index],
                                              onAdd: () {
                                                if (seletedId ==
                                                    stores[index].id) {
                                                  seletedId = null;
                                                  selectedStore = null;
                                                } else {
                                                  isStore = false;
                                                  seletedId = stores[index].id;
                                                  selectedStore = stores[index]
                                                      .name
                                                      .toString()
                                                      .toTitleCase();
                                                }
                                                setState(() {});
                                              },
                                              isAdded:
                                                  seletedId == stores[index].id);
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(
                                          height: 0,
                                          color: Color(0xFFE8ECF4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                        const SizedBox(height: 20),
                        SizedBox(
                            width: ScreenUtil().screenWidth - 32,
                            child: CommonButton(
                              isLoading: isCreating,
                              onTap: () {
                               if(formKey.currentState!.validate() && seletedId!=null) {
                                  isCreating = true;
                                  setState(() {});
                                  context.read<ManagerBloc>().add(CreateManager(
                                      password: passwordController.text,
                                      managerType: widget.managerType,
                                      fName: firstNameController.text,
                                      lName: lastNameController.text,
                                      contact: phoneController.text,
                                      email: emailController.text,
                                      wareHouseId:
                                          widget.managerType == "wmanager"
                                              ? seletedId
                                              : null,
                                      storeId: widget.managerType == "manager"
                                          ? seletedId
                                          : null));
                                }else{
                                 Fluttertoast.showToast(msg: "Check the Fields");
                               }
                              },
                              title: "Create new Manager",
                            )),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                ),
            ),
      ),
    );
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
            Icon(isAdded==true
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
      {super.key,
      required this.attributeData,
      required this.onAdd,
      required this.isAdded});
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
