import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class UserHomePageView extends ConsumerStatefulWidget {
  const UserHomePageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserHomePageViewState();
}

class _UserHomePageViewState extends ConsumerState<UserHomePageView> {
  String formattedDate = DateFormat('E d MMM, y').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          90.h,
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.7),
              titleSpacing: 30.sp,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(25.r), // Adjust the radius as needed
                  bottomRight:
                      Radius.circular(25.r), // Adjust the radius as needed
                ),
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.sbH,
                  "Good Morning, Konstantinos..".txtStyled(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  10.sbH,
                  formattedDate.txtStyled(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only().padSpec(right: 30, top: 12),
                  child: PhosphorIcons.fill.slideshow.iconslide(size: 35.sp),
                )
              ],
              elevation: 0,
            ),
          ),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/background.png",
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
            physics:const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                150.sbH,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          "News for You".txtStyled(
                              fontSize: 30.sp, fontWeight: FontWeight.w500),
                          5.sbW,
                          PhosphorIcons.bold.newspaperClipping
                              .iconslide(size: 30.sp),
                        ],
                      ),
                      PhosphorIcons.bold.dotsThree.iconslide(size: 30.sp)
                    ],
                  ),
                ),
                15.sbH,
                ListView.builder(
                  padding: 0
                      .padV, //Zero Padding Needed just needed to offset default value
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      20, // The number of times you want to duplicate the widget
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only()
                          .padSpec(top: 13, bottom: 13, right: 25, left: 25),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 125.w,
                                height: 110.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  // color: Pallete.greyColor,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.asset(
                                    "assets/images/news_6.jpg",
                                    fit: BoxFit.cover,
                                  ),
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
                                "Let’s settle the debate: IOS vs Androidz Consumer verdict"
                                    .txtStyled(
                                  fontSize: 21.sp,
                                  fontWeight: FontWeight.w700,
                                  maxLines: 2,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                                3.sbH,
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        PhosphorIcons.bold.tag
                                            .iconslide(size: 18.sp),
                                        7.sbW,
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Pallete.appButtonColor,
                                            borderRadius:
                                                BorderRadius.circular(7.r),
                                          ),
                                          child: Padding(
                                            padding: 7.0.padA,
                                            child: "Science".txtStyled(
                                              fontSize: 14.sp,
                                              color: Pallete.whiteColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                3.sbH,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        PhosphorIcons.bold.clockCountdown
                                            .iconslide(size: 18.sp),
                                        7.sbW,
                                        formattedDate.txtStyled(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    5.sbW,
                                    PhosphorIcons.bold.dotsThree
                                        .iconslide(size: 27.sp),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).onTap(() {
                        context.pushNamed(
                            ViNewsAppRouteConstants.newsArticleReadView);
                      }),
                    );
                  },
                ),
                20.sbH
              ],
            ),
          ),
        ),
      ),
    );
  }
}
