import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/auth/controllers/auth_action_controllers.dart';
import 'package:vinews_news_reader/features/home/widgets/news_interests_modal.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/modal_bottom_sheet_util.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_icon_buttons_icons.dart';

class UserProfileSettingsView extends ConsumerStatefulWidget {
  const UserProfileSettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileSettingsViewState();
}

class _UserProfileSettingsViewState
    extends ConsumerState<UserProfileSettingsView> {
  @override
  Widget build(BuildContext context) {
    final currentUserProvider = FirebaseAuth.instance.currentUser?.email;
    final currentUserEmailVerificationStatus =
        FirebaseAuth.instance.currentUser?.emailVerified;
    return Scaffold(
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
        child: SafeArea(
            child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only()
                  .padSpec(left: 25, top: 30, right: 25, bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  20.sbH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: 10.0.padA,
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
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w600)
                              ],
                            ),
                            10.sbH,
                            Row(
                              children: [
                                "Avid Reader".txtStyled(
                                    fontSize: 24.sp,
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
                              fontSize: 25.sp, fontWeight: FontWeight.w600)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Claps".txtStyled(
                              fontSize: 20.sp, fontWeight: FontWeight.w400),
                          7.sbH,
                          430.toString().txtStyled(
                              fontSize: 25.sp, fontWeight: FontWeight.w600)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Streak".txtStyled(
                              fontSize: 20.sp, fontWeight: FontWeight.w400),
                          7.sbH,
                          "125 Days".txtStyled(
                              fontSize: 25.sp, fontWeight: FontWeight.w600)
                        ],
                      )
                    ],
                  ),
                  30.sbH,
                  const Divider(
                    color: Pallete.greyColor,
                    thickness: 1,
                  ),
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
                        title: "Liked Articles".txtStyled(fontSize: 20.sp),
                        trailing: PhosphorIcons.bold.caretRight
                            .iconslide(size: 20.sp, color: Pallete.blackColor),
                      ),
                      ListTile(
                        title: "Clapped Articles".txtStyled(fontSize: 20.sp),
                        trailing: PhosphorIcons.bold.caretRight
                            .iconslide(size: 20.sp, color: Pallete.blackColor),
                      ),
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
                        title: "My Account".txtStyled(fontSize: 20.sp),
                        trailing: PhosphorIcons.bold.caretRight
                            .iconslide(size: 20.sp, color: Pallete.blackColor),
                      ),
                      ListTile(
                        title: "Notifications".txtStyled(fontSize: 20.sp),
                        trailing: PhosphorIcons.bold.caretRight
                            .iconslide(size: 20.sp, color: Pallete.blackColor),
                      ),
                      ListTile(
                        title: "About Us".txtStyled(fontSize: 20.sp),
                        trailing: PhosphorIcons.bold.caretRight
                            .iconslide(size: 20.sp, color: Pallete.blackColor),
                      ),
                    ],
                  ),
                  100.sbH,
                  // Text(currentUserProvider.toString()),
                  // Text(currentUserEmailVerificationStatus.toString()),
                  // 15.sbH,
                  InkWell(
                    child: ViNewsAppIconButton(
                      onButtonPress: () {
                        ref.read(authNotifierProvider.notifier).userSignOut();
                        context.pushReplacementNamed(
                            ViNewsAppRouteConstants.authIntializer);
                      },
                      buttonPlaceholderText: "Log Out",
                      isEnabled: true,
                    ),
                  ),
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
        )),
      ),
    );
  }
}
