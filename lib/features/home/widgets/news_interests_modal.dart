import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/home/controllers/news_interest_controller.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/frosted_glass_box.dart';
import 'package:vinews_news_reader/utils/vinews_app_texts.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class NewsInterestsModal extends ConsumerStatefulWidget {
  const NewsInterestsModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewsInterestsModalState();
}

class _NewsInterestsModalState extends ConsumerState<NewsInterestsModal> {
  @override
  Widget build(BuildContext context) {
    final newsInterests = ref.watch(newsInterestSelectionProvider);
    final selectedNewsInterests = ref.watch(selectedNewsInterestsProvider);
    final isDialogOpen = ref.watch(dialogOpenProvider);
    return GestureDetector(
      onVerticalDragDown: (_) {},
      child: Stack(
        children: [
          Container(
            height: 875.h,
            decoration: BoxDecoration(
                color: Pallete.greyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                )),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Column(children: [
                Container(
                  height: 5,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey),
                ),
                40.sbH,
                "Choose Your News Interests"
                    .txtStyled(fontSize: 28.sp, fontWeight: FontWeight.w800),
                15.sbH,
                "Get better News Recommendations".txtStyled(fontSize: 20.sp),
                40.sbH,
                Padding(
                  padding: 23.padH,
                  child: Wrap(
                    spacing: 16.w,
                    runSpacing: 20.h,
                    children: List.generate(newsInterests.length, (index) {
                      final isSelected =
                          selectedNewsInterests.contains(newsInterests[index]);
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Pallete.appButtonColor
                              : Pallete.whiteColor,
                          borderRadius: BorderRadius.circular(27.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            newsInterests[index].txtStyled(
                              fontSize: 18.5.sp,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? Pallete.whiteColor
                                  : Pallete.appButtonColor,
                            ),
                          ],
                        ),
                      ).onTap(() {
                        ref
                            .read(selectedNewsInterestsProvider.notifier)
                            .toggleInterest(newsInterests[index]);
                      });
                    }),
                  ),
                ),
                315.sbH,
                const Divider(color: Pallete.blackColor),
                15.sbH,
                Row(
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
                        backgroundColor:
                            const Color.fromARGB(161, 237, 226, 226),
                        side: BorderSide(
                            width: 2.5.w, color: Pallete.appButtonColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "Skip".txtStyled(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: Pallete.appButtonColor,
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
                        backgroundColor: Pallete.appButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "Next".txtStyled(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
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
                  backgroundColor: Pallete.whiteColor.withOpacity(0.8),
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
                      .txtStyled(textAlign: TextAlign.justify, fontSize: 19.sp),
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
                          color: Pallete.appButtonColor),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(dialogOpenProvider.notifier)
                            .update((state) => !state);
                        GoRouter.of(context).pop();
                      },
                      child: "Yes, I'm sure!".txtStyled(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Pallete.appButtonColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
