import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_app/utils/colors.dart';
import 'package:pos_app/utils/size_config.dart';
import 'package:pos_app/utils/svg_files/common_svg.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email cannot be empty';
  }
  // Basic email pattern check
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  if (!emailRegex.hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null; // Return null if the email is valid
}
String? validateField(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter the field';
  }
  return null; // Return null if the email is valid
}
class CurvedTextField extends StatelessWidget {
  final bool isSearch;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isVisible;
  final bool? isTextLabel;
  final String? textLabel;
  final String title;
  final VoidCallback? onView;
  final int? maxLines;
  final int? minLines;
  final Function(String)? onChanged;
  final TextInputType? textType;

  const CurvedTextField({
    super.key,
    this.onChanged,
    this.isTextLabel = false,
    this.textLabel,
    required this.title,
    this.controller,
    this.maxLines,
    this.minLines,
    this.textType = TextInputType.text,
    this.isPassword = false,
    this.isVisible = false,
    this.onView,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (isTextLabel == true)
          Text(
            textLabel ?? "",
            style: GoogleFonts.urbanist(
              color: const Color(0xFF1C1B1F),
              fontSize: isTab(context) ? 20 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (isTextLabel == true) const SizedBox(height: 3),
        TextFormField(
          validator:textType==TextInputType.emailAddress? validateEmail:validateField,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: onChanged,
          keyboardType: textType,
          controller: controller,
          obscureText: isPassword && !isVisible,
          cursorColor: ColorTheme.primary,
          maxLines: maxLines ?? 1,
          minLines: minLines ?? 1,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F8F9),
            contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorTheme.primary, width: 1.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: title,
            hintStyle: GoogleFonts.urbanist(
              color: const Color(0xFF8390A1),
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              height: 0.08,
            ),focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide:  BorderSide(color: ColorTheme.primary),
    ),
             errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: ColorTheme.secondary, width: 1.0),
    ),
            errorStyle: GoogleFonts.urbanist(
              color: ColorTheme.red,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
            suffixIcon: isPassword
                ? InkWell(
              onTap: onView,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isVisible
                      ? SvgPicture.string(
                    CommonSvgFiles().passEye,
                    width: 20,
                    height: 20,
                  )
                      : SvgPicture.string(
                    CommonSvgFiles().passEyeClose,
                    width: 11,
                    height: 11,
                  ),
                ],
              ),
            )
                : isSearch
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.string(
                  CommonSvgFiles().searchIcon,
                  width: 18.w,
                  height: 18.w,
                ),
              ],
            )
                : null,
          ),
        ),
      ],
    );
  }
}

