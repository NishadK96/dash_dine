import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/auth/authenticate.dart';
import 'package:pos_app/common_widgets/app_bar.dart';
import 'package:pos_app/common_widgets/buttons.dart';
import 'package:pos_app/common_widgets/text_field.dart';
import 'package:pos_app/manager/bloc/manager_bloc.dart';
import 'package:pos_app/manager/screens/create_manager.dart';
import 'package:pos_app/manager/services/model/model.dart';
import 'package:pos_app/no_data.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/loading_page.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';
import 'package:pos_app/manager/widgets/manager_tile_card.dart';
import 'package:pos_app/warehouse/widgets/success_popup.dart';

class ManagersList extends StatefulWidget {
  const ManagersList({super.key, required this.managerType});
  final String managerType;
  @override
  State<ManagersList> createState() => _ManagersListState();
}

class _ManagersListState extends State<ManagersList> {
  final List<String> images = [];

  @override
  void initState() {
    context
        .read<ManagerBloc>()
        .add(GetAllMangers(managerType: widget.managerType));
    super.initState();
  }

  List<ManagerList> managerList = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CommonAppBar(
              title: widget.managerType == "wmanager"
                  ? "Warehouse Managers"
                  : "Store Managers")),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ManagerBloc, ManagerState>(
            listener: (context, state) {
              if (state is ManagerListLoading) {}
              if (state is ManagerListSuccess) {
                isLoading = false;
                managerList = state.managerList;
                setState(() {});
              }
              if (state is ManagerListFailed) {
                isLoading = false;
                managerList = [];
                setState(() {});
              }
            },
          )
        ],
        child: isLoading
            ? const LoadingPage()
            : managerList.isEmpty
                ? NoDataPage(
                    name: "Create new Manager",
                    isButton: widget.managerType == "wmanager"
                        ? authentication.authenticatedUser.userType == "admin"
                        : authentication.authenticatedUser.userType ==
                                "admin" ||
                            authentication.authenticatedUser.userType ==
                                "wmanager",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateManagerPage(
                              managerType: widget.managerType,
                            ),
                          ));
                    },
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: isTab(context) ? 30 : 16),
                          height: 43,
                          decoration:
                              const BoxDecoration(color: Color(0xFFF7F7F7)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Managers: ${managerList.length}',
                                style: GoogleFonts.poppins(
                                  color: ColorTheme.text,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreateManagerPage(
                                          managerType: widget.managerType,
                                        ),
                                      ));
                                  // SuccessPopup().successAlert(context, "Manager has been created successfully!");
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.string(
                                        CommonSvgFiles().addIconSvg),
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
                        authentication.authenticatedUser.userType == "wmanager"
                            ? SizedBox()
                            : Container(
                                padding: EdgeInsets.only(
                                    left: isTab(context) ? 30 : 16,
                                    right: isTab(context) ? 30 : 16,
                                    bottom: 0),
                                child: CurvedTextField(
                                  onChanged: (val) {
                                    context.read<ManagerBloc>().add(
                                        GetAllMangers(
                                            managerType: widget.managerType,
                                            searchKey: val));
                                  },
                                  isSearch: true,
                                  controller: searchController,
                                  title: "Search manager..",
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: isTab(context) ? 30 : 16),
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 8,
                            ),
                            itemCount: managerList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return ManagerTileCard(
                                managerDetails: managerList[index],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
