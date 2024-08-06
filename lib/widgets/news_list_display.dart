import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/image_loader.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class NewsListArticleItem extends ConsumerWidget {
  final Object imageHeroTag;
  final String articleImageUrlString;
  final String articleTitle;
  final String articleSource;
  final String articleReleaseDate;
  final void Function() articleDetailsTapAction;

  const NewsListArticleItem({
    super.key,
    required this.imageHeroTag,
    required this.articleImageUrlString,
    required this.articleTitle,
    required this.articleSource,
    required this.articleReleaseDate,
    required this.articleDetailsTapAction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // News Article Image
            Hero(
              tag: imageHeroTag,
              child: Container(
                width: 125.w,
                height: 110.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child:
                        ImageLoaderForOverlay(imageUrl: articleImageUrlString)),
              ),
            ),
          ],
        ),
        15.sbW,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              // News Article Title
              articleTitle.txtStyled(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
              3.sbH,
              Row(
  children: [
    PhosphorIconsBold.tag.iconslide(size: 18.sp),
    7.sbW,
    Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Palette.blackColor,
          borderRadius: BorderRadius.circular(7.r),
        ),
        // News Article Category
        child: Padding(
          padding: 6.0.padA,
          child: Align(
            alignment: Alignment.centerLeft, // Align text to left
            child: articleSource.txtStyled(      
              fontSize: 14.sp,
              color: Palette.whiteColor,
              fontWeight: FontWeight.w600,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    ),
  ],
),

              3.sbH,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Article Publication Date
                  Row(
                    children: [
                      PhosphorIconsBold.paperPlaneTilt.iconslide(size: 18.sp),
                      7.sbW,
                      articleReleaseDate.txtStyled(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  5.sbW,
                  // More Options
                  PhosphorIconsBold.dotsThree
                      .iconslide(size: 27.sp)
                      .inkTap(
                        splashColor: Palette.greyColor.withOpacity(0.2),
                        onTap: articleDetailsTapAction),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
