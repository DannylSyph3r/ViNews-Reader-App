import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinews_news_reader/features/auth/controllers/auth_controllers.dart';
import 'package:vinews_news_reader/features/auth/views/email_verification_view.dart';
import 'package:vinews_news_reader/features/auth/views/login_view.dart';
import 'package:vinews_news_reader/features/base_navbar/bottom_navigation_bar.dart';
import 'package:vinews_news_reader/widgets/loading_screen.dart';

class InitializedAuthScreen extends ConsumerWidget {
  const InitializedAuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // Send user to Login Screen if no one is logged in
          return const UserLoginView();
        } else {
          if (user.emailVerified == true) {
            // If the user's email is confirmed verified via Firebase send them to the Home Screen 
            return const ViNewsBottomNavBar();
          } else {
            // If user's email is not verified
            // Send an email verification link first
            // Then redirect to the email verification screen
            return EmailVerificationView(
                userEmailAddress: user.email.toString());
          }
        }
      },
      // In the case of an error send them to the Login Screen.
      error: ((error, stackTrace) => const UserLoginView()),
      // Loading Screen purely for courtesy you never see it because i dont use a StreamBuilder.
      loading: () => const ViNewsLoadingScreen(),
    );
  }
}
