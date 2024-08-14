import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/drop_down_widget.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/stores/data/store_data_soure.dart';
import 'package:pos_app/stores/manage_store_bloc/manage_store_bloc.dart';
import 'package:pos_app/stores/models/store_model.dart';
import 'package:pos_app/stores/screens/store_list.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/warehouse/bloc/manage_warehouse/manage_warehouse_bloc.dart';
import 'package:pos_app/warehouse/models/warehouse_model.dart';

class EditStore extends StatefulWidget {
  const EditStore({super.key, required this.storeData});
  final StoreModel storeData;
  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  TextEditingController nameController = TextEditingController();
  //  TextEditingController codeController = TextEditingController();
  //  TextEditingController descriptionController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  @override
  void initState() {
    nameController = TextEditingController(text: widget.storeData.name);
    //  descriptionController = TextEditingController(text: widget.storeData.description);
    mailController = TextEditingController(text: widget.storeData.email);
    phoneController = TextEditingController(text: widget.storeData.phone);
    addressController = TextEditingController(text: widget.storeData.address);
    cityController = TextEditingController(text: widget.storeData.city);
    context.read<ManageWarehouseBloc>().add(GetAllWarehouses(""));
    super.initState();
  }

  List<WareHouseModel> wareHouses = [];
  String? selectedValue;
  int? selectedId;
  bool isLoading=false;
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
              Fluttertoast.showToast(msg: state.message);
              context.read<ManageStoreBloc>().add(GetAllStores());
              Navigator.pop(context);
            }
            if (state is CreateStoreFailed) {
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
            child: CommonAppBar(title: "Edit Store")),
        body: Container(
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
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  textLabel: "Store Name",
                  isTextLabel: true,
                  controller: nameController,
                  title: "Enter store name*",
                ),
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  textLabel: "Email",
                  isTextLabel: true,
                  controller: mailController,
                  title: "Enter e-mail address*",
                ),
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  textType: TextInputType.phone,
                  textLabel: "Phone number",
                  isTextLabel: true,
                  controller: phoneController,
                  title: "Enter Phone number*",
                ),
                const SizedBox(
                  height: 10,
                ),
                CurvedTextField(
                  textLabel: "Address",
                  isTextLabel: true,
                  controller: addressController,
                  title: "Enter address line 1*",
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 18,
                      child: CurvedTextField(
                        textLabel: "City",
                        isTextLabel: true,
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
                CommonButton(isLoading: isLoading,
                  title: "Update",
                  onTap: () {
                    if (addressController.text == "" ||
                        cityController.text == "" ||
                        mailController.text == "" ||
                        phoneController.text == "" ||
                        nameController.text == "") {
                      Fluttertoast.showToast(msg: "Please Fill All fields");
                    } else {
                      isLoading=true;
                      setState(() {
                        
                      });
                      StoreDataSource()
                          .editStore(
                              name: nameController.text,
                              id: widget.storeData.id ?? 0,
                              email: mailController.text,
                              phone: phoneController.text,
                              address: addressController.text,
                              city: cityController.text)
                          .then((value) {
                          
                        if (value.data1 == true) {
                          stores.clear();
                          isLoading=false;
                          Fluttertoast.showToast(msg: value.data2);
                           context.read<ManageStoreBloc>().add(GetAllStores());
                          Navigator.pop(context);
                          setState(() {
                            
                          });
                        } else {
                           isLoading=false;
                          Fluttertoast.showToast(msg: value.data2);
                          setState(() {
                            
                          });
                        }
                      });
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
    );
  }
}
