import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// void showSnackBar(BuildContext context, Widget content) {
//   ScaffoldMessenger.of(context)
//     ..hideCurrentSnackBar()
//     ..showSnackBar(
//       SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         duration: const Duration(milliseconds: 1000),
//         content: content,
//       ),
//     );
// }

void showAwesomeSnackBar(BuildContext context, ContentType snackBarContentType,
    String snackBarTitle, String snackBarMessage, Color snackBarColor) {
  final AnimationController controller = AnimationController(
    vsync: ScaffoldMessenger.of(context),
    duration: const Duration(milliseconds: 500),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: const Duration(milliseconds: 800),
        content: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.5, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: controller,
            curve: Curves.elasticOut,
          )),
          child: SizedBox(
            width: double.infinity,
            child: AwesomeSnackbarContent(
              color: snackBarColor,
              contentType: snackBarContentType,
              title: snackBarTitle,
              titleFontSize: 16.sp,
              message: snackBarMessage,
              messageFontSize: 12.sp,
            ),
          ),
        ),
      ),
    );

  controller.forward();

  controller.addStatusListener((status) {
    if (status == AnimationStatus.dismissed) {
      controller.dispose();
    }
  });
  
}


