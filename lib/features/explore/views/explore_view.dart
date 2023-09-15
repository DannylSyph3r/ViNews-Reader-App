import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/core/models/article_selections.dart';
import 'package:vinews_news_reader/core/provider/news_interest_provider.dart';
import 'package:vinews_news_reader/features/explore/views/explore_search_view.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class UserExploreView extends ConsumerStatefulWidget {
  const UserExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserExploreViewState();
}

class _UserExploreViewState extends ConsumerState<UserExploreView> {
  String formattedDate = DateFormat('E d MMM, y').format(DateTime.now());
  final TextEditingController _exploreSearchFieldController =
      TextEditingController();
  // Dispose Explore Search Bar Controller

  @override
  void dispose() {
    _exploreSearchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // News Interest provider for Interest Horizontal ListView
    final List newsInterests = ref.watch(newsInterestSelectionProvider);
    return Scaffold(
      body: DefaultTabController(
        length: newsInterests.length,
        child: NestedScrollView(
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
                        child: Hero(
                            tag: 'exploreSearchHeroTag',
                            child: PhosphorIcons.regular.magnifyingGlass
                                .iconslide())),
                  )
                ],
                // Search Bar pinned on Sliver Collapse
                bottom: AppBar(
                  toolbarHeight: 100.h,
                  backgroundColor: Pallete.blackColor,
                  titleSpacing: 0,
                  title: TabBar(
                    isScrollable: true,
                    labelStyle:
                        TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                    labelColor: Colors.white,
                    unselectedLabelColor:
                        const Color.fromARGB(255, 154, 146, 146),
                    dividerColor: Colors.grey,
                    indicatorColor: Pallete.greenColor,
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
            child: Scrollbar(
              interactive: true,
              thickness: 6,
              radius: Radius.circular(12.r),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only().padSpec(top: 30, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Explore page HeadLiner News Image
                      Padding(
                        padding: 25.padH,
                        child: Container(
                          width: double.infinity,
                          height: 230.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: Image.asset(
                                "assets/images/amazon_forest.png",
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                      15.sbH,
                      // Headliner Article Title
                      Padding(
                        padding: 25.padH,
                        child: "Uncovering the Hidden Gems of the Amazon Forest"
                            .txtStyled(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w700,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                      15.sbH,
                      // Headliner Publication Date
                      Padding(
                        padding: 25.padH,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                PhosphorIcons.bold.clockCountdown
                                    .iconslide(size: 18.sp),
                                7.sbW,
                                formattedDate.txtStyled(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            // Headliner article (More Options)
                            PhosphorIcons.bold.dotsThree.iconslide(size: 27.sp),
                          ],
                        ),
                      ),
                      // News Article ListView
                      ListView.builder(
                          padding: 15.padV,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            ArticleSelections articleDisplay =
                                articleDisplayList[index];
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
                                              articleDisplay.urlImage,
                                          "articleCategory":
                                              articleDisplay.articleCategory,
                                          "heroTag":
                                              'exploreScreentagImage$index',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          // News Article Image
                                          Hero(
                                            tag: 'exploreScreentagImage$index',
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
                                                child: Image.network(
                                                  articleDisplay.urlImage,
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
                                            // News Article Image
                                            articleDisplay.articleTitle
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
                                                        .bold.clockCountdown
                                                        .iconslide(size: 18.sp),
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
                                                PhosphorIcons.bold.dotsThree
                                                    .iconslide(size: 27.sp),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          })
                    ],
                  ),
                ),
              ),
            ),
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
