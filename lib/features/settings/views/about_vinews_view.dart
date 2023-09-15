import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class AboutViNewsView extends ConsumerStatefulWidget {
  const AboutViNewsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AboutViNewsViewState();
}

class _AboutViNewsViewState extends ConsumerState<AboutViNewsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.blackColor,
        elevation: 0,
        centerTitle: true,
        title: "About ViNews".txtStyled(fontSize: 18.sp),
      ),
      body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ViNewsAppImagesPath.appBackgroundImage,
              ),
              opacity: 0.15,
              fit: BoxFit.cover,
            ),
          ),
          child: Scrollbar(
            interactive: true,
            thickness: 6,
            radius: Radius.circular(12.r),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                  child: Padding(
                padding: 25.0.padA,
                child: const Column(
                  children: [],
                ),
              )),
            ),
          )),
    );
  }
}
