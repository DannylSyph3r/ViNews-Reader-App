import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/core/providers/app_providers.dart';
import 'package:vinews_news_reader/features/home/notifiers/articles_notifier.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/image_loader.dart';
import 'package:vinews_news_reader/utils/vinews_app_texts.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/scaffold_background_body.dart';

class UserExploreView extends ConsumerStatefulWidget {
  final VoidCallback showNavBar;
  final VoidCallback hideNavBar;
  const UserExploreView({
    super.key,
    required this.showNavBar,
    required this.hideNavBar,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserExploreViewState();
}

class _UserExploreViewState extends ConsumerState<UserExploreView> {
  final ScrollController _exploreScrollController = ScrollController();
  final ValueNotifier<int> _exploreOverlayDisplayNotifier = 0.notifier;

  String formatDateString(String dateString) {
    final originalDate = DateTime.parse(dateString);
    final formattedDate = DateFormat('E d MMM, y').format(originalDate);
    return formattedDate;
  }

  @override
  void initState() {
    _exploreScrollController.addListener(() {
      if (_exploreScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavBar();
      } else {
        widget.hideNavBar();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _exploreScrollController.removeListener(() {
      if (_exploreScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavBar();
      } else {
        widget.hideNavBar();
      }
    });
    _exploreOverlayDisplayNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // News Interest provider for Interest Horizontal ListView
    final List newsInterests = ref.watch(newsInterestSelectionProvider);
    final bool isOverlayActive = ref.watch(exploreScreenOverlayActiveProider);
    return Scaffold(
      body: DefaultTabController(
        length: newsInterests.length,
        child: NestedScrollView(
          controller: _exploreScrollController,
          physics:
              isOverlayActive ? const NeverScrollableScrollPhysics() : null,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                toolbarHeight: 90.h,
                backgroundColor: Palette.blackColor,
                elevation: 0,
                titleSpacing: 0,
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  // Show Page Title
                  child: Row(
                    children: [
                      PhosphorIconsRegular.globeHemisphereWest
                          .iconslide(color: Palette.whiteColor),
                      10.sbW,
                      "Explore".txtStyled(
                          color: Palette.whiteColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only().padSpec(right: 30),
                    child: GestureDetector(
                        onTap: () => context.pushNamed(ViNewsAppRouteConstants
                            .userExploreSearchScreenRoute),
                        child: PhosphorIconsBold.magnifyingGlass
                            .iconslide(color: Palette.whiteColor)),
                  )
                ],
                // Tab Bar pinned on Sliver Collapse
                bottom: AppBar(
                  toolbarHeight: 70.h,
                  backgroundColor: Palette.blackColor,
                  titleSpacing: 0,
                  title: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelStyle:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                    labelColor: Colors.white,
                    unselectedLabelColor:
                        const Color.fromARGB(255, 154, 146, 146),
                    dividerColor: Colors.transparent,
                    indicatorColor: Palette.greenColor,
                    indicatorWeight: 3.5,
                    indicatorSize: TabBarIndicatorSize.label,
                    splashFactory: NoSplash.splashFactory,
                    enableFeedback: true,
                    tabs: newsInterests
                        .map((interest) => Tab(text: interest))
                        .toList(),
                  ),
                ),

                pinned: true,
                floating: true,
              ),
            ];
          },
          // Background image // Offseted by NestedScrollView
          body: ScaffoldBackgroundedBody(
            theChild: Stack(children: [
              Center(
                child: TabBarView(
                    children: newsInterests.map((interest) {
                  final explorePagearticles =
                      ref.watch(explorePageArticlesListProvider(interest));

                  return explorePagearticles.when(data: (articleData) {
                    // Filter the articles based on the selected category
                    return Scrollbar(
                      controller: _exploreScrollController,
                      interactive: true,
                      thickness: 6,
                      radius: Radius.circular(12.r),
                      child: ListView.builder(
                        padding: 15.padV,
                        physics: isOverlayActive
                            ? const NeverScrollableScrollPhysics()
                            : const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                        shrinkWrap: true,
                        itemCount: articleData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final articleDisplayExplore = articleData[index];
                          if (index == 0) {
                            // Explore page Headliner Article
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.w, vertical: 13.h),
                              child: GestureDetector(
                                onTap: () {
                                  context.pushNamed(
                                    ViNewsAppRouteConstants.newsArticleReadView,
                                    pathParameters: {
                                      "articleImage":
                                          articleDisplayExplore.urlToImage ??
                                              ViNewsAppImagesPath
                                                  .defaultArticleImage,
                                      "articleSource":
                                          articleDisplayExplore.source.name,
                                      "heroTag": 'exploreScreenHeadlinertag',
                                      "articleTitle":
                                          articleDisplayExplore.title,
                                      "articleAuthor":
                                          articleDisplayExplore.author ??
                                              'No Author Mentioned',
                                      "articlePublicationDate":
                                          formatDateString(articleDisplayExplore
                                              .publishedAt
                                              .toString()),
                                      "articleContent":
                                          articleDisplayExplore.content ??
                                              ViNewsAppTexts
                                                  .placeHolderArticleContent,
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    // Article Image
                                    Hero(
                                      tag: 'exploreScreenHeadlinertag',
                                      child: Container(
                                        width: double.infinity,
                                        height: 230.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          child: ImageLoaderForOverlay(
                                            height: 230.h,
                                            imageUrl: articleDisplayExplore
                                                    .urlToImage ??
                                                ViNewsAppImagesPath
                                                    .defaultArticleImage,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.h),
                                    // Article Title
                                    articleDisplayExplore.title.txtStyled(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.w700,
                                      maxLines: 2,
                                      textOverflow: TextOverflow.fade,
                                    ),
                                    SizedBox(height: 15.h),
                                    // Publication Date
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            PhosphorIconsBold.paperPlaneTilt
                                                .iconslide(size: 18.sp),
                                            SizedBox(width: 7.w),
                                            formatDateString(
                                                    articleDisplayExplore
                                                        .publishedAt
                                                        .toString())
                                                .txtStyled(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (index > 0) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.w, vertical: 10.h),
                              child: GestureDetector(
                                onTap: () {
                                  context.pushNamed(
                                    ViNewsAppRouteConstants.newsArticleReadView,
                                    pathParameters: {
                                      "articleImage":
                                          articleDisplayExplore.urlToImage ??
                                              ViNewsAppImagesPath
                                                  .defaultArticleImage,
                                      "articleSource":
                                          articleDisplayExplore.source.name,
                                      "heroTag": 'exploreScreentagImage$index',
                                      "articleTitle":
                                          articleDisplayExplore.title,
                                      "articleAuthor":
                                          articleDisplayExplore.author ??
                                              'No Author Mentioned',
                                      "articlePublicationDate":
                                          formatDateString(articleDisplayExplore
                                              .publishedAt
                                              .toString()),
                                      "articleContent":
                                          articleDisplayExplore.content ??
                                              ViNewsAppTexts
                                                  .placeHolderArticleContent,
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // Article Image
                                        Hero(
                                          tag: 'exploreScreentagImage$index',
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
                                              child: ImageLoaderForOverlay(
                                                imageUrl: articleDisplayExplore
                                                        .urlToImage ??
                                                    ViNewsAppImagesPath
                                                        .defaultArticleImage,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 15.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          // Article Title
                                          articleDisplayExplore.title.txtStyled(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w700,
                                            maxLines: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 15.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  // Publication Date
                                                  PhosphorIconsBold
                                                      .paperPlaneTilt
                                                      .iconslide(size: 18.sp),
                                                  SizedBox(width: 7.w),
                                                  formatDateString(
                                                          articleDisplayExplore
                                                              .publishedAt
                                                              .toString())
                                                      .txtStyled(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ],
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
                          return const SizedBox.shrink();
                        },
                      ),
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
                    return const CircularProgressIndicator();
                  });
                }).toList()),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
