import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class ViNewsSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final double? textfieldHeight;
  final String hintText;
  final bool obscureText;
  final Widget prefixIcon;
  final Color? prefixIconColor;
  final Widget? suffixIcon;
  final Color? suffixIconColor;
  final FocusNode? focusNode;
  final bool autoFocus;
  final Function()? onIconTap;
  final void Function(String)? onChanged;
  final Function()? onEditingComplete;

  const ViNewsSearchTextField({
    Key? key,
    required this.controller,
    this.textfieldHeight,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.suffixIconColor,
    this.onChanged, 
    this.onEditingComplete,
    this.focusNode, 
    this.autoFocus = false,
    this.onIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: textfieldHeight,
      child: TextFormField(
        focusNode: focusNode,
        autofocus: autoFocus,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        style: TextStyle(fontSize: 16.sp),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: 0.padV,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                onTap: onIconTap,
                child: suffixIcon!
              )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(255, 116, 114, 114), width: 2.5),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Palette.blackColor, width: 2.5),
              borderRadius: BorderRadius.circular(12)),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: const Color.fromARGB(255, 116, 114, 114), fontSize: 16.sp),
        ),
      ),
    );
  }
}
