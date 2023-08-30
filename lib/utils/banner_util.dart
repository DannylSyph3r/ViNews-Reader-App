import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

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
                    color: Pallete.whiteColor),
                13.sbH,
                bannerMessage.txtStyled(
                    fontSize: 14.sp, color: Pallete.whiteColor),
                5.sbH
              ],
            ),
          ),
        ),
        backgroundColor: bannerColor,
        padding: 20.0.padA,
        leading: Icon(
          PhosphorIcons.bold.warningOctagon,
          color: Pallete.whiteColor,
        ),
        leadingPadding: const EdgeInsets.only(right: 25),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              controller.reverse();
            },
            child: Icon(
              PhosphorIcons.bold.x,
              color: Pallete.whiteColor,
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

