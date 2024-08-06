import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

void showMotionToast(
    BuildContext context, String toastTitle, String toastMessage) {
  MotionToast(
          animationType: AnimationType.fromLeft,
          animationDuration: 200.milliseconds,
          toastDuration: 2.seconds,
          position: MotionToastPosition.top,
          borderRadius: 25.r,
          dismissable: true,
          displaySideBar: true,
          animationCurve: Curves.easeIn,
          layoutOrientation: ToastOrientation.ltr,
          primaryColor: Palette.appButtonColor,
          secondaryColor: const Color.fromARGB(255, 192, 25, 13),
          backgroundType: BackgroundType.transparent,
          icon: PhosphorIconsBold.warningOctagon,
          iconSize: 25.sp,
          title: toastTitle.txtStyled(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Palette.whiteColor),
          description: toastMessage.txtStyled(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Palette.whiteColor),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h))
      .show(context);
}

void showBookmarkToast(BuildContext context, String toastMessage) {
  MotionToast(
          animationType: AnimationType.fromBottom,
          animationDuration: 200.milliseconds,
          toastDuration: 2.seconds,
          position: MotionToastPosition.bottom,
          borderRadius: 25.r,
          dismissable: true,
          displaySideBar: false,
          animationCurve: Curves.easeIn,
          layoutOrientation: ToastOrientation.ltr,
          primaryColor: Palette.appButtonColor,
          secondaryColor: Palette.greenColor,
          backgroundType: BackgroundType.transparent,
          description: toastMessage.txtStyled(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Palette.whiteColor,
              textAlign: TextAlign.center).alignCenter(),
          padding: EdgeInsets.all(10.h)
          )
      .show(context);
}

void showMaterialBanner(BuildContext context, String bannerTitle,
    String bannerMessage, Color bannerColor) {
  final AnimationController controller = AnimationController(
    vsync: ScaffoldMessenger.of(context),
    duration: const Duration(milliseconds: 1000),
  );

  ScaffoldMessenger.of(context)
    ..removeCurrentMaterialBanner()
    ..showMaterialBanner(
      MaterialBanner(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.sbH,
                bannerTitle.txtStyled(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Palette.whiteColor),
                13.sbH,
                bannerMessage.txtStyled(
                    fontSize: 14.sp, color: Palette.whiteColor),
                5.sbH
              ],
            ),
          ),
        ),
        backgroundColor: bannerColor,
        padding: 20.0.padA,
        leading: const Icon(
          PhosphorIconsBold.warningOctagon,
          color: Palette.whiteColor,
        ),
        leadingPadding: const EdgeInsets.only(right: 25),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              controller.reverse();
            },
            child: const Icon(
              PhosphorIconsBold.x,
              color: Palette.whiteColor,
              size: 22,
            ),
          ),
        ],
      ),
    );

  controller.forward();

  Future.delayed(const Duration(seconds: 2), () {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    controller.reverse();
  });

  controller.addStatusListener((status) {
    if (status == AnimationStatus.dismissed) {
      controller.dispose();
    }
  });
}
