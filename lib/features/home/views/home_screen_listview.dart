import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/core/models/article_selections.dart';
import 'package:vinews_news_reader/core/provider/app_providers.dart';
import 'package:vinews_news_reader/features/settings/views/user_account_view.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/frosted_glass_box.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class UserHomePageView extends ConsumerStatefulWidget {
  const UserHomePageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserHomePageViewState();
}

class _UserHomePageViewState extends ConsumerState<UserHomePageView> {
  final ValueNotifier<int> _selectedOptionIndexValueNotifier =
      ValueNotifier<int>(0);
  String formattedDate = DateFormat('E d MMM, y').format(DateTime.now());

  @override
  void initState() {
    _selectedOptionIndexValueNotifier.value = 0;
    super.initState();
  }

  @override
  void dispose() {
    _selectedOptionIndexValueNotifier.dispose();
    super.dispose();
  }

  // User Greetings on AppBar
  String _getGreeting() {
    final DateTime now = DateTime.now();
    final int currentTime = now.hour;

    if (currentTime >= 0 && currentTime < 12) {
      return 'Good Morning';
    } else if (currentTime >= 12 && currentTime < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Icon _greetingIcon() {
    final DateTime now = DateTime.now();
    final int currentTime = now.hour;

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
    final String gretting = _getGreeting();
    final Icon greetingIcon = _greetingIcon();
    final bool isOverlayActive = ref.watch(homeScreenOverlayActiveProvider);
    return Scaffold(
      body: NestedScrollView(
        physics: isOverlayActive ? const NeverScrollableScrollPhysics() : null,
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
              image: AssetImage(ViNewsAppImagesPath.appBackgroundImage),
              opacity: 0.15,
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(children: [
            Scrollbar(
              interactive: true,
              thickness: 6,
              radius: Radius.circular(12.r),
              child: SingleChildScrollView(
                physics: isOverlayActive
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                child: Padding(
                  padding: 30.padV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: 25.padH,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Placeholder text above News List View
                            Row(
                              children: [
                                "Latest News for You".txtStyled(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w500),
                                5.sbW,
                                PhosphorIcons.bold.newspaperClipping
                                    .iconslide(size: 24.sp),
                              ],
                            ),
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
                        itemCount: articleDisplayList.length,
                        // The number of times you want to duplicate the widget
                        itemBuilder: (BuildContext context, int index) {
                          ArticleSelections articleDisplay =
                              articleDisplayList[index];
                          return Padding(
                            padding: const EdgeInsets.only().padSpec(
                                top: 13, bottom: 13, right: 25, left: 25),
                            child: GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                    ViNewsAppRouteConstants.newsArticleReadView,
                                    pathParameters: {
                                      "articleImage": articleDisplay.urlImage,
                                      "articleCategory":
                                          articleDisplay.articleCategory,
                                      "heroTag": 'homeScreentagImage$index',
                                      "articleTitle":
                                          articleDisplay.articleTitle,
                                      "articleAuthor":
                                          articleDisplay.articleCategory,
                                      "articlePublicationDate":
                                          formattedDate.toString()
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
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            child: CachedNetworkImage(
                                              key: UniqueKey(),
                                              imageUrl: articleDisplay.urlImage,
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
                                        articleDisplay.articleTitle.txtStyled(
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
                                                    color: Pallete.blackColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.r),
                                                  ),
                                                  // News Article Category
                                                  child: Padding(
                                                    padding: 6.0.padA,
                                                    child: articleDisplay
                                                        .articleCategory
                                                        .txtStyled(
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
                                                    .bold.paperPlaneTilt
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
                                            GestureDetector(
                                              onTap: () {
                                                // Update the ValueNotifier with the index of the selected news article for the overlay.
                                                _selectedOptionIndexValueNotifier
                                                    .value = index;
                                                ref
                                                    .read(
                                                        homeScreenOverlayActiveProvider
                                                            .notifier)
                                                    .update((state) => !state);
                                              },
                                              child: PhosphorIcons
                                                  .bold.dotsThree
                                                  .iconslide(size: 27.sp),
                                            ),
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
            // News Article Frosted Glass Preview Overlay
            AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: isOverlayActive ? 1 : 0,
                child: Visibility(
                  visible: isOverlayActive,
                  child: ValueListenableBuilder(
                      valueListenable: _selectedOptionIndexValueNotifier,
                      builder:
                          (BuildContext context, int value, Widget? child) {
                        ArticleSelections articleOverlayDisplay =
                            articleDisplayList[
                                _selectedOptionIndexValueNotifier.value];
                        return FrostedGlassBox(
                            theWidth: MediaQuery.of(context).size.width,
                            theHeight: MediaQuery.of(context).size.height,
                            theChildAlignment: MainAxisAlignment.end,
                            theChild: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.w, vertical: 15.h),
                              child: Container(
                                height: 590.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Pallete.greyColor.withOpacity(0.75),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        ViNewsAppImagesPath.appBackgroundImage),
                                    opacity: 0.15,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Padding(
                                  padding: 15.0.padA,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        articleOverlayDisplay.articleTitle
                                            .txtStyled(
                                                fontSize: 25.sp,
                                                fontWeight: FontWeight.w700,
                                                maxLines: 2,
                                                textOverflow:
                                                    TextOverflow.ellipsis),
                                        articleOverlayDisplay.articleDescription
                                            .txtStyled(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w500,
                                                maxLines: 3,
                                                textOverflow:
                                                    TextOverflow.ellipsis),
                                        Hero(
                                          tag:
                                              'homeScreenOverlaytagImage${_selectedOptionIndexValueNotifier.value}',
                                          child: Container(
                                            width: double.infinity,
                                            height: 150.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              // color: Pallete.greyColor,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              child: CachedNetworkImage(
                                                imageUrl: articleOverlayDisplay
                                                    .urlImage,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                PhosphorIcons.bold.megaphone
                                                    .iconslide(size: 18.sp),
                                                7.sbW,
                                                articleOverlayDisplay
                                                    .articleSource
                                                    .txtStyled(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                PhosphorIcons
                                                    .bold.clockCountdown
                                                    .iconslide(size: 19.sp),
                                                5.sbW,
                                                "10 mins".txtStyled(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w500)
                                              ],
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    PhosphorIcons.bold.tag
                                                        .iconslide(size: 18.sp),
                                                    7.sbW,
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Pallete.blackColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.r),
                                                      ),
                                                      // News Article Category
                                                      child: Padding(
                                                        padding: 7.0.padA,
                                                        child:
                                                            articleOverlayDisplay
                                                                .articleCategory
                                                                .txtStyled(
                                                          fontSize: 14.sp,
                                                          color: Pallete
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                5.sbH,
                                                Row(
                                                  children: [
                                                    PhosphorIcons
                                                        .bold.paperPlaneTilt
                                                        .iconslide(size: 18.sp),
                                                    7.sbW,
                                                    formattedDate.txtStyled(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                PhosphorIcons.bold.bookmarks
                                                    .iconslide(size: 35.sp),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                ref
                                                    .read(
                                                        homeScreenOverlayActiveProvider
                                                            .notifier)
                                                    .update((state) => !state);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                fixedSize: Size(110.w, 45.w),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        161, 237, 226, 226),
                                                side: BorderSide(
                                                    width: 2.5.w,
                                                    color: Pallete.blackColor),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(11),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  "Back".txtStyled(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w800,
                                                    color: Pallete.blackColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            17.sbW,
                                            ElevatedButton(
                                              onPressed: () {
                                                context.pushNamed(
                                                    ViNewsAppRouteConstants
                                                        .newsArticleReadView,
                                                    pathParameters: {
                                                      "articleImage":
                                                          articleOverlayDisplay
                                                              .urlImage,
                                                      "articleCategory":
                                                          articleOverlayDisplay
                                                              .articleCategory,
                                                      "heroTag":
                                                          'homeScreenOverlaytagImage${_selectedOptionIndexValueNotifier.value}',
                                                      "articleTitle":
                                                          articleOverlayDisplay
                                                              .articleTitle,
                                                      "articleAuthor":
                                                          articleOverlayDisplay
                                                              .articleCategory,
                                                      "articlePublicationDate":
                                                          formattedDate
                                                              .toString()
                                                    });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                fixedSize: Size(110.w, 45.w),
                                                backgroundColor:
                                                    Pallete.blackColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(11),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                      }),
                )),
          ]),
        ),
      ),
    );
  }

  void navigateToAccountSettingsPageFromHome(BuildContext context) {
    pushNewScreenWithRouteSettings(context,
        screen: const UserAccountSettingsView(),
        settings: const RouteSettings(name: "/accountSettings"));
  }
}
