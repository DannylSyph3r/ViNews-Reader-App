import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:vinews_news_reader/features/auth/controllers/auth_action_controllers.dart';
import 'package:vinews_news_reader/features/auth/states/login_state.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/vinews_icons.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_image_icon_button.dart';

var logger = Logger();
class EmailVerificationView extends ConsumerStatefulWidget {
  final String userEmailAddress;
  const EmailVerificationView({required this.userEmailAddress, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailVerificationViewState();
}

class _EmailVerificationViewState extends ConsumerState<EmailVerificationView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the periodic timer to check email verification status every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      ref.read(authNotifierProvider.notifier).checkEmailVerificationStatus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  void resendCodedButtonPress() {
    //Call onResendButtonPressed() to restart the timer and disable the button
    ref.read(authNotifierProvider.notifier).sendUserEmailVerificationLink();
    ref.read(resendTimerProvider.notifier).resetTimer();
  }

  String getFormattedRemainingTime(int remainingTime) {
    // Shows countdown timer for 2 minutes on the Resend Link Button
    if (remainingTime > 0) {
      final minutes = (remainingTime / 60).floor();
      final seconds = remainingTime % 60;
      return 'Resend Link in ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return 'Resend Link';
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UserAuthenticationState>(authNotifierProvider,
        (previous, state) {
      if (state is UserAuthenticationStateSuccess) {
        if (state.isEmailVerified == true) {
          logger.i("User email is verified via listener on email page");
          context.pushReplacementNamed(
              ViNewsAppRouteConstants.appNavigationBar);
        } else {
          logger.i("User email is not verified via listener on email page");
        }
      } else {
        context.pushReplacementNamed(ViNewsAppRouteConstants.authIntializer);
      }
    });
    final remainingTime = ref.watch(resendTimerProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only()
                  .padSpec(left: 25, top: 40, right: 25, bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ViNewsIcons.emailVerifyIcon.iconslide(size: 100),
                  10.sbH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      "Hey!".txtStyled(fontSize: 15.sp),
                      3.sbW,
                      widget.userEmailAddress.txtStyled(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ],
                  ),
                  20.sbH,
                  "Verify Your Email Address"
                      .txtStyled(fontSize: 25, fontWeight: FontWeight.bold),
                  15.sbH,
                  "We have just sent an email with a verfication link to your inbox. Please check your mail, and click on the link to verify your Email Address!"
                      .txtStyled(fontSize: 16.sp, textAlign: TextAlign.center),
                  30.sbH,
                  "You will be automatically redirected after verifying your Email ;)"
                      .txtStyled(fontSize: 16.sp, textAlign: TextAlign.center),
                  50.sbH,
                  // ViNewsAppImageIconButton(
                  //     onButtonPress: () {
                  //     },
                  //     buttonColor: Pallete.appButtonColor,
                  //     iconColor: Pallete.blackColor,
                  //     buttonPlaceholderText: "Continue",
                  //     isEnabled: true),
                  const Divider(
                    thickness: 1.5,
                  ),
                  18.sbH,
                  ViNewsAppImageIconButton(
                    onButtonPress: resendCodedButtonPress,
                    buttonColor: Pallete.appButtonColor,
                    iconColor: Pallete.blackColor,
                    buttonPlaceholderText: remainingTime == 0
                        ? "Resend Link"
                        : getFormattedRemainingTime(
                            remainingTime), // Pass isPinComplete value as !isPinComplete
                    isEnabled: remainingTime == 0
                        ? true
                        : false, // Enable the button when remainingTime is 0
                  ),
                  30.sbH,
                  GestureDetector(
                      onTap: () {
                        ref.read(resendTimerProvider.notifier).resetTimer();
                        ref.read(resendTimerProvider.notifier).pauseTimer();
                        ref.read(authNotifierProvider.notifier).userSignOut();
                        context.pushReplacementNamed(
                            ViNewsAppRouteConstants.authIntializer);
                      },
                      child: "Go Back to Login/Sign Up".txtStyled(
                          fontSize: 15.sp, color: Pallete.blueColor)),
                  150.sbH,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
