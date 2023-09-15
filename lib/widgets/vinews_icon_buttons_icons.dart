import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class ViNewsAppIconButton extends ConsumerWidget {
  final String buttonPlaceholderText;
  final Function()? onButtonPress;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? boxShadowColor;
  final Color? buttonColor;
  final Color? textColor;
  final Color? iconColor;
  final bool isEnabled;

  const ViNewsAppIconButton({
    Key? key,
    required this.buttonPlaceholderText,
    this.onButtonPress,
    this.prefixIcon,
    this.suffixIcon,
    this.boxShadowColor,
    this.buttonColor,
    this.textColor,
    this.iconColor,
    this.isEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: boxShadowColor ?? Pallete.blackColor,
        //     blurRadius: 16,
        //     offset: const Offset(0, 2),
        //     spreadRadius: 0,
        //   )
        // ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
          onPressed: isEnabled
            ? onButtonPress
            : null, // Disable the button if isEnabled is false
        style: ElevatedButton.styleFrom(
          elevation: 0,
          fixedSize: Size(390.w, 78.w),
          backgroundColor: buttonColor ?? Pallete.blackColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (prefixIcon != null) // Conditionally include the prefixIcon
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: prefixIcon!.iconslide(color: iconColor),
              ),
            Text(
              buttonPlaceholderText,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
              ),
            ),
            if (suffixIcon != null) // Conditionally include the suffixIcon
              Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: suffixIcon!.iconslide(color: iconColor)),
          ],
        ),
      ),
    );
  }
}
