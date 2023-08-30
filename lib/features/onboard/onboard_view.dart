import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/vinews_icons.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/vinews_app_texts.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_icon_buttons_icons.dart';

class OnboardView extends StatelessWidget {
  const OnboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only()
              .padSpec(left: 41, top: 56, right: 41, bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ViNewsAppImagesPath.onboardScreenImage.imageAsset(),
              20.sbH,
              ViNewsAppTexts.onboardScreenTitleText.txtStyled(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Pallete.appButtonColor,
                  textAlign: TextAlign.center),
              25.sbH,
              ViNewsAppTexts.onboardScreenDescriptionText.txtStyled(
                  fontSize: 16.sp,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w400,
                  color: Pallete.onboardDescTxtColor),
              90.sbH,
              ViNewsAppIconButton(
                onButtonPress: () {
                  context.goNamed(ViNewsAppRouteConstants.authIntializer);
                },
                buttonPlaceholderText: "Explore",
                suffixIcon: ViNewsIcons.onboardButtonIcon,
                isEnabled: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
