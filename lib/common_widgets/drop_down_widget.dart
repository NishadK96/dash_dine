import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropDownWidget extends StatelessWidget {
  final String? value;
  final Function(String?)? onChange;
  final List<dynamic>? items;
  const DropDownWidget({super.key, required this.value, this.onChange, this.items});

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width;
    return DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint:  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select Warehouse',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: items!
                      .map((dynamic item) => DropdownMenuItem<String>(
                            value: item.id.toString(),
                            child: Text(
                              item.name ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: value,
                  onChanged: onChange,
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
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(padding: const EdgeInsets.only(left: 5,right: 5),scrollPadding: const EdgeInsets.all(5),
                    maxHeight: 200,
                    width: w1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      // color: Colors.redAccent,
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
              );
  }
}