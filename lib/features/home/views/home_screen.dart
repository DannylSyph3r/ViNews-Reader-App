import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vinews_news_reader/features/auth/controllers/auth_action_controllers.dart';
import 'package:vinews_news_reader/features/home/widgets/news_interests_modal.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';
import 'package:vinews_news_reader/utils/modal_bottom_sheet_util.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';
import 'package:vinews_news_reader/widgets/vinews_icon_buttons_icons.dart';

class UserHomePageView extends ConsumerStatefulWidget {
  const UserHomePageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserHomePageViewState();
}

class _UserHomePageViewState extends ConsumerState<UserHomePageView> {
  @override
  Widget build(BuildContext context) {
    final currentUserProvider = FirebaseAuth.instance.currentUser?.email;
    final currentUserEmailVerificationStatus =
        FirebaseAuth.instance.currentUser?.emailVerified;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only()
                .padSpec(left: 25, top: 30, right: 25, bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Home Screen"),
                15.sbH,
                Text(currentUserProvider.toString()),
                Text(currentUserEmailVerificationStatus.toString()),
                15.sbH,
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
                ViNewsAppIconButton(
                  onButtonPress: () {
                    showCustomModalBottomSheet(
                        context, false, const NewsInterestsModal());
                  },
                  buttonPlaceholderText: "Choose Interests",
                  isEnabled: true,
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
