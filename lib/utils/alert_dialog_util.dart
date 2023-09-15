import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

void showAlertDialog(BuildContext context, String title, Widget leadingIcon, String dialogContent,
    String actionButtonTextLeft, String actionButtonTextRight) {
  showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              leadingIcon,
              7.sbW,
              title.txtStyled(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ],
          ),
          content: dialogContent.txtStyled(
              textAlign: TextAlign.justify, fontSize: 19.sp),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: actionButtonTextLeft.txtStyled(fontSize: 18.sp, fontWeight: FontWeight.w700, color: Pallete.blackColor),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                context.pop();
              },
              child: actionButtonTextRight.txtStyled(fontSize: 18.sp, fontWeight: FontWeight.w700,color: Pallete.blackColor),
            ),
          ],
        );
      });
}
