import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/core/models/article_selections.dart';
import 'package:vinews_news_reader/core/controllers/app_providers.dart';
import 'package:vinews_news_reader/features/bookmarks/controllers/bookmarks_controllers.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/image_loader.dart';
import 'package:vinews_news_reader/utils/keyboard_utils.dart';
import 'package:vinews_news_reader/widgets/animated_search_bar.dart';
import 'package:vinews_news_reader/widgets/frosted_glass_box.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class UserBookmarksView extends ConsumerStatefulWidget {
  final VoidCallback showNavBar;
  final VoidCallback hideNavBar;

  const UserBookmarksView({
    super.key,
    required this.showNavBar,
    required this.hideNavBar,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserBookmarksViewState();
}

class _UserBookmarksViewState extends ConsumerState<UserBookmarksView> {
  final ScrollController _bookmarksScrollController = ScrollController();
  final ValueNotifier<int> _selectedOptionIndexValueNotifier =
      ValueNotifier<int>(0);
  final ValueNotifier<double> scrollPosition = 0.0.notifier;
  final ValueNotifier<double> opacityValue = 1.0.notifier;
  final StateProvider<bool> textfieldFocusedProvider =
      StateProvider((ref) => false);
  String formattedDate = DateFormat('E d MMM, y').format(DateTime.now());
  final FocusNode _searchFieldFocusNode = FocusNode();
  final TextEditingController _searchBookmarksFieldController =
      TextEditingController();

  void _handleScroll() {
    final offset = _bookmarksScrollController.offset;
    const maxScroll = 30.0; // Adjust this value based on your requirements

    // Calculate opacity based on scroll position.
    final newOpacity = 1.0 - (offset / maxScroll).clamp(0.0, 1.0);
    opacityValue.value = newOpacity;

    if (_bookmarksScrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      widget.showNavBar();
    } else {
      widget.hideNavBar();
    }
  }

  void updateOverlayActive(bool isOverlayActive, bool isTextFieldFocused) {
    if (isOverlayActive && isTextFieldFocused) {
      ref
          .read(bookmarksScreenOverlayActiveProvider.notifier)
          .update((state) => false);
    }
  }

  @override
  void initState() {
    _bookmarksScrollController.addListener(_handleScroll);
    _searchFieldFocusNode.addListener(() {
      ref
          .read(textfieldFocusedProvider.notifier)
          .update((state) => _searchFieldFocusNode.hasFocus);
      updateOverlayActive(
        ref.watch(bookmarksScreenOverlayActiveProvider),
        _searchFieldFocusNode.hasFocus,
      );
    });
    super.initState();
  }

  // Dispose Bookmark Search Bar Controller
  @override
  void dispose() {
    _bookmarksScrollController.removeListener(_handleScroll);
    _searchFieldFocusNode.dispose();
    _selectedOptionIndexValueNotifier.dispose();
    scrollPosition.dispose();
    opacityValue.dispose();
    _searchBookmarksFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Assignments and Declerations
    final List newsInterests = ref.watch(newsInterestSelectionProvider);
    final List<ArticleSelections> userBookmarksList =
        ref.watch(bookmarksProvider);
    final String queryString = ref.watch(bookmarksQueryStringProvider);
    final List<ArticleSelections> filteredBookmarksList =
        userBookmarksList.where((article) {
      return article.articleTitle
          .toLowerCase()
          .contains(queryString.toLowerCase());
    }).toList();
    final bool isOverlayActive =
        ref.watch(bookmarksScreenOverlayActiveProvider);
    final bool isHeaderVisible = ref.watch(animatedBarOpenProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DefaultTabController(
        length: newsInterests.length + 1,
        child: NestedScrollView(
          controller: _bookmarksScrollController,
          physics:
              isOverlayActive ? const NeverScrollableScrollPhysics() : null,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                toolbarHeight: 90.h,
                backgroundColor: Palette.blackColor,
                elevation: 0,
                titleSpacing: 0,
                title: Stack(children: [
                  Positioned.fill(
                    child: Padding(
                      padding: 30.padH,
                      child: AnimatedOpacity(
                        duration: 50.milliseconds,
                        opacity: isHeaderVisible == true ? 0.0 : 1.0,
                        child: Row(
                          children: [
                            PhosphorIcons.regular.bookmarks.iconslide(),
                            10.sbW,
                            "Bookmarks".txtStyled(
                                fontSize: 24.sp, fontWeight: FontWeight.w600),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: 18.padH,
                      child: opacityValue.sync(
                          builder: (context, opacityOnScroll, child) {
                        return AnimatedOpacity(
                          duration: 150.milliseconds,
                          opacity: opacityOnScroll,
                          child: AnimatedSearchField(
                            fieldFocusNode: _searchFieldFocusNode,
                            textFieldController:
                                _searchBookmarksFieldController,
                            overlayActive: isOverlayActive,
                            onChanged: (value) {
                              final String searchQuery = value.trim();
                              ref
                                  .read(bookmarksQueryStringProvider.notifier)
                                  .updateQueryString(searchQuery);
                            },
                            onEditingComplete: () {
                              dropKeyboard();
                            },
                            onSuffixIconTap: isOverlayActive
                                ? () {
                                    dropKeyboard();
                                    ref
                                        .read(
                                            bookmarksScreenOverlayActiveProvider
                                                .notifier)
                                        .update((state) => false);
                                    ref
                                        .read(bookmarksQueryStringProvider
                                            .notifier)
                                        .updateQueryString("");

                                    _searchBookmarksFieldController.clear();
                                  }
                                : () {
                                    dropKeyboard();
                                    _searchBookmarksFieldController.clear();
                                    ref
                                        .read(bookmarksQueryStringProvider
                                            .notifier)
                                        .updateQueryString("");
                                  },
                          ).alignCenterRight(),
                        );
                      })),
                ]),
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
                    tabs: [
                      // "All" Tab added in front of existing newInterest tabs
                      Tab(
                          text:
                              "All (${filteredBookmarksList.length})"), // Add the "All" tab and display the article count
                      ...newsInterests.asMap().entries.map((entry) {
                        String interest = entry.value;
                        int categoryCount = filteredBookmarksList
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
          body: GestureDetector(
            onTap: () => dropKeyboard(),
            child: Container(
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
                    SlidableAutoCloseBehavior(
                        closeWhenOpened: true,
                        child: ListView.builder(
                          cacheExtent: 100,
                          padding: 30
                              .padV, //Zero Padding Needed just needed to offset default value
                          shrinkWrap: true,
                          physics: isOverlayActive
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                          itemCount: filteredBookmarksList.length,
                          itemBuilder: (BuildContext context, int index) {
                            ArticleSelections articleFilterDisplay =
                                filteredBookmarksList[index];
                            return Builder(builder: (context) {
                              return Slidable(
                                key: UniqueKey(),
                                startActionPane: ActionPane(
                                  extentRatio: 0.000001,
                                  dismissible: DismissiblePane(
                                      dismissThreshold: 0.7,
                                      closeOnCancel: true,
                                      onDismissed: () {
                                        final itemToDelete =
                                            filteredBookmarksList[index];
                                        ref
                                            .read(bookmarksProvider.notifier)
                                            .removeArticleFromBookmarks(
                                                itemToDelete);
                                      }),
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Palette.redColor,
                                      icon: PhosphorIcons.bold.trash,
                                      label: "Delete",
                                      onPressed: (context) {},
                                    )
                                  ],
                                ),
                                endActionPane: ActionPane(
                                  extentRatio: 0.000001,
                                  motion: const StretchMotion(),
                                  dragDismissible: true,
                                  dismissible: DismissiblePane(
                                      dismissThreshold: 0.7,
                                      onDismissed: () {
                                        final itemToDelete =
                                            filteredBookmarksList[index];
                                        ref
                                            .read(bookmarksProvider.notifier)
                                            .removeArticleFromBookmarks(
                                                itemToDelete);
                                      }),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Palette.redColor,
                                      icon: PhosphorIcons.bold.trash,
                                      label: "Delete",
                                      onPressed: (context) {},
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only().padSpec(
                                      top: 13, bottom: 13, right: 25, left: 25),
                                  child: GestureDetector(
                                    onTap: () {
                                      context.pushNamed(
                                          ViNewsAppRouteConstants
                                              .newsArticleReadView,
                                          pathParameters: {
                                            "articleImage":
                                                articleFilterDisplay.urlImage,
                                            "articleCategory":
                                                articleFilterDisplay
                                                    .articleCategory,
                                            "heroTag":
                                                'bookmarksScreentagImage$index',
                                            "articleTitle": articleFilterDisplay
                                                .articleTitle,
                                            "articleAuthor":
                                                articleFilterDisplay
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
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    child: ImageLoaderForOverlay(
                                                        imageUrl:
                                                            articleFilterDisplay
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
                                              // News Article Title
                                              articleFilterDisplay.articleTitle
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
                                                          color: Palette
                                                              .blackColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      7.r),
                                                        ),
                                                        // News Article Category
                                                        child: Padding(
                                                          padding: 6.0.padA,
                                                          child:
                                                              articleFilterDisplay
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
                                                ],
                                              ),
                                              3.sbH,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // Article Publication Date
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
                                                  5.sbW,
                                                  // More Options
                                                  GestureDetector(
                                                    onTap: () {
                                                      dropKeyboard();
                                                      // Update the ValueNotifier with the index of the selected news article for the overlay.
                                                      _selectedOptionIndexValueNotifier
                                                          .value = index;
                                                      ref
                                                          .read(
                                                              bookmarksScreenOverlayActiveProvider
                                                                  .notifier)
                                                          .update((state) =>
                                                              !state);
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
                                ),
                              );
                            });
                          },
                        )),
                    // The rest of the News Interest tabs
                    ...newsInterests.map((interest) {
                      // Filter the articles based on the selected category
                      final filteredTabArticles = filteredBookmarksList
                          .where(
                              (article) => article.articleCategory == interest)
                          .toList();

                      return Scrollbar(
                        controller: _bookmarksScrollController,
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
                          itemCount: filteredTabArticles.length,
                          itemBuilder: (BuildContext context, int index) {
                            ArticleSelections filteredTabArticleDisplay =
                                filteredTabArticles[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 13.h, horizontal: 25.w),
                              child: GestureDetector(
                                onTap: () {
                                  context.pushNamed(
                                    ViNewsAppRouteConstants.newsArticleReadView,
                                    pathParameters: {
                                      "articleImage":
                                          filteredTabArticleDisplay.urlImage,
                                      "articleCategory":
                                          filteredTabArticleDisplay
                                              .articleCategory,
                                      "heroTag":
                                          'bookmarksScreentagImage$index',
                                      "articleTitle": filteredTabArticleDisplay
                                          .articleTitle,
                                      "articleAuthor": filteredTabArticleDisplay
                                          .articleCategory,
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
                                                child: ImageLoaderForOverlay(
                                                    imageUrl:
                                                        filteredTabArticleDisplay
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
                                          filteredTabArticleDisplay.articleTitle
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
                                                      color: Palette
                                                          .appButtonColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.r),
                                                    ),
                                                    child: Padding(
                                                      padding: 6.0.padA,
                                                      child:
                                                          filteredTabArticleDisplay
                                                              .articleCategory
                                                              .txtStyled(
                                                        fontSize: 13.sp,
                                                        color:
                                                            Palette.whiteColor,
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
                                                  dropKeyboard();
                                                  final selectedArticle =
                                                      filteredTabArticles[
                                                          index];
                                                  final originalIndex =
                                                      filteredTabArticles
                                                          .indexOf(
                                                              selectedArticle);
                                                  // Update Index for Overlay Display
                                                  _selectedOptionIndexValueNotifier
                                                      .value = originalIndex;
                                                  // Display Overlay
                                                  ref
                                                      .read(
                                                          bookmarksScreenOverlayActiveProvider
                                                              .notifier)
                                                      .update(
                                                          (state) => !state);
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
                              filteredBookmarksList[
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
                                                'bookmarksScreenOverlaytagImage${_selectedOptionIndexValueNotifier.value}',
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
                                                      BorderRadius.circular(
                                                          10.r),
                                                  child: ImageLoaderForOverlay(
                                                      imageUrl:
                                                          articleOverlayDisplay
                                                              .urlImage)),
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
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
