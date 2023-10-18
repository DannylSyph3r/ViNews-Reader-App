import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class CustomDivider extends StatelessWidget {
  final String dividerText;
  const CustomDivider({super.key, required this.dividerText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: Divider(color: Palette.greyColor, thickness: 1.5,)),
        Padding(
            padding: 10.padH,
            child: dividerText.txtStyled(fontSize: 18.sp)),
        const Expanded(child: Divider(color: Palette.greyColor, thickness: 1.5,)),
      ],
    );
  }
}
