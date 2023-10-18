import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/core/models/article_selections.dart';
import 'package:vinews_news_reader/core/controllers/app_providers.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/widgets/custom_sliver_app_bar.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/news_details_overlay.dart';
import 'package:vinews_news_reader/widgets/news_list_display.dart';
import 'package:vinews_news_reader/widgets/scaffold_background_body.dart';

class UserHomePageView extends ConsumerStatefulWidget {
  final VoidCallback showNavBar;
  final VoidCallback hideNavBar;
  const UserHomePageView(
      {super.key, required this.showNavBar, required this.hideNavBar});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserHomePageViewState();
}

class _UserHomePageViewState extends ConsumerState<UserHomePageView> {
  final ScrollController _homeScrollController = ScrollController();
  final ValueNotifier<int> _overlayDisplayNotifier = 0.notifier;
  String formattedDate = DateFormat('E d MMM, y').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _homeScrollController.addListener(() {
      if (_homeScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavBar();
      } else {
        widget.hideNavBar();
      }
    });
  }

  @override
  void dispose() {
    _homeScrollController.removeListener(() {
      if (_homeScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavBar();
      } else {
        widget.hideNavBar();
      }
    });
    _overlayDisplayNotifier.dispose();
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

  // Greeting Icon based on Time of Day
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
        controller: _homeScrollController,
        physics: isOverlayActive ? const NeverScrollableScrollPhysics() : null,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CustomSliverAppBar(
              isPinned: true,
              canStretch: true,
              isFloating: true,
              appBarColor: Palette.blackColor,
              customizeLeadingWidget: false,
              showLeadingIconOrWidget: false,
              isTitleText: false,
              titleWidget: Padding(
                padding: 30.padH,

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
              sliverBottom: AppBar(
                toolbarHeight: 90.h,
                backgroundColor: Palette.blackColor,
                titleSpacing: 0,

                // Show Greeting along with user firstname
                title: Padding(
                    padding: 30.padH,
                    child: AnimatedSwitcher(
                        duration: 1.seconds,
                        reverseDuration: 1.seconds,
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
                                  PhosphorIcons.fill.calendarBlank
                                      .iconslide(),
                                  10.sbW,
                                  formattedDate.txtStyled(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                ],
                              ))),
              ),
            )
          ];
        },

        // Background image // Offseted by NestedScrollView
        body: ScaffoldBackgroundedBody(
          theChild: Stack(children: [
            Scrollbar(
              interactive: true,
              thickness: 6,
              radius: Radius.circular(12.r),
              child: ListView(
                  physics: isOverlayActive
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: 25.padH,
                          child: Row(
                            children: [
                              // Placeholder text above News List View
                              "Latest News for You".txtStyled(
                                  fontSize: 22.sp, fontWeight: FontWeight.w500),
                              5.sbW,
                              PhosphorIcons.fill.newspaperClipping
                                  .iconslide(size: 24.sp),
                            ],
                          ),
                        ),

                        // News List View via ListView.builder
                        15.sbH,
                        ListView.builder(
                          cacheExtent: 100,
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 13.h, horizontal: 25.w),
                              child: NewsListArticleItem(
                                  imageHeroTag: 'homeScreentagImage$index',
                                  articleImageUrlString:
                                      articleDisplay.urlImage,
                                  articleTitle: articleDisplay.articleTitle,
                                  articleCategory:
                                      articleDisplay.articleCategory,
                                  articleReleaseDate: formattedDate,
                                  articleDetailsTapAction: () {
                                    //Update ValueNotifer with Selected Index
                                    _overlayDisplayNotifier.value = index;
                                    ref
                                        .read(homeScreenOverlayActiveProvider
                                            .notifier)
                                        .update((state) => !state);
                                  }).inkTap(
                                    splashColor: Palette.greyColor.withOpacity(0.2),
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
                                      "articlePublicationDate": formattedDate
                                    });
                              }),
                            );
                          },
                        ),
                        20.sbH
                      ],
                    ),
                  ]),
            ),

            // News Article Frosted Glass Preview Overlay
            AnimatedOpacity(
                duration: 400.milliseconds,
                opacity: isOverlayActive ? 1 : 0,
                child: Visibility(
                  visible: isOverlayActive,
                  child: _overlayDisplayNotifier.sync(builder:
                      (BuildContext context, int displayValue, Widget? child) {
                    ArticleSelections articleOverlayDisplay =
                        articleDisplayList[displayValue];
                    return NewsDetailsFrostedOverlayDisplay(
                        imageHeroTag: 'homeScreenOverlaytagImage$displayValue',
                        articleImageUrlString: articleOverlayDisplay.urlImage,
                        articleTitle: articleOverlayDisplay.articleTitle,
                        articleDescription:
                            articleOverlayDisplay.articleDescription,
                        articleCategory: articleOverlayDisplay.articleCategory,
                        articleSource: articleOverlayDisplay.articleSource,
                        articleReleaseDate: formattedDate,
                        backButtonTap: () {
                          ref
                              .read(homeScreenOverlayActiveProvider.notifier)
                              .update((state) => !state);
                        },
                        readButtonTap: () {
                          context.pushNamed(
                              ViNewsAppRouteConstants.newsArticleReadView,
                              pathParameters: {
                                "articleImage": articleOverlayDisplay.urlImage,
                                "articleCategory":
                                    articleOverlayDisplay.articleCategory,
                                "heroTag":
                                    'homeScreenOverlaytagImage${_overlayDisplayNotifier.value}',
                                "articleTitle":
                                    articleOverlayDisplay.articleTitle,
                                "articleAuthor":
                                    articleOverlayDisplay.articleCategory,
                                "articlePublicationDate": formattedDate
                              });
                        });
                  }),
                )),
          ]),
        ),
      ),
    );
  }
}
