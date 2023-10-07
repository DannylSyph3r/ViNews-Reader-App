import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/themes/color_palette.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class ViNewsAppTextFormField extends ConsumerWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String prefixIconString;
  final Color? prefixIconColor;
  final String? suffixIconString;
  final Color? suffixIconColor;
  final FocusNode? focusNode;
  final Function()? onIconTap;
  final void Function(String)? onChanged;
  final String? errorText;
  final VoidCallback? onEditingComplete;
  final TextInputType inputType;
  final FormFieldValidator<String>? validator;

  const ViNewsAppTextFormField({
    Key? key,
    required this.controller,
    this.focusNode,
    required this.hintText,
    this.errorText,
    this.onChanged,
    this.inputType = TextInputType.text,
    this.validator,
    required this.prefixIconString,
    this.prefixIconColor,
    this.suffixIconString,
    this.suffixIconColor,
    this.onIconTap,
    this.onEditingComplete,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      //height: 60,
      child: TextFormField(
        focusNode: focusNode,
        onChanged: onChanged,
        style: TextStyle(fontSize: 17.sp),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          helperText: " ",
          errorText: errorText,
          prefixIcon: prefixIconString.imageAsset(
              width: 10, height: 10, color: prefixIconColor),
          suffixIcon: suffixIconString != null
              ? GestureDetector(
                  onTap: onIconTap,
                  child: suffixIconString!.imageAsset(
                      width: 10, height: 10, color: suffixIconColor),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2.5),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Palette.blackColor, width: 2.5),
              borderRadius: BorderRadius.circular(12)),
          errorMaxLines: 2,
          errorStyle:
              TextStyle(color: Palette.redColor, fontSize: 17.sp, height: 1.0,),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Palette.redColor,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Palette.redColor,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17.sp),
        ),
        autocorrect: false,
        keyboardType: inputType,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
