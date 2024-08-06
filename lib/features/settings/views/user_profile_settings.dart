import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:badges/badges.dart' as badges;
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/settings/widgets/settings_custom_divider.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/vinews_icons.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class UserProfileSettingsView extends ConsumerStatefulWidget {
  final VoidCallback showNavBar;
  final VoidCallback hideNavBar;
  const UserProfileSettingsView({
    super.key,
    required this.showNavBar,
    required this.hideNavBar,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileSettingsViewState();
}

class _UserProfileSettingsViewState
    extends ConsumerState<UserProfileSettingsView> {
  bool isToggled = false;
  final ScrollController _userProfileScrollController = ScrollController();
  @override
  void initState() {
    _userProfileScrollController.addListener(() {
      if (_userProfileScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavBar();
      } else {
        widget.hideNavBar();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _userProfileScrollController.removeListener(() {
      if (_userProfileScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavBar();
      } else {
        widget.hideNavBar();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      controller: _userProfileScrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            toolbarHeight: 90.h,
            backgroundColor: Palette.blackColor,
            elevation: 0,
            titleSpacing: 0,
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              // Show Page Title
              child: Row(
                children: [
                  PhosphorIconsRegular.user
                      .iconslide(color: Palette.whiteColor),
                  10.sbW,
                  "Profile".txtStyled(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: Palette.whiteColor),
                ],
              ),
            ),
            floating: true,
          ),
        ];
      },
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ViNewsAppImagesPath.appBackgroundImage,
            ),
            opacity: 0.15,
            fit: BoxFit.cover,
          ),
        ),
        child: Scrollbar(
          controller: _userProfileScrollController,
          interactive: true,
          thickness: 6,
          radius: Radius.circular(12.r),
          child: ListView(physics: const BouncingScrollPhysics(), children: [
            Center(
              child: Padding(
                padding: 25.0.padA,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: 5.0.padA,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              badges.Badge(
                                onTap: () {},
                                badgeContent: const Icon(
                                    PhosphorIconsFill.starAndCrescent),
                                position: badges.BadgePosition.custom(
                                    bottom: 5, end: -5),
                                badgeStyle: badges.BadgeStyle(
                                    badgeColor: Palette.greenColor,
                                    padding: 5.0.padA),
                                stackFit: StackFit.passthrough,
                                child: CircleAvatar(
                                  radius: 60.r,
                                  backgroundImage:
                                      const AssetImage("assets/images/pfp.jpg"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: 10.0.padA,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  "Akinola Daniel".txtStyled(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.w600)
                                ],
                              ),
                              10.sbH,
                              Row(
                                children: [
                                  "Avid Reader".txtStyled(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400)
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    20.sbH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Articles Read".txtStyled(
                                fontSize: 20.sp, fontWeight: FontWeight.w400),
                            7.sbH,
                            320.toString().txtStyled(
                                fontSize: 22.sp, fontWeight: FontWeight.w600)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Streak".txtStyled(
                                fontSize: 20.sp, fontWeight: FontWeight.w400),
                            7.sbH,
                            "125 Days".txtStyled(
                                fontSize: 22.sp, fontWeight: FontWeight.w600)
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Likes".txtStyled(
                                fontSize: 20.sp, fontWeight: FontWeight.w400),
                            7.sbH,
                            192.toString().txtStyled(
                                fontSize: 22.sp, fontWeight: FontWeight.w600)
                          ],
                        ),
                      ],
                    ),
                    30.sbH,
                    const CustomSettingsDivider(),
                    30.sbH,
                    Row(
                      children: [
                        "Reading History".txtStyled(
                            fontSize: 22.sp, fontWeight: FontWeight.w600),
                      ],
                    ),
                    20.sbH,
                    Column(
                      children: [
                        ListTile(
                          onTap: () => context.pushNamed(ViNewsAppRouteConstants
                              .userLikedArticlesRouteName),
                          contentPadding: 5.padH,
                          leading: PhosphorIconsFill.heartStraight
                              .iconslide(size: 25.sp),
                          title: "Liked Articles".txtStyled(fontSize: 18.sp),
                          trailing: PhosphorIconsBold.caretRight.iconslide(
                              size: 18.sp, color: Palette.blackColor),
                        ),
                        const CustomSettingsDivider(),
                      ],
                    ),
                    30.sbH,
                    Row(
                      children: [
                        "Settings".txtStyled(
                            fontSize: 22.sp, fontWeight: FontWeight.w600),
                      ],
                    ),
                    20.sbH,
                    Column(
                      children: [
                        ListTile(
                          onTap: () => context.pushNamed(ViNewsAppRouteConstants
                              .userAccountSettingsRouteName),
                          contentPadding: 5.padH,
                          leading:
                              PhosphorIconsFill.gear.iconslide(size: 25.sp),
                          title: "Account Settings".txtStyled(fontSize: 18.sp),
                          trailing: PhosphorIconsBold.caretRight.iconslide(
                              size: 18.sp, color: Palette.blackColor),
                        ),
                        const CustomSettingsDivider(),
                        // ListTile(
                        //   onTap: () => context.pushNamed(ViNewsAppRouteConstants.newsLanguageSelectorRouteName),
                        //   title: "News Language".txtStyled(fontSize: 18.sp),
                        //   trailing: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       "en".txtStyled(
                        //           fontSize: 18.sp, fontWeight: FontWeight.w400),
                        //       5.sbW,
                        //       PhosphorIconsBold.caretRight.iconslide(
                        //           size: 18.sp, color: Palette.blackColor),
                        //     ],
                        //   ),
                        // ),
                        // const CustomSettingsDivider(),
                        ListTile(
                          contentPadding: 5.padH,
                          leading:
                              PhosphorIconsFill.bell.iconslide(size: 25.sp),
                          title: "Notifications".txtStyled(fontSize: 18.sp),
                          trailing: SizedBox(
                            width: 60.w,
                            child: FlutterSwitch(
                                padding: 2,
                                height: 32.h,
                                width: 58.w,
                                activeColor: Palette.blackColor,
                                inactiveColor: Palette.greyColor,
                                activeIcon:
                                    ViNewsIcons.activeSwitchIcon.iconslide(),
                                inactiveIcon:
                                    ViNewsIcons.inactiveSwitchIcon.iconslide(),
                                value: isToggled,
                                onToggle: (value) {
                                  // PLACEHOLDER THIS IS THE WIDGET FOR NOTIFICATIONS
                                  // Define the callback function to update the boolean variable
                                  setState(() {
                                    isToggled = value;
                                  });
                                }),
                          ),
                        ),
                        const CustomSettingsDivider(),
                        ListTile(
                          onTap: () => context.pushNamed(ViNewsAppRouteConstants
                              .aboutViNewsScreenRouteName),
                          contentPadding: 5.padH,
                          leading:
                              PhosphorIconsFill.note.iconslide(size: 25.sp),
                          title: "About Us".txtStyled(fontSize: 18.sp),
                          trailing: PhosphorIconsBold.caretRight.iconslide(
                              size: 18.sp, color: Palette.blackColor),
                        ),
                        const CustomSettingsDivider(),
                        ListTile(
                          onTap: () => clearCache(),
                          contentPadding: 5.padH,
                          leading:
                              PhosphorIconsFill.trash.iconslide(size: 25.sp),
                          title: "Clear Cache".txtStyled(fontSize: 18.sp),
                          trailing: PhosphorIconsBold.caretRight.iconslide(
                              size: 18.sp, color: Palette.blackColor),
                        ),
                        const CustomSettingsDivider(),
                      ],
                    ),
                    100.sbH,
                    // Text(currentUserProvider.toString()),
                    // Text(currentUserEmailVerificationStatus.toString()),
                    // 15.sbH,
                    30.sbH,
                    // ViNewsAppIconButton(
                    //   onButtonPress: () {
                    //     showCustomModalBottomSheet(
                    //         context, false, const NewsInterestsModal());
                    //   },
                    //   buttonPlaceholderText: "Choose Interests",
                    //   isEnabled: true,
                    // )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    ));
  }

  void clearCache() {
    DefaultCacheManager().emptyCache();
    imageCache.clear();
    imageCache.clearLiveImages();
  }
}
