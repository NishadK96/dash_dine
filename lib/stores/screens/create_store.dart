import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/drop_down_widget.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/warehouse/bloc/manage_warehouse/manage_warehouse_bloc.dart';
import 'package:pos_app/warehouse/models/warehouse_model.dart';
import 'package:pos_app/warehouse/widgets/success_popup.dart';

final formKey = GlobalKey<FormState>();

class CreateNewStore extends StatefulWidget {
  const CreateNewStore({super.key});

  @override
  State<CreateNewStore> createState() => _CreateNewStoreState();
}

class _CreateNewStoreState extends State<CreateNewStore> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  @override
  void initState() {
    context.read<ManageWarehouseBloc>().add(GetAllWarehouses(""));
    super.initState();
  }

  List<WareHouseModel> wareHouses = [];
  String? selectedValue;
  int? selectedId;
  bool isButtonLoading = false;
  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;
    return MultiBlocListener(
      listeners: [
        BlocListener<ManageWarehouseBloc, ManageWarehouseState>(
          listener: (context, state) {
            if (state is ListWareHouseSuccess) {
              wareHouses.clear();
              wareHouses = state.productList;
              //  dropdownvalue=state.productList[0].name;
              setState(() {});
            }
          },
        ),
        BlocListener<ManageStoreBloc, ManageStoreState>(
          listener: (context, state) {
            if (state is CreateStoreLoading) {}
            if (state is CreateStoreSuccess) {
              isButtonLoading = false;
              setState(() {});
              Fluttertoast.showToast(msg: state.message);
              context.read<ManageStoreBloc>().add(GetAllStores());
              Navigator.pop(context);
              SuccessPopup().successAlert(
                  context, "Store has been created successfully!");
            }
            if (state is CreateStoreFailed) {
              isButtonLoading = false;

              Fluttertoast.showToast(msg: state.message);
              setState(() {});
            }
          },
        )
      ],
      child: Scaffold(
        backgroundColor: ColorTheme.backGround,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: CommonAppBar(title: "Create New Store")),
        body: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 106,
                    height: 106,
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: OvalBorder(),
                    ),
                    padding: const EdgeInsets.all(22),
                    child: SvgPicture.string(CommonSvgFiles().addImageSvg),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  authentication.authenticatedUser.userType == "admin"
                      ? Container(
                          width: w1,
                          height: 46,
                          decoration: BoxDecoration(
                              color: ColorTheme.secondaryBlue,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black12)),
                          child: DropDownWidget(
                            value: selectedValue,
                            items: wareHouses,
                            onChange: (val) {
                              selectedValue = val;
                              setState(() {});
                            },
                          ),
                        )
                      : SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  CurvedTextField(
                    controller: nameController,
                    title: "Enter store name*",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CurvedTextField(
                    textType: TextInputType.emailAddress,
                    controller: mailController,
                    title: "Enter e-mail address*",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CurvedTextField(
                    textType: TextInputType.phone,
                    controller: phoneController,
                    title: "Enter Phone number*",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CurvedTextField(
                    controller: addressController,
                    title: "Enter address line 1*",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 18,
                        child: CurvedTextField(
                          controller: cityController,
                          title: "Enter City*",
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 18,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFE8ECF4),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFE8ECF4)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          "SAUDI ARABIA",
                          style: GoogleFonts.urbanist(
                            color: ColorTheme.text,
                            fontSize: isTab(context) ? 20 : 15,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '*All fields are mandatory',
                            style: GoogleFonts.urbanist(
                              color: const Color(0xFF8390A1),
                              fontSize: isTab(context) ? 14 : 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  CommonButton(
                    isLoading: isButtonLoading,
                    title: "Create new store",
                    onTap: () {
                      if(selectedValue==null || selectedValue=="")
                        {
                          Fluttertoast.showToast(msg: "Select WareHouse");
                        }
                     else if (formKey.currentState!.validate() ) {
                        isButtonLoading = true;
                        setState(() {});
                        context.read<ManageStoreBloc>().add(CreateStore(
                            address: addressController.text,
                            city: cityController.text,
                            email: mailController.text,
                            phone: phoneController.text,
                            wareHouseId:
                            authentication.authenticatedUser.userType ==
                                "admin"
                                ? int.parse(selectedValue ?? "")
                                : authentication.authenticatedUser
                                .businessData?.businessId ??
                                0,
                            name: nameController.text));
                      } else {
                        Fluttertoast.showToast(msg: "Please check fields!");

                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
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
