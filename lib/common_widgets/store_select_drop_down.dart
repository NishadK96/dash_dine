import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/products/widgets/attribute_tile_card.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/warehouse/models/warehouse_model.dart';

class StoreDropDownWidget extends StatefulWidget {
  final String? value;
  final Function(String?)? onChange;
  final List<WareHouseModel>? items;
  const StoreDropDownWidget(
      {super.key, required this.value, this.onChange, this.items});

  @override
  State<StoreDropDownWidget> createState() => _StoreDropDownWidgetState();
}

class _StoreDropDownWidgetState extends State<StoreDropDownWidget> {
  @override
  void initState()
  {
    super.initState();
    // widget.items?.insert(0,WareHouseModel(name: "All Warehouses"));
  }

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: ColorTheme.primary, borderRadius: BorderRadius.circular(5)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Row(
            children: [
              Expanded(
                child: Text(
                  'All Warehouses',
                  style: GoogleFonts.urbanist(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: widget.items!
              .map((dynamic item) => DropdownMenuItem<String>(alignment: Alignment.centerLeft,
            value: item.id.toString(),
            child: Text(
              item.name.toString().toTitleCase() ?? "",
              style: GoogleFonts.urbanist(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ))
              .toList(),
          value: widget.value,
          onChanged: widget.onChange,
          // (String? value) {
          //   setState(() {
          //     selectedValue = value;
          //   });
          // },
          buttonStyleData: const ButtonStyleData(
            height: 50,
            width: 160,
            padding: EdgeInsets.only(left: 14, right: 14),

            // elevation: 2,
          ),
          iconStyleData: const IconStyleData(openMenuIcon:Icon(
            Icons.keyboard_arrow_up,
          ),
            icon: Icon(
              Icons.keyboard_arrow_down,
            ),
            iconSize: 14,
            iconEnabledColor: Colors.white,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            padding: const EdgeInsets.only(left: 5, right: 5,top: 5),
            scrollPadding: const EdgeInsets.all(10),
            maxHeight: 200,
            width: w1/2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: ColorTheme.secondary,
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
}
