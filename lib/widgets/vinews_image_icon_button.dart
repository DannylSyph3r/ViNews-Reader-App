import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class ViNewsAppImageIconButton extends ConsumerWidget {
  final String buttonPlaceholderText;
  final Function()? onButtonPress;
  final String? prefixIcon;
  final String? suffixIcon;
  final Color? boxShadowColor;
  final Color? buttonColor;
  final Color? textColor;
  final Color? iconColor;
  final bool isEnabled; // New property

  const ViNewsAppImageIconButton({
    Key? key,
    required this.buttonPlaceholderText,
    this.onButtonPress,
    this.prefixIcon,
    this.suffixIcon,
    this.boxShadowColor,
    this.buttonColor,
    this.textColor,
    this.iconColor,
    this.isEnabled = false, // Initialize with false by default
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: isEnabled
            ? onButtonPress
            : null, // Disable the button if isEnabled is false
        style: ElevatedButton.styleFrom(
          elevation: 0,
          fixedSize: Size(331.w, 60.w),
          backgroundColor: buttonColor ?? Pallete.appButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (prefixIcon != null)
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: prefixIcon!.imageAsset(color: iconColor),
              ),
            Text(
              buttonPlaceholderText,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
            if (suffixIcon != null)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: suffixIcon!.imageAsset(color: iconColor),
              ),
          ],
        ),
      ),
    );
  }
}
