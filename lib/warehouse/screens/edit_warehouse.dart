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
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/warehouse/bloc/manage_warehouse/manage_warehouse_bloc.dart';
import 'package:pos_app/warehouse/data/warehouse_datasource.dart';
import 'package:pos_app/warehouse/models/warehouse_model.dart';
import 'package:pos_app/warehouse/widgets/success_popup.dart';

class EditWareHouse extends StatefulWidget {
  const EditWareHouse({super.key, required this.warehouses});
  final WareHouseModel? warehouses;
  @override
  State<EditWareHouse> createState() => _EditWareHouseState();
}

class _EditWareHouseState extends State<EditWareHouse> {
  TextEditingController wareHouseNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
  @override
  void initState() {
    super.initState();
    wareHouseNameController =
        TextEditingController(text: widget.warehouses?.name);
    addressController =
        TextEditingController(text: widget.warehouses?.addressLine);
    cityController = TextEditingController(text: widget.warehouses?.city);
    phoneController =
        TextEditingController(text: widget.warehouses?.phoneNumber);
    emailController = TextEditingController(text: widget.warehouses?.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CommonAppBar(title: "Edit Warehouse")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ManageWarehouseBloc, ManageWarehouseState>(
            listener: (context, state) {
              if (state is CreateWareHouseLoading) {}
              if (state is CreateWareHouseSuccess) {
                isButtonLoading = false;
                setState(() {});
                // Fluttertoast.showToast(msg: state.message);
                context.read<ManageWarehouseBloc>().add(GetAllWarehouses(""));
                Navigator.pop(context);
                SuccessPopup().successAlert(
                    context, "Warehouse has been created successfully!");
              }
              if (state is CreateWareHouseFailed) {
                isButtonLoading = false;
                setState(() {});
                Fluttertoast.showToast(msg: "something went wrong");
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
                  // onTap: () {
                  //   getCoverImage(
                  //     ImageSource.gallery,
                  //   );
                  // },
                  child: Container(
                    width: 106,
                    height: 106,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFF7F7F7),
                      shape: OvalBorder(),
                    ),
                    // padding: const EdgeInsets.all(22),
                    child: SvgPicture.string(CommonSvgFiles().wareHouseIcon),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  controller: wareHouseNameController,
                  title: "Enter warehouse name",
                ),
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  controller: addressController,
                  title: "Enter address line 2",
                  // maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  textType: TextInputType.phone,
                  controller: phoneController,
                  title: "Enter phone number",
                  // maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  controller: emailController,
                  title: "Enter email address",
                  // maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        child: CurvedTextField(
                          title: "Enter city",
                          controller: cityController,
                        )),
                    const Spacer(),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                          color: ColorTheme.secondaryBlue,
                          borderRadius: BorderRadius.circular(8)),
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child: Center(
                        child: Text(
                          'SAUDI ARABIA',
                          style: GoogleFonts.urbanist(
                            color: ColorTheme.text,
                            fontSize: isTab(context) ? 18 : 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Double-check the data before moving to submit.',
                      style: GoogleFonts.urbanist(
                        color: ColorTheme.secondary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
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
                        if (wareHouseNameController.text == "" ||
                            addressController.text == "" ||
                            cityController == "") {
                          Fluttertoast.showToast(msg: "Fill all fields");
                        } else {
                          if (isButtonLoading == true) {
                          } else {
                            isButtonLoading = true;
                            setState(() {});
                            WareHouseDataSource()
                                .editWareHouse(
                                    name: wareHouseNameController.text,
                                    address: addressController.text,
                                    city: cityController.text,
                                    phone: phoneController.text,
                                    email: emailController.text,
                                    wareHouseId:
                                        widget.warehouses?.id.toString() ?? "")
                                .then(
                                  (value) {
                                    if(value.data1==true)
                                      {
                                        context.read<ManageWarehouseBloc>().add(GetAllWarehouses(""));
                                        Fluttertoast.showToast(msg: value.data2);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }else
                                        {
                                          Fluttertoast.showToast(msg: value.data2);
                                          setState(() {

                                          });
                                        }
                                  },
                                );
                          }
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
}
