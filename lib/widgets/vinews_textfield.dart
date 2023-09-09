import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class ViNewsAppTextField extends StatelessWidget {
  final TextEditingController controller;
  final double? textfieldHeight;
  final String hintText;
  final bool obscureText;
  final String prefixIconString;
  final Color? prefixIconColor;
  final String? suffixIconString;
  final Color? suffixIconColor;
  final FocusNode? focusNode;
  final Function()? onIconTap;
  final void Function(String)? onChanged;

  const ViNewsAppTextField({
    Key? key,
    required this.controller,
    this.textfieldHeight,
    required this.hintText,
    required this.obscureText,
    required this.prefixIconString,
    this.prefixIconColor,
    this.suffixIconString,
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
        style: TextStyle(fontSize: 17.sp),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: prefixIconString.imageAsset(
              width: 10, height: 10, color: prefixIconColor),
          suffixIcon: suffixIconString != null
              ? GestureDetector(
                onTap: onIconTap,
                child: suffixIconString!
                    .imageAsset(width: 10, height: 10, color: suffixIconColor),
              )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2.5),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Pallete.blackColor, width: 2.5),
              borderRadius: BorderRadius.circular(12)),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17.sp),
        ),
      ),
    );
  }
}
