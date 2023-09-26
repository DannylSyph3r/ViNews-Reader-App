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
import 'package:vinews_news_reader/features/bookmarks/views/bookmarks_search_view.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/frosted_glass_box.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class UserBookmarksView extends ConsumerStatefulWidget {
  const UserBookmarksView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserBookmarksViewState();
}

class _UserBookmarksViewState extends ConsumerState<UserBookmarksView> {
  final ValueNotifier<int> _selectedOptionIndexValueNotifier =
      ValueNotifier<int>(0);
  String formattedDate = DateFormat('E d MMM, y').format(DateTime.now());
  final TextEditingController _searchBookmarksFieldController =
      TextEditingController();

  @override
  void initState() {
    _selectedOptionIndexValueNotifier.value = 0;
    super.initState();
  }

  // Dispose Bookmark Search Bar Controller
  @override
  void dispose() {
    _selectedOptionIndexValueNotifier.dispose();
    _searchBookmarksFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List newsInterests = ref.watch(newsInterestSelectionProvider);
    final bool isOverlayActive =
        ref.watch(bookmarksScreenOverlayActiveProvider);
    return Scaffold(
      body: DefaultTabController(
        length: newsInterests.length + 1,
        child: NestedScrollView(
          physics:
              isOverlayActive ? const NeverScrollableScrollPhysics() : null,
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
                        child: PhosphorIcons.regular.magnifyingGlass
                            .iconslide()),
                  )
                ],
                // TabBar pinned on Sliver Collapse
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
                    tabs: [
                      // "All" Tab added in front of existing newInterest tabs
                      Tab(
                          text:
                              "All (${articleDisplayList.length})"), // Add the "All" tab and display the article count
                      ...newsInterests.asMap().entries.map((entry) {
                        String interest = entry.value;
                        int categoryCount = articleDisplayList
                            .where((article) =>
                                article.articleCategory == interest)
                            .length;
                        return Tab(
                          text:
                              "$interest ($categoryCount)", // Display the count
                        );
                      }),
                    ],
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
                child: TabBarView(children: [
                  // ListView for "All" tab
                  ListView.builder(
                    padding: 30
                        .padV, //Zero Padding Needed just needed to offset default value
                    shrinkWrap: true,
                    physics: isOverlayActive
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                    itemCount: articleDisplayList.length,
                    itemBuilder: (BuildContext context, int index) {
                      ArticleSelections articleDisplay =
                          articleDisplayList[index];
                      return Padding(
                        padding: const EdgeInsets.only()
                            .padSpec(top: 13, bottom: 13, right: 25, left: 25),
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(
                                ViNewsAppRouteConstants.newsArticleReadView,
                                pathParameters: {
                                  "articleImage": articleDisplay.urlImage,
                                  "articleCategory":
                                      articleDisplay.articleCategory,
                                  "heroTag": 'bookmarksScreentagImage$index',
                                  "articleTitle": articleDisplay.articleTitle,
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
                                    tag: 'bookmarksScreentagImage$index',
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
                                                    BorderRadius.circular(7.r),
                                              ),
                                              // News Article Category
                                              child: Padding(
                                                padding: 6.0.padA,
                                                child: articleDisplay
                                                    .articleCategory
                                                    .txtStyled(
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
                                        // Article Publication Date
                                        Row(
                                          children: [
                                            PhosphorIcons.bold.paperPlaneTilt
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
                                                    bookmarksScreenOverlayActiveProvider
                                                        .notifier)
                                                .update((state) => !state);
                                          },
                                          child: PhosphorIcons.bold.dotsThree
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
                  // The rest of the News Interest tabs
                  ...newsInterests.map((interest) {
                    // Filter the articles based on the selected category
                    final filteredArticles = articleDisplayList
                        .where((article) => article.articleCategory == interest)
                        .toList();

                    return Scrollbar(
                      interactive: true,
                      thickness: 6,
                      radius: Radius.circular(12.r),
                      child: ListView.builder(
                        padding: 30.padV,
                        shrinkWrap: true,
                        physics: isOverlayActive
                            ? const NeverScrollableScrollPhysics()
                            : const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                        itemCount: filteredArticles.length,
                        itemBuilder: (BuildContext context, int index) {
                          ArticleSelections articleDisplay =
                              filteredArticles[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 13.h, horizontal: 25.w),
                            child: GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                  ViNewsAppRouteConstants.newsArticleReadView,
                                  pathParameters: {
                                    "articleImage": articleDisplay.urlImage,
                                    "articleCategory":
                                        articleDisplay.articleCategory,
                                    "heroTag": 'bookmarksScreentagImage$index',
                                    "articleTitle": articleDisplay.articleTitle,
                                    "articleAuthor":
                                        articleDisplay.articleCategory,
                                    "articlePublicationDate":
                                        formattedDate.toString(),
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
                                      // News Article Image
                                      Hero(
                                        tag: 'bookmarksScreentagImage$index',
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
                                        // News Article Image
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
                                                    color:
                                                        Pallete.appButtonColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.r),
                                                  ),
                                                  child: Padding(
                                                    padding: 6.0.padA,
                                                    child: articleDisplay
                                                        .articleCategory
                                                        .txtStyled(
                                                      fontSize: 13.sp,
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
                                            Row(
                                              children: [
                                                // Article Publication Date
                                                PhosphorIcons
                                                    .bold.paperPlaneTilt
                                                    .iconslide(
                                                  size: 18.sp,
                                                ),
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
                                                final selectedArticle =
                                                    filteredArticles[index];
                                                final originalIndex =
                                                    articleDisplayList.indexOf(
                                                        selectedArticle);
                                                // Update Index for Overlay Display
                                                _selectedOptionIndexValueNotifier
                                                    .value = originalIndex;
                                                // Display Overlay
                                                ref
                                                    .read(
                                                        bookmarksScreenOverlayActiveProvider
                                                            .notifier)
                                                    .update((state) => !state);
                                              },
                                              child: PhosphorIcons
                                                  .bold.dotsThree
                                                  .iconslide(
                                                size: 27.sp,
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
                        },
                      ),
                    );
                  }).toList(),
                ]),
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
                                                'bookmarksScreenOverlaytagImage${_selectedOptionIndexValueNotifier.value}',
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
                                                  key: UniqueKey(),
                                                  imageUrl:
                                                      articleOverlayDisplay
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
                                                          color: Pallete
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
                                                          bookmarksScreenOverlayActiveProvider
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
                                                          Pallete.blackColor),
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
                                                            'bookmarksScreenOverlaytagImage${_selectedOptionIndexValueNotifier.value}',
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

  void navigateToBookmarksSearchScreen(BuildContext context) {
    pushNewScreenWithRouteSettings(context,
        screen: const BookmarksSearchView(),
        settings: const RouteSettings(name: "/bookmarksSearch"));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchSuggestions = [
    "Business",
    "Entertainment",
    "Food",
    "Environment",
    "Health",
    "Politics",
    "Science",
    "Sports",
    "Technology",
    "Top News",
    "Tourism",
    "World",
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: GestureDetector(
          onTap: () {
            query = '';
          },
          child: PhosphorIcons.bold.x.iconslide(),
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: PhosphorIcons.bold.arrowLeft.iconslide(),
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchSuggestions) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return Padding(
      padding: 10.padH,
      child: ListView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var result = matchQuery[index];
            return Padding(
                padding: 10.padV,
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
                    decoration: BoxDecoration(
                        color: Pallete.whiteColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15.r)),
                    child: Row(
                      children: [
                        PhosphorIcons.bold.clockCounterClockwise
                            .iconslide(size: 25.sp, color: Pallete.blackColor),
                        10.sbW,
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 250.w),
                            child: result.txtStyled(
                                fontSize: 18.sp,
                                textOverflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: PhosphorIcons.bold.x
                              .iconslide(size: 20.sp, color: Pallete.blackColor),
                        ),
                      ],
                    )));
          }),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchSuggestions) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return Padding(
              padding: 10.padV,
              child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
                  decoration: BoxDecoration(
                      color: Pallete.whiteColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15.r)),
                  child: Row(
                    children: [
                      PhosphorIcons.bold.clockCounterClockwise
                          .iconslide(size: 25.sp, color: Pallete.blackColor),
                      10.sbW,
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 250.w),
                          child: result.txtStyled(
                              fontSize: 18.sp,
                              textOverflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: PhosphorIcons.bold.x
                            .iconslide(size: 20.sp, color: Pallete.blackColor),
                      ),
                    ],
                  )));
        });
  }
}
