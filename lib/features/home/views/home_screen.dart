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

  // User Greetings on AppBar
  String _getGreeting() {
    final now = DateTime.now();
    final currentTime = now.hour;

    if (currentTime >= 0 && currentTime < 12) {
      return 'Good Morning';
    } else if (currentTime >= 12 && currentTime < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Icon _greetingIcon() {
    final now = DateTime.now();
    final currentTime = now.hour;

    if (currentTime >= 6 && currentTime < 12) {
      return Icon(PhosphorIcons.regular.sunHorizon);
    } else if (currentTime >= 12 && currentTime < 16) {
      return Icon(PhosphorIcons.regular.sun);
    } else if (currentTime >= 16 && currentTime < 19) {
      return Icon(PhosphorIcons.regular.sunDim);
    } else if (currentTime >= 19 && currentTime < 22) {
      return Icon(PhosphorIcons.regular.moon);
    } else {
      return Icon(PhosphorIcons.regular.moonStars);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gretting = _getGreeting();
    final greetingIcon = _greetingIcon();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              toolbarHeight: 90.h,
              backgroundColor: Pallete.blackColor,
              elevation: 0,
              titleSpacing: 0,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                // Show Page Title
                child: Row(
                  children: [
                    PhosphorIcons.regular.house.iconslide(),
                    10.sbW,
                    "Home".txtStyled(
                        fontSize: 24.sp, fontWeight: FontWeight.w600),
                  ],
                ),
              ),
              bottom: AppBar(
                toolbarHeight: 90.h,
                backgroundColor: Pallete.blackColor,
                titleSpacing: 0,
                // Show Greeting along with user firstname
                title: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        reverseDuration: const Duration(milliseconds: 400),
                        child: innerBoxIsScrolled
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  greetingIcon,
                                  10.sbW,
                                  "$gretting, SlethWare".txtStyled(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                ],
                              )
                            : Row(
                                children: [
                                  PhosphorIcons.regular.calendarBlank
                                      .iconslide(),
                                  10.sbW,
                                  formattedDate.txtStyled(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                ],
                              ))),
                actions: [
                  // Action button to switch to tab view
                  Padding(
                    padding: const EdgeInsets.only().padSpec(right: 30),
                    child: PhosphorIcons.fill.slideshow.iconslide(size: 30.sp),
                  )
                ],
              ),
              pinned: true,
              floating: true,
            )
          ];
        },
        // Background image // Offseted by NestedScrollView
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
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only().padSpec(top: 30, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Placeholder text above News List View
                          Row(
                            children: [
                              "Latest News for You".txtStyled(
                                  fontSize: 24.sp, fontWeight: FontWeight.w500),
                              5.sbW,
                              PhosphorIcons.bold.newspaperClipping
                                  .iconslide(size: 24.sp),
                            ],
                          ),
                          PhosphorIcons.bold.dotsThree.iconslide(size: 30.sp)
                        ],
                      ),
                    ),
                    // News List View via ListView.builder
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
                          padding: const EdgeInsets.only().padSpec(
                              top: 13, bottom: 13, right: 25, left: 25),
                          child: GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                  ViNewsAppRouteConstants.newsArticleReadView,
                                  pathParameters: {
                                    "articleImage": "assets/images/news_6.jpg",
                                    "heroTag": 'homeScreentagImage$index'
                                  });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // News Article Image
                                    Hero(
                                      tag: 'homeScreentagImage$index',
                                      child: Container(
                                        width: 125.w,
                                        height: 110.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          // color: Pallete.greyColor,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          child: Image.asset(
                                            "assets/images/news_6.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                15.sbW,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      // News Article Title
                                      "Let’s settle the debate: IOS vs Androidz Consumer verdict"
                                          .txtStyled(
                                        fontSize: 20.sp,
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
                                                  color:
                                                      Pallete.appButtonColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.r),
                                                ),
                                                // News Article Category
                                                child: Padding(
                                                  padding: 6.0.padA,
                                                  child: "Science".txtStyled(
                                                    fontSize: 14.sp,
                                                    color: Pallete.whiteColor,
                                                    fontWeight:
                                                        FontWeight.w600,
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
                                          // Article Publication Date
                                          Row(
                                            children: [
                                              PhosphorIcons
                                                  .bold.clockCountdown
                                                  .iconslide(size: 18.sp),
                                              7.sbW,
                                              formattedDate.txtStyled(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                          5.sbW,
                                          // More Options
                                          PhosphorIcons.bold.dotsThree
                                              .iconslide(size: 27.sp),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    20.sbH
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
