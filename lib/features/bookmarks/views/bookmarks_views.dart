import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/bookmarks/views/bookmarks_search_view.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_search_text_fields.dart';

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
    return Scaffold(
      body: NestedScrollView(
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
                    "BookMarks".txtStyled(
                        fontSize: 24.sp, fontWeight: FontWeight.w600),
                  ],
                ),
              ),
              // Search Bar pinned on Sliver Collapse
              bottom: AppBar(
                toolbarHeight: 115.h,
                backgroundColor: Pallete.blackColor,
                titleSpacing: 0,
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  // Search bar Textfield Widget
                  child: Hero(
                    tag: 'bookmarksSearchHeroTag',
                    child: Stack(
                      children: [
                        ViNewsSearchTextField(
                            textfieldHeight: 65.h,
                            controller: _searchBookmarksFieldController,
                            hintText: "Explore News & Articles",
                            obscureText: false,
                            prefixIcon: PhosphorIcons.regular.magnifyingGlass
                                .iconslide(
                                    size: 26.sp, color: Pallete.blackColor)),
                        GestureDetector(
                          onTap: () {
                            navigateToBookmarksSearchScreen(context);
                          },
                          child: Container(
                            height: 65.h,
                            width: double.infinity,
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              pinned: true,
              floating: true,
            )
          ];
        },
        // Background image // Offseted by NestedScrollView
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/background.png",
              ),
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
                  padding: const EdgeInsets.only().padSpec(top: 30, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // News Article ListView
                      ListView.builder(
                        padding: 0
                            .padV, //Zero Padding Needed just needed to offset default value
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            20, // The number of times you want to duplicate the widget
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: const EdgeInsets.only().padSpec(
                                  top: 13, bottom: 13, right: 25, left: 25),
                              child: GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                        ViNewsAppRouteConstants
                                            .newsArticleReadView,
                                        pathParameters: {
                                          "articleImage":
                                              "assets/images/news_7.jpg",
                                          "heroTag":
                                              'bookmarksScreentagImage$index'
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
                                                    BorderRadius.circular(10.r),
                                                // color: Pallete.greyColor,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                child: Image.asset(
                                                  "assets/images/news_7.jpg",
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
                                            "Let’s settle the debate: IOS vs Androidz Consumer verdict"
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
                                                        .iconslide(size: 18.sp),
                                                    7.sbW,
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Pallete
                                                            .appButtonColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.r),
                                                      ),
                                                      child: Padding(
                                                        // News Article Category
                                                        padding: 6.0.padA,
                                                        child:
                                                            "Science".txtStyled(
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
    );
  }

  void navigateToBookmarksSearchScreen(BuildContext context) {
    pushNewScreenWithRouteSettings(context,
        screen: const BookmarksSearchView(),
        settings: const RouteSettings(name: "/bookmarksSearch"));
  }
}
