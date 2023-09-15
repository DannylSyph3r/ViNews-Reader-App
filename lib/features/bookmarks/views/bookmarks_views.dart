import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/core/models/article_selections.dart';
import 'package:vinews_news_reader/core/provider/news_interest_provider.dart';
import 'package:vinews_news_reader/features/bookmarks/views/bookmarks_search_view.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class UserBookmarksView extends ConsumerStatefulWidget {
  const UserBookmarksView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserBookmarksViewState();
}

class _UserBookmarksViewState extends ConsumerState<UserBookmarksView> {
  String formattedDate = DateFormat('E d MMM, y').format(DateTime.now());
  final _searchBookmarksFieldController = TextEditingController();

  // Dispose Bookmark Search Bar Controller
  @override
  void dispose() {
    _searchBookmarksFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // News Interest provider for Interest Horizontal ListView
    final newsInterests = ref.watch(newsInterestSelectionProvider);
    return Scaffold(
      body: DefaultTabController(
        length: 12,
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
                      PhosphorIcons.regular.bookmarks.iconslide(),
                      10.sbW,
                      "Bookmarks".txtStyled(
                          fontSize: 24.sp, fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only().padSpec(right: 30),
                    child: GestureDetector(
                        onTap: () => navigateToBookmarksSearchScreen(context),
                        child: Hero(
                            tag: 'bookmarksSearchHeroTag',
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
                child: Center(
                  child: Padding(
                    padding: 30.padV,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // News Article ListView
                        ListView.builder(
                          padding: 0
                              .padV, //Zero Padding Needed just needed to offset default value
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: articleDisplayList
                              .length, // The number of times you want to duplicate the widget
                          itemBuilder: (BuildContext context, int index) {
                            ArticleSelections articleDisplay =
                                articleDisplayList[index];
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 13.h, horizontal: 25.w),
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
                                                'bookmarksScreentagImage$index',
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
                                              tag:
                                                  'bookmarksScreentagImage$index',
                                              child: Container(
                                                width: 125.w,
                                                height: 110.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  // color: Pallete.greyColor,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
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
                                              3.sbH,
                                              Row(
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
                                                          color: Pallete
                                                              .appButtonColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      7.r),
                                                        ),
                                                        child: Padding(
                                                          // News Article Category
                                                          padding: 6.0.padA,
                                                          child: articleDisplay
                                                              .articleCategory
                                                              .txtStyled(
                                                            fontSize: 13.sp,
                                                            color: Pallete
                                                                .whiteColor,
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      // Article Publication Date
                                                      PhosphorIcons
                                                          .bold.clockCountdown
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
                                                  PhosphorIcons.bold.dotsThree
                                                      .iconslide(size: 27.sp),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigateToBookmarksSearchScreen(BuildContext context) {
    pushNewScreenWithRouteSettings(context,
        screen: const BookmarksSearchView(),
        settings: const RouteSettings(name: "/bookmarksSearch"));
  }
}
