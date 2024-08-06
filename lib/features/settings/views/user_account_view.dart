import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/auth/controllers/auth_action_controllers.dart';
import 'package:vinews_news_reader/features/auth/states/login_state.dart';
import 'package:vinews_news_reader/features/settings/widgets/settings_custom_divider.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/banner_util.dart';
import 'package:vinews_news_reader/widgets/frosted_glass_box.dart';
import 'package:vinews_news_reader/utils/vinews_images_path.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class UserAccountSettingsView extends ConsumerStatefulWidget {
  const UserAccountSettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserAccountSettingsViewState();
}

class _UserAccountSettingsViewState
    extends ConsumerState<UserAccountSettingsView> {
  final ValueNotifier<bool> loadingOverlayActive = false.notifier;

  @override
  Widget build(BuildContext context) {
    // Handling Loading State for user logout
    ref.listen<UserAuthenticationState>(authNotifierProvider,
        (previous, state) {
      if (state is UserAuthenticationStateLoading) {
        loadingOverlayActive.value = true;
      } else {
        loadingOverlayActive.value = false;
      }
      if (state is UserAuthenticationStateError) {
        loadingOverlayActive.value = false;
        showMaterialBanner(
            context, "Something happened :(", state.error, Palette.blackColor);
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.blackColor,
        elevation: 0,
        centerTitle: true,
        leading: PhosphorIconsBold.arrowLeft
            .iconslide(size:25.sp, color: Palette.whiteColor)
            .inkTap(onTap: () => context.pop()),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Account Settings"
                .txtStyled(fontSize: 18.sp, color: Palette.whiteColor),
            5.sbW,
            PhosphorIconsFill.gear
                .iconslide(size: 19.sp, color: Palette.whiteColor),
          ],
        ),
      ),
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
          child: Stack(children: [
            Scrollbar(
              interactive: true,
              thickness: 6,
              radius: Radius.circular(12.r),
              child:
                  ListView(physics: const BouncingScrollPhysics(), children: [
                Center(
                    child: Padding(
                  padding: 25.0.padA,
                  child: Column(
                    children: [
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Email Address".txtStyled(fontSize: 18.sp),
                            7.sbH,
                            "d********001@gmail.com".txtStyled(fontSize: 15.sp)
                          ],
                        ),
                        trailing: PhosphorIconsBold.caretRight
                            .iconslide(size: 18.sp, color: Palette.blackColor),
                      ),
                      // const CustomSettingsDivider(),
                      // ListTile(
                      //   onTap: () {
                      //     context.pushNamed(ViNewsAppRouteConstants
                      //         .newsInterestSelectionRouteName);
                      //   },
                      //   title: "Customize News Interests"
                      //       .txtStyled(fontSize: 18.sp),
                      //   trailing: PhosphorIconsBold.caretRight
                      //       .iconslide(size: 18.sp, color: Palette.blackColor),
                      // ),
                      const CustomSettingsDivider(),
                      ListTile(
                        title: "Change Password".txtStyled(fontSize: 18.sp),
                        trailing: PhosphorIconsBold.caretRight
                            .iconslide(size: 18.sp, color: Palette.blackColor),
                      ),
                      const CustomSettingsDivider(),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Delete Account".txtStyled(
                                fontSize: 18.sp, color: Palette.redColor),
                            7.sbH,
                            "Permanently delete your account."
                                .txtStyled(fontSize: 15.sp)
                          ],
                        ),
                        trailing: PhosphorIconsBold.caretRight
                            .iconslide(size: 18.sp, color: Palette.blackColor),
                      ),
                      const CustomSettingsDivider(),
                      ListTile(
                        onTap: () {
                          ref.read(authNotifierProvider.notifier).userSignOut();
                          context.pushReplacementNamed(
                              ViNewsAppRouteConstants.authIntializer);
                        },
                        title: "Log out".txtStyled(fontSize: 18.sp),
                        trailing: PhosphorIconsBold.caretRight
                            .iconslide(size: 18.sp, color: Palette.blackColor),
                      ),
                    ],
                  ),
                )),
              ]),
            ),
            loadingOverlayActive.sync(
              builder: (context, isVisible, child) {
                return Visibility(
                  visible: isVisible,
                  child: Positioned.fill(
                    child: FrostedGlassBox(
                      theWidth: MediaQuery.of(context).size.width,
                      theHeight: MediaQuery.of(context).size.height,
                      theChild: SpinKitFadingCircle(
                        color: Palette.blackColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                );
              },
            )
          ])),
    );
  }
}
