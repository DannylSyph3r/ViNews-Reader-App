import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/core/models/article_selections.dart';
import 'package:vinews_news_reader/core/controllers/app_providers.dart';
import 'package:vinews_news_reader/features/explore/views/explore_search_view.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/image_loader.dart';
import 'package:vinews_news_reader/widgets/frosted_glass_box.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

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
  final ValueNotifier<int> _selectedOptionIndexValueNotifier = 0.notifier;
  String formattedDate = DateFormat('E d MMM, y').format(DateTime.now());

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
    _selectedOptionIndexValueNotifier.dispose();
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
                      PhosphorIcons.regular.globeHemisphereWest.iconslide(),
                      10.sbW,
                      "Explore".txtStyled(
                          fontSize: 24.sp, fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only().padSpec(right: 30),
                    child: GestureDetector(
                        onTap: () => navigateToExploreSearchScreen(context),
                        child:
                            PhosphorIcons.regular.magnifyingGlass.iconslide()),
                  )
                ],
                // Search Bar pinned on Sliver Collapse
                bottom: AppBar(
                  toolbarHeight: 100.h,
                  backgroundColor: Palette.blackColor,
                  titleSpacing: 0,
                  title: TabBar(
                    isScrollable: true,
                    labelStyle:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                    labelColor: Colors.white,
                    unselectedLabelColor:
                        const Color.fromARGB(255, 154, 146, 146),
                    dividerColor: Colors.grey,
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
              Center(
                child: TabBarView(
                    children: newsInterests.map((interest) {
                  // Filter the articles based on the selected category
                  final filteredExploreArticles = articleDisplayList
                      .where((article) => article.articleCategory == interest)
                      .toList();
                  return Scrollbar(
                              controller: _exploreScrollController,
                    interactive: true,
                    thickness: 6,
                    radius: Radius.circular(12.r),
                    child: ListView.builder(
                        padding: 10.padV,
                        physics: isOverlayActive
                            ? const NeverScrollableScrollPhysics()
                            : const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < filteredExploreArticles.length) {
                            ArticleSelections articleDisplayExplore =
                                filteredExploreArticles[index];
                            if (index == 0) {
                              // Explore page Headliner Article
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.w, vertical: 10.h),
                                child: GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                        ViNewsAppRouteConstants
                                            .newsArticleReadView,
                                        pathParameters: {
                                          "articleImage":
                                              articleDisplayExplore.urlImage,
                                          "articleCategory":
                                              articleDisplayExplore
                                                  .articleCategory,
                                          "heroTag":
                                              'exploreScreenHeadlinertag',
                                          "articleTitle":
                                              articleDisplayExplore
                                                  .articleTitle,
                                          "articleAuthor":
                                              articleDisplayExplore
                                                  .articleCategory,
                                          "articlePublicationDate":
                                              formattedDate.toString()
                                        });
                                  },
                                  child: Column(
                                    children: [
                                      Hero(
                                        tag: 'exploreScreenHeadlinertag',
                                        child: Container(
                                          width: double.infinity,
                                          height: 230.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      15.r)),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              child: ImageLoaderForOverlay(
                                                  height: 230.h,
                                                  imageUrl:
                                                      articleDisplayExplore
                                                          .urlImage)),
                                        ),
                                      ),
                                      15.sbH,
                                      // Headliner Article Title
                                      articleDisplayExplore.articleTitle
                                          .txtStyled(
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.w700,
                                        maxLines: 2,
                                        textOverflow: TextOverflow.fade,
                                      ),
                                      15.sbH,
                                      // Headliner Publication Date
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
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
                                          // Headliner article (More Options)
                                          GestureDetector(
                                            onTap: () {
                                              final selectedHeadlinerArticle =
                                                  filteredExploreArticles[
                                                      index];
                                              final originalIndex =
                                                  articleDisplayList.indexOf(
                                                      selectedHeadlinerArticle);
                                              // Update Index for Overlay Display
                                              _selectedOptionIndexValueNotifier
                                                  .value = originalIndex;
                                              // Display Overlay
                                              ref
                                                  .read(
                                                      exploreScreenOverlayActiveProider
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
                              );
                            } else if (index > 0) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.w, vertical: 10.h),
                                child: GestureDetector(
                                    onTap: () {
                                      context.pushNamed(
                                          ViNewsAppRouteConstants
                                              .newsArticleReadView,
                                          pathParameters: {
                                            "articleImage":
                                                articleDisplayExplore
                                                    .urlImage,
                                            "articleCategory":
                                                articleDisplayExplore
                                                    .articleCategory,
                                            "heroTag":
                                                'exploreScreentagImage$index',
                                            "articleTitle":
                                                articleDisplayExplore
                                                    .articleTitle,
                                            "articleAuthor":
                                                articleDisplayExplore
                                                    .articleCategory,
                                            "articlePublicationDate":
                                                formattedDate.toString()
                                          });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            // News Article Image
                                            Hero(
                                              tag:
                                                  'exploreScreentagImage$index',
                                              child: Container(
                                                width: 125.w,
                                                height: 110.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    child: ImageLoaderForOverlay(
                                                        imageUrl:
                                                            articleDisplayExplore
                                                                .urlImage)),
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
                                              // News Article Image
                                              articleDisplayExplore
                                                  .articleTitle
                                                  .txtStyled(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w700,
                                                maxLines: 2,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                              15.sbH,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      // Article Publication Date
                                                      PhosphorIcons
                                                          .bold.paperPlaneTilt
                                                          .iconslide(
                                                              size: 18.sp),
                                                      7.sbW,
                                                      formattedDate.txtStyled(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ],
                                                  ),
                                                  5.sbW,
                                                  // More Options
                                                  GestureDetector(
                                                    onTap: () {
                                                      final selectedArticle =
                                                          filteredExploreArticles[
                                                              index];
                                                      final originalIndex =
                                                          articleDisplayList
                                                              .indexOf(
                                                                  selectedArticle);
                                                      // Update Index for Overlay Display
                                                      _selectedOptionIndexValueNotifier
                                                              .value =
                                                          originalIndex;
                                                      // Display Overlay
                                                      ref
                                                          .read(
                                                              exploreScreenOverlayActiveProider
                                                                  .notifier)
                                                          .update((state) =>
                                                              !state);
                                                    },
                                                    child: PhosphorIcons
                                                        .bold.dotsThree
                                                        .iconslide(
                                                            size: 27.sp),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            }
                          } else {
                            return const SizedBox.shrink();
                          }
                          return null;
                        }),
                  );
                }).toList()),
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
                              theChildAlignment: MainAxisAlignment.center,
                              theChild: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.w, vertical: 15.h),
                                child: Container(
                                  height: 590.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: Palette.greyColor.withOpacity(0.75),
                                    image: const DecorationImage(
                                      image: AssetImage(ViNewsAppImagesPath
                                          .appBackgroundImage),
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
                                          articleOverlayDisplay
                                              .articleDescription
                                              .txtStyled(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500,
                                                  maxLines: 3,
                                                  textOverflow:
                                                      TextOverflow.ellipsis),
                                          Hero(
                                            tag:
                                                'exploreScreenOverlaytagImage${_selectedOptionIndexValueNotifier.value}',
                                            child: Container(
                                              width: double.infinity,
                                              height: 150.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                // color: Palette.greyColor,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                child: ImageLoaderForOverlay(
                                                    imageUrl:
                                                        articleOverlayDisplay
                                                            .urlImage),
                                              ),
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
                                                      fontWeight:
                                                          FontWeight.w500)
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
                                                          .iconslide(
                                                              size: 18.sp),
                                                      7.sbW,
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Palette
                                                              .blackColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      7.r),
                                                        ),
                                                        // News Article Category
                                                        child: Padding(
                                                          padding: 7.0.padA,
                                                          child:
                                                              articleOverlayDisplay
                                                                  .articleCategory
                                                                  .txtStyled(
                                                            fontSize: 14.sp,
                                                            color: Palette
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
                                                          .iconslide(
                                                              size: 18.sp),
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
                                                  PhosphorIcons
                                                      .bold.heartStraight
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
                                                          exploreScreenOverlayActiveProider
                                                              .notifier)
                                                      .update(
                                                          (state) => !state);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  fixedSize: Size(110.w, 45.w),
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          161, 237, 226, 226),
                                                  side: BorderSide(
                                                      width: 2.5.w,
                                                      color:
                                                          Palette.blackColor),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            11),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    "Back".txtStyled(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Palette.blackColor,
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
                                                            'exploreScreenOverlaytagImage${_selectedOptionIndexValueNotifier.value}',
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
                                                      Palette.blackColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            11),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    "Read".txtStyled(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w800,
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
      ),
    );
  }

  void navigateToExploreSearchScreen(BuildContext context) {
    pushNewScreenWithRouteSettings(context,
        screen: const ExploreScreenSearchView(),
        settings: const RouteSettings(name: "/exploreSearch"));
  }
}
