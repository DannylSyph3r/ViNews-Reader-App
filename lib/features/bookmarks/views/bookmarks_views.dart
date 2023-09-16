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
  final _searchBookmarksFieldController = TextEditingController();

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
        length: 12,
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
            child: Stack(children: [
              Scrollbar(
                interactive: true,
                thickness: 6,
                radius: Radius.circular(12.r),
                child: SingleChildScrollView(
                  physics: isOverlayActive
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
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
                                              "articleCategory": articleDisplay
                                                  .articleCategory,
                                              "heroTag":
                                                  'bookmarksScreentagImage$index',
                                              "articleTitle":
                                                  articleDisplay.articleTitle,
                                              "articleAuthor": articleDisplay
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
                                                                  FontWeight
                                                                      .w600,
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
                                                        // Update Index for Overlay Display
                                                        _selectedOptionIndexValueNotifier
                                                            .value = index;
                                                        // Display Overlay
                                                        ref
                                                            .read(
                                                                bookmarksScreenOverlayActiveProvider
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
                                      )));
                            },
                          ),
                        ],
                      ),
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
                              theChild: Padding(
                                padding: 20.0.padA,
                                child: Container(
                                  height: 550.h,
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
                                    padding: 20.0.padA,
                                    child: Column(children: [
                                      articleOverlayDisplay.articleTitle
                                          .txtStyled(
                                              fontSize: 25.sp,
                                              fontWeight: FontWeight.w700,
                                              maxLines: 2,
                                              textOverflow:
                                                  TextOverflow.ellipsis),
                                      15.sbH,
                                      articleOverlayDisplay.articleDescription
                                          .txtStyled(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w500,
                                              maxLines: 3,
                                              textOverflow:
                                                  TextOverflow.ellipsis),
                                      15.sbH,
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
                                            child: Image.network(
                                              articleOverlayDisplay.urlImage,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      15.sbH,
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
                                              PhosphorIcons.bold.clockCountdown
                                                  .iconslide(size: 19.sp),
                                              5.sbW,
                                              "10 mins".txtStyled(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500)
                                            ],
                                          )
                                        ],
                                      ),
                                      15.sbH,
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
                                                      color: Pallete.blackColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.r),
                                                    ),
                                                    // News Article Category
                                                    child: Padding(
                                                      padding: 6.0.padA,
                                                      child:
                                                          articleOverlayDisplay
                                                              .articleCategory
                                                              .txtStyled(
                                                        fontSize: 14.sp,
                                                        color:
                                                            Pallete.whiteColor,
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
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              PhosphorIcons.bold.bookmarks
                                                  .iconslide(size: 32.sp),
                                              5.sbW,
                                              PhosphorIcons.bold.heart
                                                  .iconslide(size: 32.sp)
                                            ],
                                          )
                                        ],
                                      ),
                                      20.sbH,
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
                                                        'bookmarksScreenOverlaytagImage${_selectedOptionIndexValueNotifier.value}',
                                                    "articleTitle":
                                                        articleOverlayDisplay
                                                            .articleTitle,
                                                    "articleAuthor":
                                                        articleOverlayDisplay
                                                            .articleCategory,
                                                    "articlePublicationDate":
                                                        formattedDate.toString()
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
      ),
    );
  }

  void navigateToBookmarksSearchScreen(BuildContext context) {
    pushNewScreenWithRouteSettings(context,
        screen: const BookmarksSearchView(),
        settings: const RouteSettings(name: "/bookmarksSearch"));
  }
}
