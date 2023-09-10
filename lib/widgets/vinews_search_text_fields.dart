import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';

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
  final Function()? onIconTap;
  final void Function(String)? onChanged;

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
    this.focusNode, 
    this.onIconTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: textfieldHeight,
      child: TextField(
        focusNode: focusNode,
        onChanged: onChanged,
        style: TextStyle(fontSize: 20.sp),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
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
                  const BorderSide(color: Pallete.blackColor, width: 2.5),
              borderRadius: BorderRadius.circular(12)),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: const Color.fromARGB(255, 116, 114, 114), fontSize: 20.sp),
        ),
      ),
    );
  }
}
