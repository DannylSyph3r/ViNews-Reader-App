import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/image_loader.dart';
import 'package:vinews_news_reader/utils/size_constraints_defs.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/frosted_glass_box.dart';

class NewsDetailsFrostedOverlayDisplay extends ConsumerWidget {
  final Object imageHeroTag;
  final String articleImageUrlString;
  final String articleTitle;
  final String articleDescription;
  final String articleCategory;
  final String articleSource;
  final String articleReleaseDate;
  final void Function() backButtonTap;
  final void Function() readButtonTap;

  const NewsDetailsFrostedOverlayDisplay({
    super.key,
    required this.imageHeroTag,
    required this.articleImageUrlString,
    required this.articleTitle,
    required this.articleDescription,
    required this.articleCategory,
    required this.articleSource,
    required this.articleReleaseDate,
    required this.backButtonTap,
    required this.readButtonTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FrostedGlassBox(
        theWidth: width(context),
        theHeight: height(context),
        theChildAlignment: MainAxisAlignment.center,
        theChild: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
          child: Container(
            height: 590.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Palette.greyColor.withOpacity(0.75),
              image: const DecorationImage(
                image: AssetImage(ViNewsAppImagesPath.appBackgroundImage),
                opacity: 0.15,
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: 15.0.padA,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    articleTitle.txtStyled(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w700,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis),
                    articleDescription.txtStyled(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        maxLines: 3,
                        textOverflow: TextOverflow.ellipsis),
                    Hero(
                      tag: imageHeroTag,
                      child: Container(
                        width: double.infinity,
                        height: 150.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          // color: Palette.greyColor,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: ImageLoaderForOverlay(
                                imageUrl: articleImageUrlString)),
                      ),
                    ),
                    Column(
                      children: [
                        5.sbH,
                        const Divider(
                          thickness: 1.5,
                        ),
                        5.sbH
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            PhosphorIcons.bold.megaphone.iconslide(size: 18.sp),
                            7.sbW,
                            articleSource.txtStyled(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            PhosphorIcons.bold.clockCountdown
                                .iconslide(size: 19.sp),
                            5.sbW,
                            "10 mins".txtStyled(
                                fontSize: 18.sp, fontWeight: FontWeight.w500)
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                PhosphorIcons.bold.tag.iconslide(size: 18.sp),
                                7.sbW,
                                Container(
                                  decoration: BoxDecoration(
                                    color: Palette.blackColor,
                                    borderRadius: BorderRadius.circular(7.r),
                                  ),
                                  // News Article Category
                                  child: Padding(
                                    padding: 7.0.padA,
                                    child: articleCategory
                                        .txtStyled(
                                      fontSize: 14.sp,
                                      color: Palette.whiteColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            5.sbH,
                            Row(
                              children: [
                                PhosphorIcons.bold.paperPlaneTilt
                                    .iconslide(size: 18.sp),
                                7.sbW,
                                articleReleaseDate.txtStyled(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            PhosphorIcons.bold.bookmarks.iconslide(size: 35.sp),
                            5.sbW,
                            PhosphorIcons.bold.heartStraight
                                .iconslide(size: 35.sp)
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        5.sbH,
                        const Divider(
                          thickness: 1.5,
                        ),
                        5.sbH
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: backButtonTap,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            fixedSize: Size(110.w, 45.w),
                            backgroundColor:
                                const Color.fromARGB(161, 237, 226, 226),
                            side: BorderSide(
                                width: 2.5.w, color: Palette.blackColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              "Back".txtStyled(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: Palette.blackColor,
                              ),
                            ],
                          ),
                        ),
                        17.sbW,
                        ElevatedButton(
                          onPressed: readButtonTap,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            fixedSize: Size(110.w, 45.w),
                            backgroundColor: Palette.blackColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              "Read".txtStyled(
                                fontSize: 15.sp,
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
        ));
  }
}
