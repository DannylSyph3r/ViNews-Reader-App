import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/home/controllers/news_interest_controller.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class UserExploreView extends ConsumerStatefulWidget {
  const UserExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserExploreViewState();
}

class _UserExploreViewState extends ConsumerState<UserExploreView> {
  String formattedDate = DateFormat('E d MMM, y').format(DateTime.now());
  final _searchFieldController = TextEditingController();

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsInterests = ref.watch(newsInterestSelectionProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          90.h,
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.7),
              titleSpacing: 30.sp,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(25.r), // Adjust the radius as needed
                  bottomRight:
                      Radius.circular(25.r), // Adjust the radius as needed
                ),
              ),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  13.sbH,
                  "Explore"
                      .txtStyled(fontSize: 32.sp, fontWeight: FontWeight.w700),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only().padSpec(right: 30, top: 12),
                  child: PhosphorIcons.regular.magnifyingGlass
                      .iconslide(size: 30.sp),
                )
              ],
              elevation: 0,
            ),
          ),
        ),
      ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                150.sbH,
                SizedBox(
                  height: 50.h,
                  child: ListView(
                    physics: const PageScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (int index = 0; index < newsInterests.length; index++)
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
                                  fontSize: 15.5.sp,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: "Uncovering the Hidden Gems of the Amazon Forest"
                      .txtStyled(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                15.sbH,
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
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      PhosphorIcons.bold.dotsThree.iconslide(size: 27.sp),
                    ],
                  ),
                ),
                ListView.builder(
                    padding: 15.padV,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.w, vertical: 13.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 125.w,
                                  height: 110.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    // color: Pallete.greyColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Image.asset(
                                      "assets/images/news_2.jpg",
                                      fit: BoxFit.cover,
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
                                  "Chasing the Northern Lights: A Winter in Finland: Experience the Serenity of Japan's Traditional Countryside"
                                      .txtStyled(
                                    fontSize: 21.sp,
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
                                          PhosphorIcons.bold.clockCountdown
                                              .iconslide(size: 18.sp),
                                          7.sbW,
                                          formattedDate.txtStyled(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                      5.sbW,
                                      PhosphorIcons.bold.dotsThree
                                          .iconslide(size: 27.sp),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).onTap(() {
                          context.pushNamed(
                              ViNewsAppRouteConstants.newsArticleReadView);
                        }),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
