import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/core/models/article_selections.dart';
import 'package:vinews_news_reader/core/provider/app_providers.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_palette.dart';
import 'package:vinews_news_reader/utils/image_loader.dart';
import 'package:vinews_news_reader/widgets/frosted_glass_box.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class ReadArticlesView extends ConsumerStatefulWidget {
  const ReadArticlesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ReadArticlesViewState();
}

class _ReadArticlesViewState extends ConsumerState<ReadArticlesView> {
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

  @override
  Widget build(BuildContext context) {
    final List newsInterests = ref.watch(newsInterestSelectionProvider);
    final isOverlayActive = ref.watch(readArticlesScreenOverlayActiveProvider);
    return DefaultTabController(
      length: newsInterests.length + 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.blackColor,
          elevation: 0,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              "Read Articles".txtStyled(fontSize: 18.sp),
              5.sbW,
              PhosphorIcons.regular.eye.iconslide(size: 19.sp),
            ],
          ),
          bottom: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 100.h,
            backgroundColor: Palette.blackColor,
            titleSpacing: 0,
            title: TabBar(
              isScrollable: true,
              labelStyle:
                  TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
              labelColor: Colors.white,
              unselectedLabelColor: const Color.fromARGB(255, 154, 146, 146),
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
                        "All (${articleDisplayList.length})"), // Add the "All" tab and display the article count
                ...newsInterests.asMap().entries.map((entry) {
                  String interest = entry.value;
                  int categoryCount = articleDisplayList
                      .where((article) => article.articleCategory == interest)
                      .length;
                  return Tab(
                    text: "$interest ($categoryCount)", // Display the count
                  );
                }),
              ],
            ),
          ),
        ),
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
            TabBarView(children: [
              // ListView for "All" tab
              ListView.builder(
                padding: 20
                    .padV, //Zero Padding Needed just needed to offset default value
                shrinkWrap: true,
                physics: isOverlayActive
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                itemCount: articleDisplayList.length,
                itemBuilder: (BuildContext context, int index) {
                  ArticleSelections articleDisplay = articleDisplayList[index];
                  return Padding(
                    padding: const EdgeInsets.only()
                        .padSpec(top: 13, bottom: 13, right: 25, left: 25),
                    child: GestureDetector(
                      onTap: () {
                        context.pushNamed(
                            ViNewsAppRouteConstants.newsArticleReadView,
                            pathParameters: {
                              "articleImage": articleDisplay.urlImage,
                              "articleCategory": articleDisplay.articleCategory,
                              "heroTag": 'readArticlesScreentagImage$index',
                              "articleTitle": articleDisplay.articleTitle,
                              "articleAuthor": articleDisplay.articleCategory,
                              "articlePublicationDate": formattedDate.toString()
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
                                tag: 'readArticlesScreentagImage$index',
                                child: Container(
                                  width: 125.w,
                                  height: 110.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: ImageLoaderForOverlay(imageUrl: articleDisplay.urlImage)
                                  ),
                                ),
                              ),
                            ],
                          ),
                          15.sbW,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                            color: Palette.blackColor,
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
                                              color: Palette.whiteColor,
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
                                                readArticlesScreenOverlayActiveProvider
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
                    padding: 20.padV,
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
                                "heroTag": 'readArticlesScreentagImage$index',
                                "articleTitle": articleDisplay.articleTitle,
                                "articleAuthor": articleDisplay.articleCategory,
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
                                    tag: 'readArticlesScreentagImage$index',
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
                                        child: ImageLoaderForOverlay(imageUrl: articleDisplay.urlImage)
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
                                                color: Palette.appButtonColor,
                                                borderRadius:
                                                    BorderRadius.circular(7.r),
                                              ),
                                              child: Padding(
                                                padding: 6.0.padA,
                                                child: articleDisplay
                                                    .articleCategory
                                                    .txtStyled(
                                                  fontSize: 13.sp,
                                                  color: Palette.whiteColor,
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
                                        Row(
                                          children: [
                                            // Article Publication Date
                                            PhosphorIcons.bold.paperPlaneTilt
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
                                                articleDisplayList
                                                    .indexOf(selectedArticle);
                                            // Update Index for Overlay Display
                                            _selectedOptionIndexValueNotifier
                                                .value = originalIndex;
                                            // Display Overlay
                                            ref
                                                .read(
                                                    readArticlesScreenOverlayActiveProvider
                                                        .notifier)
                                                .update((state) => !state);
                                          },
                                          child: PhosphorIcons.bold.dotsThree
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
                                  color: Palette.greyColor.withOpacity(0.75),
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
                                              'readArticlesScreenOverlaytagImage${_selectedOptionIndexValueNotifier.value}',
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
                                              child: ImageLoaderForOverlay(imageUrl: articleOverlayDisplay.urlImage)
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
                                                            Palette.blackColor,
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
                                                        readArticlesScreenOverlayActiveProvider
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
                                                    color: Palette.blackColor),
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
                                                          'readArticlesScreenOverlaytagImage${_selectedOptionIndexValueNotifier.value}',
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
}
