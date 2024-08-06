import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vinews_news_reader/core/models/news_response.dart';
import 'package:vinews_news_reader/features/home/notifiers/articles_notifier.dart';
import 'package:vinews_news_reader/core/providers/app_providers.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/vinews_app_texts.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
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
  final ValueNotifier<int> _homeOverlayDisplayNotifier = 0.notifier;

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
      return const Icon(PhosphorIconsRegular.sunHorizon,
          color: Palette.whiteColor);
    } else if (currentTime >= 12 && currentTime < 16) {
      return const Icon(PhosphorIconsRegular.sun, color: Palette.whiteColor);
    } else if (currentTime >= 16 && currentTime < 19) {
      return const Icon(PhosphorIconsRegular.sunDim, color: Palette.whiteColor);
    } else if (currentTime >= 19 && currentTime < 22) {
      return const Icon(PhosphorIconsRegular.moon, color: Palette.whiteColor);
    } else {
      return const Icon(PhosphorIconsRegular.moonStars,
          color: Palette.whiteColor);
    }
  }

  String formatDateString(String dateString) {
    final originalDate = DateTime.parse(dateString);
    final formattedDate = DateFormat('E d MMM, y').format(originalDate);
    return formattedDate;
  }

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
    _homeOverlayDisplayNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String gretting = _getGreeting();
    final Icon greetingIcon = _greetingIcon();
    final bool isOverlayActive = ref.watch(homeScreenOverlayActiveProvider);
    AsyncValue<List<Article>> articleData = ref.watch(homeArticlesListProvider);
    // final isLoading = ref.watch(isLoadingArticlesProvider);
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
                    PhosphorIconsRegular.house
                        .iconslide(color: Palette.whiteColor),
                    10.sbW,
                    "Home".txtStyled(
                        color: Palette.whiteColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600),
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
                                      color: Palette.whiteColor,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                ],
                              )
                            : Row(
                                children: [
                                  PhosphorIconsFill.calendarBlank
                                      .iconslide(color: Palette.whiteColor),
                                  10.sbW,
                                  formatDateString(DateTime.now().toString())
                                      .txtStyled(
                                          color: Palette.whiteColor,
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
                              PhosphorIconsFill.newspaperClipping
                                  .iconslide(size: 24.sp),
                            ],
                          ),
                        ),

                        // News List View via ListView.builder
                        15.sbH,
                        articleData.when(data: (List<Article> articleData) {
                          return ListView.builder(
                            cacheExtent: 100,
                            //Zero Padding Needed just needed to offset default value
                            padding: 0.padV,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: articleData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 13.h, horizontal: 25.w),
                                child: NewsListArticleItem(
                                    imageHeroTag: 'homeScreentagImage$index',
                                    articleImageUrlString: articleData[index]
                                            .urlToImage ??
                                        ViNewsAppImagesPath.defaultArticleImage,
                                    articleTitle: articleData[index].title,
                                    articleSource:
                                        articleData[index].source.name,
                                    articleReleaseDate: formatDateString(
                                        articleData[index]
                                            .publishedAt
                                            .toString()),
                                    articleDetailsTapAction: () {
                                      //Update ValueNotifer with Selected Index
                                      _homeOverlayDisplayNotifier.value = index;
                                      ref
                                          .read(homeScreenOverlayActiveProvider
                                              .notifier)
                                          .update((state) => !state);
                                    }).inkTap(
                                  splashColor:
                                      Palette.greyColor.withOpacity(0.2),
                                  onTap: () {
                                    context.pushNamed(
                                      ViNewsAppRouteConstants
                                          .newsArticleReadView,
                                      pathParameters: {
                                        "articleImage":
                                            articleData[index].urlToImage ??
                                                ViNewsAppImagesPath
                                                    .defaultArticleImage,
                                        "articleSource":
                                            articleData[index].source.name,
                                        "heroTag": 'homeScreentagImage$index',
                                        "articleTitle":
                                            articleData[index].title,
                                        "articleAuthor":
                                            articleData[index].author ??
                                                'No Author Mentioned',
                                        "articlePublicationDate":
                                            formatDateString(articleData[index]
                                                .publishedAt
                                                .toString()),
                                        "articleContent":
                                            articleData[index].content ??
                                                ViNewsAppTexts
                                                    .placeHolderArticleContent,
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }, error: (Object error, StackTrace stackTrace) {
                          return MotionToast(
                              animationType: AnimationType.fromBottom,
                              animationDuration: 300.milliseconds,
                              toastDuration: 10.seconds,
                              position: MotionToastPosition.bottom,
                              borderRadius: 25.r,
                              dismissable: true,
                              displaySideBar: false,
                              animationCurve: Curves.easeIn,
                              layoutOrientation: ToastOrientation.ltr,
                              primaryColor: Palette.appButtonColor,
                              secondaryColor: Palette.greenColor,
                              backgroundType: BackgroundType.transparent,
                              description: "Failed to Load Articles"
                                  .txtStyled(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.whiteColor,
                                      textAlign: TextAlign.center)
                                  .alignCenter(),
                              padding: EdgeInsets.all(10.h));
                        }, loading: () {
                          return ListView.separated(
                            cacheExtent: 100,
                            //Zero Padding Needed just needed to offset default value
                            padding: 0.padV,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 20,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              // Return a SizedBox with desired height as separator
                              return 15.sbH;
                            },
                            itemBuilder: (BuildContext context, int index) {
                              // Return your shimmer loader widget
                              return getShimmerLoader();
                            },
                          );
                        }),

                        20.sbH,
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
                  child: _homeOverlayDisplayNotifier.sync(builder:
                      (BuildContext context, int displayValue, Widget? child) {
                    final List<Article> articleOverlayDisplay = articleData.maybeWhen(
                      data: (articles) => articles ,
                      orElse: () => []);

                    if(articleOverlayDisplay.isEmpty){
                      return const SizedBox();
                    } else {
                    return NewsDetailsFrostedOverlayDisplay(
                        imageHeroTag: 'homeScreenOverlaytagImage$displayValue',
                        articleImageUrlString:
                            articleOverlayDisplay[displayValue].urlToImage ??
                                ViNewsAppImagesPath.defaultArticleImage,
                        articleTitle: articleOverlayDisplay[displayValue].title,
                        articleDescription: articleOverlayDisplay[displayValue].description ??
                            "No description attached",
                        articleSource: articleOverlayDisplay[displayValue].source.name,
                        articleReleaseDate: formatDateString(
                            articleOverlayDisplay[displayValue].publishedAt.toString()),
                        backButtonTap: () {
                          ref
                              .read(homeScreenOverlayActiveProvider.notifier)
                              .update((state) => !state);
                        },
                        readButtonTap: () {
                          context.pushNamed(
                            ViNewsAppRouteConstants.newsArticleReadView,
                            pathParameters: {
                              "articleImage":
                                  articleOverlayDisplay[displayValue].urlToImage ??
                                      ViNewsAppImagesPath.defaultArticleImage,
                              "articleSource":
                                  articleOverlayDisplay[displayValue].source.name,
                              "heroTag":
                                  'homeScreenOverlaytagImage$displayValue',
                              "articleTitle": articleOverlayDisplay[displayValue].title,
                              "articleAuthor": articleOverlayDisplay[displayValue].author ??
                                  'No Author Mentioned',
                              "articlePublicationDate": formatDateString(
                                  articleOverlayDisplay[displayValue].publishedAt.toString()),
                              "articleContent": articleOverlayDisplay[displayValue].content ??
                                  ViNewsAppTexts.placeHolderArticleContent,
                            },
                          );
                        });
                    }
                  }),
                )),
                
          ]),
        ),
      ),
    );
  }

  Shimmer getShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Palette.greyColor,
      highlightColor: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: 25.padH,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Shimmer News Article Image
                Container(
                  width: 125.w, // Adjust width as needed
                  height: 110.h, // Adjust height as needed
                  decoration: BoxDecoration(
                    color: Palette.greyColor, // Use a shimmer color
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ],
            ),
            15.sbW, // Adjust spacing as needed
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Shimmer News Article Title
                  Container(
                    width: double.infinity,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Palette.greyColor,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                  ),
                  7.sbH,
                  Row(
                    children: [
                      Row(
                        children: [
                          // Shimmer Tag Icon
                          Container(
                            width: 24.w,
                            height: 24.h,
                            color: Palette.greyColor,
                          ),
                          7.sbW,
                          Container(
                            width: 100.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: Palette.greyColor,
                              borderRadius: BorderRadius.circular(7.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  5.sbH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Shimmer Date Icon
                          Container(
                            width: 24.w,
                            height: 24.h,
                            color: Palette.greyColor,
                          ),
                          7.sbW,
                          Container(
                            width: 100.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: Palette.greyColor,
                              borderRadius: BorderRadius.circular(7.r),
                            ),
                          ),
                        ],
                      ),
                      5.sbW,
                      // Shimmer More Options Icon
                      Container(
                        width: 27.w,
                        height: 27.h,
                        decoration: BoxDecoration(
                          color: Palette.greyColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
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
  }
}
