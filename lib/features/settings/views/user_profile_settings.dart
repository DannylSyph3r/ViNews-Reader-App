import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/settings/views/user_account_view.dart';
import 'package:vinews_news_reader/features/settings/widgets/settings_custom_divider.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/vinews_icons.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class UserProfileSettingsView extends ConsumerStatefulWidget {
  const UserProfileSettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileSettingsViewState();
}

class _UserProfileSettingsViewState
    extends ConsumerState<UserProfileSettingsView> {
  bool isToggled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
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
                  PhosphorIcons.regular.user.iconslide(),
                  10.sbW,
                  "Profile"
                      .txtStyled(fontSize: 22.sp, fontWeight: FontWeight.w600),
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
                              CircleAvatar(
                                radius: 60.r,
                                backgroundImage:
                                    const AssetImage("assets/images/pfp.jpg"),
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
                            430.toString().txtStyled(
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
                          title: "Read Articles".txtStyled(fontSize: 18.sp),
                          trailing: PhosphorIcons.bold.caretRight.iconslide(
                              size: 18.sp, color: Pallete.blackColor),
                        ),
                        const CustomSettingsDivider(),
                        ListTile(
                          title: "Liked Articles".txtStyled(fontSize: 18.sp),
                          trailing: PhosphorIcons.bold.caretRight.iconslide(
                              size: 18.sp, color: Pallete.blackColor),
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
                          onTap: () {
                            pushNewScreenWithRouteSettings(context,
                                screen: const UserAccountSettingsView(),
                                settings: const RouteSettings(
                                    name: "/profileAccount"));
                          },
                          title: "My Account".txtStyled(fontSize: 18.sp),
                          trailing: PhosphorIcons.bold.caretRight.iconslide(
                              size: 18.sp, color: Pallete.blackColor),
                        ),
                        const CustomSettingsDivider(),
                        ListTile(
                          title: "News Language".txtStyled(fontSize: 18.sp),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              "en".txtStyled(
                                  fontSize: 18.sp, fontWeight: FontWeight.w400),
                              5.sbW,
                              PhosphorIcons.bold.caretRight.iconslide(
                                  size: 18.sp, color: Pallete.blackColor),
                            ],
                          ),
                        ),
                        const CustomSettingsDivider(),
                        ListTile(
                          title: "Notifications".txtStyled(fontSize: 18.sp),
                          trailing: SizedBox(
                            width: 60.w,
                            child: FlutterSwitch(
                                padding: 2,
                                height: 32.h,
                                width: 58.w,
                                activeColor: Pallete.blackColor,
                                inactiveColor: Pallete.greyColor,
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
                          title: "About Us".txtStyled(fontSize: 18.sp),
                          trailing: PhosphorIcons.bold.caretRight.iconslide(
                              size: 18.sp, color: Pallete.blackColor),
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
          ),
        ),
      ),
    ));
  }
}
