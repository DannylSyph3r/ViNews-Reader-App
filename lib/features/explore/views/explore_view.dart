import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/core/provider/news_interest_provider.dart';
import 'package:vinews_news_reader/features/explore/views/explore_search_view.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_search_text_fields.dart';

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
    final newsInterests = ref.watch(newsInterestSelectionProvider);
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
                    PhosphorIcons.regular.globeHemisphereWest.iconslide(),
                    10.sbW,
                    "Explore".txtStyled(
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
                    tag: 'exploreSearchHeroTag',
                    child: Stack(
                      children: [
                        ViNewsSearchTextField(
                            textfieldHeight: 65.h,
                            controller: _exploreSearchFieldController,
                            hintText: "Explore News & Articles",
                            obscureText: false,
                            prefixIcon: PhosphorIcons.regular.magnifyingGlass
                                .iconslide(
                                    size: 26.sp, color: Pallete.blackColor)),
                        GestureDetector(
                          onTap: () {
                            navigateToExploreSearchScreen(context);
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
              child: Padding(
                padding: const EdgeInsets.only().padSpec(top: 30, bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50.h,
                      // Horizontal ListView for news Interest Selection
                      child: ListView(
                        physics: const PageScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          for (int index = 0;
                              index < newsInterests.length;
                              index++)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Pallete.greyColor,
                                  borderRadius: BorderRadius.circular(27.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    newsInterests[index].txtStyled(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Pallete.appButtonColor,
                                    ),
                                  ],
                                ),
                              ).onTap(() {
                                // Add your onTap logic here
                              }),
                            ),
                        ],
                      ),
                    ),
                    25.sbH,
                    // Explore page HeadLiner News Image
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
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
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
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
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
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
                                            "assets/images/news_2.jpg",
                                        "heroTag": 'exploreScreentagImage$index'
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
                                              child: Image.asset(
                                                "assets/images/news_2.jpg",
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
                                          "Chasing the Northern Lights: A Winter in Finland: Experience the Serenity of Japan's Traditional Countryside"
                                              .txtStyled(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w700,
                                            maxLines: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                          ),
                                          15.sbH,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                    fontWeight: FontWeight.w600,
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
    );
  }

  void navigateToExploreSearchScreen(BuildContext context) {
    pushNewScreenWithRouteSettings(context,
        screen: const ExploreScreenSearchView(),
        settings: const RouteSettings(name: "/exploreSearch"));
  }
}
