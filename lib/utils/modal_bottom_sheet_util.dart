import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showCustomModalBottomSheet(
    BuildContext context, bool isDismissible, Widget theWidget) {
  showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.r), topRight: Radius.circular(50.r))),
      builder: (BuildContext context) {
        return theWidget;
      });
}
