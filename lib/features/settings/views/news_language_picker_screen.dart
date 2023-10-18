import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/settings/controller/language_list_controller.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class NewsLanguageSelectorView extends ConsumerWidget {
  const NewsLanguageSelectorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageOptions = ref.read(languageProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.blackColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "News Language".txtStyled(fontSize: 18.sp),
            5.sbW,
            PhosphorIcons.regular.globe.iconslide(size: 19.sp),
          ],
        ),
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
            child: ListView(
                cacheExtent: 100,
                physics: const BouncingScrollPhysics(),
                children: [
                  Center(
                      child: Padding(
                    padding: 25.0.padA,
                    child: Column(
                      children: [
                        "Select a Language you would like to view your news in..."
                            .txtStyled(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.center),
                        30.sbH,
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: languageOptions.length,
                            itemBuilder: (BuildContext context, int index) {
                              final languageTileLayout = languageOptions[index];
                              return ListTile(
                                contentPadding: 5.padV,
                                leading: languageTileLayout.flag,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    languageTileLayout.name.txtStyled(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp),
                                    7.sbH,
                                    languageTileLayout.code.txtStyled()
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  )),
                ]),
          )),
    );
  }
}
