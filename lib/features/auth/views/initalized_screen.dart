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
          return const UserLoginView();
        } else {
          if (user.emailVerified == true) {
            return const ViNewsBottomNavBar();
          } else {
            // Send an email verification link first
            // Then redirect to the email verification screen
            return EmailVerificationView(
                userEmailAddress: user.email.toString());
          }
        }
      },
      error: ((error, stackTrace) => const UserLoginView()),
      loading: () => const ViNewsLoadingScreen(),
    );
  }
}
