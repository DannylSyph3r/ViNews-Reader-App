import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/core/controllers/app_providers.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/widgets/frosted_glass_box.dart';
import 'package:vinews_news_reader/utils/vinews_app_texts.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class NewsInterestSelectionView extends ConsumerStatefulWidget {
  const NewsInterestSelectionView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewsInterestSelectionViewState();
}

class _NewsInterestSelectionViewState
    extends ConsumerState<NewsInterestSelectionView> {
  @override
  Widget build(BuildContext context) {
    final newsInterests = ref.watch(newsInterestSelectionProvider);
    final selectedNewsInterests = ref.watch(selectedNewsInterestsProvider);
    final isDialogOpen = ref.watch(dialogOpenProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Palette.blackColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Customize News Interests".txtStyled(fontSize: 18.sp),
            5.sbW,
            PhosphorIcons.regular.newspaper.iconslide(size: 19.sp),
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
          child: Stack(children: [
            Scrollbar(
              interactive: true,
              thickness: 6,
              radius: Radius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          30.sbH,
                          "Choose Your News Interests".txtStyled(
                              fontSize: 24.sp, fontWeight: FontWeight.w800),
                          15.sbH,
                          "Get better News Recommendations on your Home Screen"
                              .txtStyled(
                                  fontSize: 18.sp, textAlign: TextAlign.center),
                          50.sbH,
                          Wrap(
                            spacing: 15.w,
                            runSpacing: 25.h,
                            children:
                                List.generate(newsInterests.length, (index) {
                              final isSelected = selectedNewsInterests
                                  .contains(newsInterests[index]);
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 18.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Palette.blackColor
                                      : Palette.whiteColor,
                                  borderRadius: BorderRadius.circular(27.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    newsInterests[index].txtStyled(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800,
                                      color: isSelected
                                          ? Palette.whiteColor
                                          : Palette.blackColor,
                                    ),
                                  ],
                                ),
                              ).inkTap(onTap: () {
                                ref
                                    .read(
                                        selectedNewsInterestsProvider.notifier)
                                    .toggleInterest(newsInterests[index]);
                              });
                            }),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Divider(
                              color: Palette.blackColor, thickness: 1),
                          10.sbH,
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    ref
                                        .read(dialogOpenProvider.notifier)
                                        .update((state) => !state);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    fixedSize: Size(175.w, 62.w),
                                    backgroundColor: const Color.fromARGB(
                                        161, 237, 226, 226),
                                    side: BorderSide(
                                        width: 2.5.w,
                                        color: Palette.blackColor),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      "Skip".txtStyled(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w800,
                                        color: Palette.blackColor,
                                      ),
                                    ],
                                  ),
                                ),
                                17.sbW,
                                ElevatedButton(
                                  onPressed: selectedNewsInterests.isEmpty
                                      ? null
                                      : () {
                                          print(selectedNewsInterests);
                                        },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    fixedSize: Size(175.w, 62.w),
                                    backgroundColor: Palette.blackColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      "Save".txtStyled(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
            Positioned.fill(
              child: Visibility(
                visible: isDialogOpen,
                child: FrostedGlassBox(
                  theWidth: MediaQuery.of(context).size.width,
                  theHeight: MediaQuery.of(context).size.height,
                  theChild: AlertDialog(
                    backgroundColor: Palette.whiteColor.withOpacity(0.8),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PhosphorIcons.regular.warningCircle.iconslide(),
                        7.sbW,
                        "Confirm Action".txtStyled(
                            fontSize: 22.sp, fontWeight: FontWeight.bold),
                      ],
                    ),
                    content: ViNewsAppTexts.newsInterestsSkipDialogWarningText
                        .txtStyled(
                            textAlign: TextAlign.justify, fontSize: 19.sp),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          ref
                              .read(dialogOpenProvider.notifier)
                              .update((state) => !state);
                        },
                        child: "Cancel".txtStyled(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Palette.blackColor),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(dialogOpenProvider.notifier)
                              .update((state) => !state);
                          Navigator.of(context).pop();
                        },
                        child: "Yes, I'm sure!".txtStyled(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Palette.blackColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ])),
    );
  }
}
