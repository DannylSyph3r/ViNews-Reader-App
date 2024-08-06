import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/core/models/article_selections.dart';
import 'package:vinews_news_reader/core/models/news_response.dart';
import 'package:vinews_news_reader/core/providers/app_providers.dart';
import 'package:vinews_news_reader/features/home/notifiers/articles_notifier.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/image_loader.dart';
import 'package:vinews_news_reader/utils/vinews_app_texts.dart';
import 'package:vinews_news_reader/widgets/frosted_glass_box.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/news_list_display.dart';

class ExploreSearchResultsView extends ConsumerStatefulWidget {
  final String searchedWord;
  const ExploreSearchResultsView({super.key, required this.searchedWord});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExploreSearchResultsViewState();
}

class _ExploreSearchResultsViewState
    extends ConsumerState<ExploreSearchResultsView> {
  final ValueNotifier<int> _selectedOptionIndexValueNotifier =
      ValueNotifier<int>(0);

  String formatDateString(String dateString) {
    final originalDate = DateTime.parse(dateString);
    final formattedDate = DateFormat('E d MMM, y').format(originalDate);
    return formattedDate;
  }

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
    final isOverlayActive = ref.watch(likedArticlesScreenOverlayActiveProvider);
    final searchedArticles =
        ref.watch(searchedArticlesListProvider(widget.searchedWord));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.blackColor,
        elevation: 0,
        centerTitle: true,
        leading: PhosphorIconsBold.arrowLeft
            .iconslide(size: 25.sp, color: Palette.whiteColor)
            .inkTap(onTap: () => context.pop()),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhosphorIconsRegular.magnifyingGlass.iconslide(size: 19.sp),
            7.sbW,
            "Search results for"
                .txtStyled(fontSize: 18.sp, color: Palette.whiteColor),
            3.sbW,
            Container(
              constraints: BoxConstraints(maxWidth: 150.w),
              child: "'${widget.searchedWord}'".txtStyled(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  textOverflow: TextOverflow.ellipsis,
                  color: Palette.whiteColor),
            ),
          ],
        ),
        // bottom: AppBar(
        //   automaticallyImplyLeading: false,
        //   toolbarHeight: 70.h,
        //   backgroundColor: Palette.blackColor,
        //   titleSpacing: 0,
        //   title: TabBar(
        //     isScrollable: true,
        //     tabAlignment: TabAlignment.start,
        //     labelStyle:
        //         TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
        //     labelColor: Colors.white,
        //     unselectedLabelColor: const Color.fromARGB(255, 154, 146, 146),
        //     dividerColor: Colors.transparent,
        //     indicatorColor: Palette.greenColor,
        //     indicatorWeight: 3.5,
        //     indicatorSize: TabBarIndicatorSize.label,
        //     splashFactory: NoSplash.splashFactory,
        //     enableFeedback: true,
        //     tabs: [
        //       // "All" Tab added in front of existing newInterest tabs
        //       Tab(
        //           text:
        //               "All (${articleDisplayList.length})"), // Add the "All" tab and display the article count
        //       ...newsInterests.asMap().entries.map((entry) {
        //         String interest = entry.value;
        //         int categoryCount = articleDisplayList
        //             .where((article) => article.articleSource == interest)
        //             .length;
        //         return Tab(
        //           text: "$interest ($categoryCount)", // Display the count
        //         );
        //       }),
        //     ],
        //   ),
        // ),
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
          searchedArticles.when(data: (List<Article> articleData) {
            return ListView.builder(
              cacheExtent: 100,
              //Zero Padding Needed just needed to offset default value
              padding: 0.padV,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: articleData.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 13.h, horizontal: 25.w),
                  child: NewsListArticleItem(
                          imageHeroTag: 'homeScreentagImage$index',
                          articleImageUrlString:
                              articleData[index].urlToImage ??
                                  ViNewsAppImagesPath.defaultArticleImage,
                          articleTitle: articleData[index].title,
                          articleSource: articleData[index].source.name,
                          articleReleaseDate: formatDateString(
                              articleData[index].publishedAt.toString()),
                          articleDetailsTapAction: () {})
                      .inkTap(
                    splashColor: Palette.greyColor.withOpacity(0.2),
                    onTap: () {
                      context.pushNamed(
                        ViNewsAppRouteConstants.newsArticleReadView,
                        pathParameters: {
                          "articleImage": articleData[index].urlToImage ??
                              ViNewsAppImagesPath.defaultArticleImage,
                          "articleSource": articleData[index].source.name,
                          "heroTag": 'homeScreentagImage$index',
                          "articleTitle": articleData[index].title,
                          "articleAuthor": articleData[index].author ??
                              'No Author Mentioned',
                          "articlePublicationDate": formatDateString(
                              articleData[index].publishedAt.toString()),
                          "articleContent": articleData[index].content ??
                              ViNewsAppTexts.placeHolderArticleContent,
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
            return CircularProgressIndicator();
            // return ListView.separated(
            //   cacheExtent: 100,
            //   //Zero Padding Needed just needed to offset default value
            //   padding: 0.padV,
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   itemCount: 20,
            //   separatorBuilder:
            //       (BuildContext context, int index) {
            //     // Return a SizedBox with desired height as separator
            //     return 15.sbH;
            //   },
            //   itemBuilder: (BuildContext context, int index) {
            //     // Return your shimmer loader widget
            //     return getShimmerLoader();
            //   },
            // );
          }),
          // News Article Frosted Glass Preview Overlay
          // AnimatedOpacity(
          //     duration: const Duration(milliseconds: 400),
          //     opacity: isOverlayActive ? 1 : 0,
          //     child: Visibility(
          //       visible: isOverlayActive,
          //       child: ValueListenableBuilder(
          //           valueListenable: _selectedOptionIndexValueNotifier,
          //           builder:
          //               (BuildContext context, int value, Widget? child) {
          //             ArticleSelections articleOverlayDisplay =
          //                 articleDisplayList[
          //                     _selectedOptionIndexValueNotifier.value];
          //             return FrostedGlassBox(
          //                 theWidth: MediaQuery.of(context).size.width,
          //                 theHeight: MediaQuery.of(context).size.height,
          //                 theChildAlignment: MainAxisAlignment.end,
          //                 theChild: Padding(
          //                   padding: EdgeInsets.symmetric(
          //                       horizontal: 25.w, vertical: 15.h),
          //                   child: Container(
          //                     height: 590.h,
          //                     width: double.infinity,
          //                     decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(20.r),
          //                       color: Palette.greyColor.withOpacity(0.75),
          //                       image: const DecorationImage(
          //                         image: AssetImage(
          //                             ViNewsAppImagesPath.appBackgroundImage),
          //                         opacity: 0.15,
          //                         fit: BoxFit.cover,
          //                       ),
          //                     ),
          //                     child: Padding(
          //                       padding: 15.0.padA,
          //                       child: Column(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             articleOverlayDisplay.articleTitle
          //                                 .txtStyled(
          //                                     fontSize: 25.sp,
          //                                     fontWeight: FontWeight.w700,
          //                                     maxLines: 2,
          //                                     textOverflow:
          //                                         TextOverflow.ellipsis),
          //                             articleOverlayDisplay.articleDescription
          //                                 .txtStyled(
          //                                     fontSize: 18.sp,
          //                                     fontWeight: FontWeight.w500,
          //                                     maxLines: 3,
          //                                     textOverflow:
          //                                         TextOverflow.ellipsis),
          //                             Hero(
          //                               tag:
          //                                   'bookmarkedArticlesSearchScreenOverlaytagImage${_selectedOptionIndexValueNotifier.value}',
          //                               child: Container(
          //                                 width: double.infinity,
          //                                 height: 150.h,
          //                                 decoration: BoxDecoration(
          //                                   borderRadius:
          //                                       BorderRadius.circular(10.r),
          //                                   // color: Palette.greyColor,
          //                                 ),
          //                                 child: ClipRRect(
          //                                     borderRadius:
          //                                         BorderRadius.circular(10.r),
          //                                     child: ImageLoaderForOverlay(
          //                                         imageUrl:
          //                                             articleOverlayDisplay
          //                                                 .urlImage)),
          //                               ),
          //                             ),
          //                             Column(
          //                               children: [
          //                                 5.sbH,
          //                                 const Divider(
          //                                   thickness: 1.5,
          //                                 ),
          //                                 5.sbH
          //                               ],
          //                             ),
          //                             Row(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.spaceBetween,
          //                               children: [
          //                                 Row(
          //                                   children: [
          //                                     PhosphorIconsBold.megaphone
          //                                         .iconslide(size: 18.sp),
          //                                     7.sbW,
          //                                     articleOverlayDisplay
          //                                         .articleSource
          //                                         .txtStyled(
          //                                       fontSize: 18.sp,
          //                                       fontWeight: FontWeight.w600,
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 Row(
          //                                   children: [
          //                                     PhosphorIconsBold.clockCountdown
          //                                         .iconslide(size: 19.sp),
          //                                     5.sbW,
          //                                     "10 mins".txtStyled(
          //                                         fontSize: 18.sp,
          //                                         fontWeight: FontWeight.w500)
          //                                   ],
          //                                 )
          //                               ],
          //                             ),
          //                             Row(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.spaceBetween,
          //                               children: [
          //                                 Column(
          //                                   crossAxisAlignment:
          //                                       CrossAxisAlignment.start,
          //                                   children: [
          //                                     Row(
          //                                       children: [
          //                                         PhosphorIconsBold.tag
          //                                             .iconslide(size: 18.sp),
          //                                         7.sbW,
          //                                         Container(
          //                                           decoration: BoxDecoration(
          //                                             color:
          //                                                 Palette.blackColor,
          //                                             borderRadius:
          //                                                 BorderRadius
          //                                                     .circular(7.r),
          //                                           ),
          //                                           // News Article Category
          //                                           child: Padding(
          //                                             padding: 7.0.padA,
          //                                             child:
          //                                                 articleOverlayDisplay
          //                                                     .articleSource
          //                                                     .txtStyled(
          //                                               fontSize: 14.sp,
          //                                               color: Palette
          //                                                   .whiteColor,
          //                                               fontWeight:
          //                                                   FontWeight.w600,
          //                                             ),
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                     5.sbH,
          //                                     Row(
          //                                       children: [
          //                                         PhosphorIconsBold
          //                                             .paperPlaneTilt
          //                                             .iconslide(size: 18.sp),
          //                                         7.sbW,
          //                                         formattedDate.txtStyled(
          //                                           fontSize: 16.sp,
          //                                           fontWeight:
          //                                               FontWeight.w600,
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 Row(
          //                                   children: [
          //                                     PhosphorIconsBold.bookmarks
          //                                         .iconslide(size: 35.sp),
          //                                     5.sbW,
          //                                     PhosphorIconsBold.heartStraight
          //                                         .iconslide(size: 35.sp)
          //                                   ],
          //                                 )
          //                               ],
          //                             ),
          //                             Column(
          //                               children: [
          //                                 5.sbH,
          //                                 const Divider(
          //                                   thickness: 1.5,
          //                                 ),
          //                                 5.sbH
          //                               ],
          //                             ),
          //                             Row(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.center,
          //                               children: [
          //                                 ElevatedButton(
          //                                   onPressed: () {
          //                                     ref
          //                                         .read(
          //                                             likedArticlesScreenOverlayActiveProvider
          //                                                 .notifier)
          //                                         .update((state) => !state);
          //                                   },
          //                                   style: ElevatedButton.styleFrom(
          //                                     elevation: 0,
          //                                     fixedSize: Size(110.w, 45.w),
          //                                     backgroundColor:
          //                                         const Color.fromARGB(
          //                                             161, 237, 226, 226),
          //                                     side: BorderSide(
          //                                         width: 2.5.w,
          //                                         color: Palette.blackColor),
          //                                     shape: RoundedRectangleBorder(
          //                                       borderRadius:
          //                                           BorderRadius.circular(11),
          //                                     ),
          //                                   ),
          //                                   child: Row(
          //                                     mainAxisAlignment:
          //                                         MainAxisAlignment.center,
          //                                     children: [
          //                                       "Back".txtStyled(
          //                                         fontSize: 15.sp,
          //                                         fontWeight: FontWeight.w800,
          //                                         color: Palette.blackColor,
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ),
          //                                 17.sbW,
          //                                 ElevatedButton(
          //                                   onPressed: () {
          //                                     context.pushNamed(
          //                                         ViNewsAppRouteConstants
          //                                             .newsArticleReadView,
          //                                         pathParameters: {
          //                                           "articleImage":
          //                                               articleOverlayDisplay
          //                                                   .urlImage,
          //                                           "articleSource":
          //                                               articleOverlayDisplay
          //                                                   .articleSource,
          //                                           "heroTag":
          //                                               'bookmarkedArticlesSearchScreenOverlaytagImage${_selectedOptionIndexValueNotifier.value}',
          //                                           "articleTitle":
          //                                               articleOverlayDisplay
          //                                                   .articleTitle,
          //                                           "articleAuthor":
          //                                               articleOverlayDisplay
          //                                                   .articleSource,
          //                                           "articlePublicationDate":
          //                                               formattedDate
          //                                                   .toString()
          //                                         });
          //                                   },
          //                                   style: ElevatedButton.styleFrom(
          //                                     elevation: 0,
          //                                     fixedSize: Size(110.w, 45.w),
          //                                     backgroundColor:
          //                                         Palette.blackColor,
          //                                     shape: RoundedRectangleBorder(
          //                                       borderRadius:
          //                                           BorderRadius.circular(11),
          //                                     ),
          //                                   ),
          //                                   child: Row(
          //                                     mainAxisAlignment:
          //                                         MainAxisAlignment.center,
          //                                     children: [
          //                                       "Read".txtStyled(
          //                                         fontSize: 15.sp,
          //                                         fontWeight: FontWeight.w800,
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ),
          //                               ],
          //                             )
          //                           ]),
          //                     ),
          //                   ),
          //                 ));
          //           }),
          //     )),
        ]),
      ),
    );
  }
}
