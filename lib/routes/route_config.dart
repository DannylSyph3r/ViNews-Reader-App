import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vinews_news_reader/features/articles/views/news_article_view.dart';
import 'package:vinews_news_reader/features/auth/views/email_verification_view.dart';
import 'package:vinews_news_reader/features/auth/views/forgot_password_view.dart';
import 'package:vinews_news_reader/features/auth/views/initalized_screen.dart';
import 'package:vinews_news_reader/features/auth/views/login_view.dart';
import 'package:vinews_news_reader/features/auth/views/sign_up_view.dart';
import 'package:vinews_news_reader/features/base_navbar/bottom_navigation_bar.dart';
import 'package:vinews_news_reader/features/explore/views/explore_search_results_view.dart';
import 'package:vinews_news_reader/features/explore/views/explore_search_view.dart';
import 'package:vinews_news_reader/features/onboard/views/onboard_view.dart';
import 'package:vinews_news_reader/features/settings/views/about_vinews_view.dart';
import 'package:vinews_news_reader/features/settings/views/liked_articles_view.dart';
import 'package:vinews_news_reader/features/settings/views/news_language_picker_screen.dart';
import 'package:vinews_news_reader/features/settings/views/read_articles_view.dart';
import 'package:vinews_news_reader/features/settings/views/user_account_view.dart';
import 'package:vinews_news_reader/features/settings/views/user_news_interest.dart';
import 'package:vinews_news_reader/routes/route_constants.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/useronboard',
    routes: [
      GoRoute(
        name: ViNewsAppRouteConstants.onBoardRouteName,
        path: '/useronboard',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const OnboardView(),
            transitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // Slide from right
                  end: Offset.zero, // Slide to the center
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.authIntializer,
        path: '/auth',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const InitializedAuthScreen(),
            transitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // Slide from right
                  end: Offset.zero, // Slide to the center
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.userLoginScreenRouteName,
        path: '/userlogin',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const UserLoginView(),
            transitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // Slide from right
                  end: Offset.zero, // Slide to the center
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.userSignUpcreenRouteName,
        path: '/usersignup',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const UserSignUpView(),
            transitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // Slide from right
                  end: Offset.zero, // Slide to the center
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.appNavigationBar,
        path: '/appNavigationBar',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ViNewsBottomNavBar(),
            transitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // Slide from right
                  end: Offset.zero, // Slide to the center
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.forgotPasswordScreenRouteName,
        path: '/forgotpassword',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const ForgotPasswordView(),
            transitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // Slide from right
                  end: Offset.zero, // Slide to the center
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.emailVerificationScreenRouteName,
        path: '/verifyemail/:emailAddress',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: EmailVerificationView(
                userEmailAddress: state.pathParameters['emailAddress']!),
            transitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // Slide from right
                  end: Offset.zero, // Slide to the center
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.newsArticleReadView,
        path:
            '/articlereadview/:articleImage/:articleSource/:heroTag/:articleTitle/:articleAuthor/:articlePublicationDate/:articleContent',
        builder: (BuildContext context, GoRouterState state) {
          return NewsArticleReadView(
            articleImage: state.pathParameters['articleImage']!,
            articleSource: state.pathParameters['articleSource']!,
            heroTag: state.pathParameters['heroTag']!,
            articleTitle: state.pathParameters["articleTitle"]!,
            articleAuthor: state.pathParameters["articleAuthor"]!,
            articlePublicationDate:
                state.pathParameters["articlePublicationDate"]!,
            articleContent: state.pathParameters["articleContent"]!,
          );
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.userExploreSearchScreenRoute,
        path: '/userexploresearch',
        builder: (BuildContext context, GoRouterState state) {
          return const ExploreScreenSearchView();
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.userExploreSearchResultsRouteName,
        path: '/userexploresearchresults/:searchedWord',
        builder: (BuildContext context, GoRouterState state) {
          return ExploreSearchResultsView(
            searchedWord: state.pathParameters['searchedWord']!,
          );
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.newsInterestSelectionRouteName,
        path: '/newsinterestselection',
        builder: (BuildContext context, GoRouterState state) {
          return const NewsInterestSelectionView();
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.userAccountSettingsRouteName,
        path: '/useraccountsettings',
        builder: (BuildContext context, GoRouterState state) {
          return const UserAccountSettingsView();
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.newsLanguageSelectorRouteName,
        path: '/newslanguageselection',
        builder: (BuildContext context, GoRouterState state) {
          return const NewsLanguageSelectorView();
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.userReadArticlesRouteName,
        path: '/userreadarticles',
        builder: (BuildContext context, GoRouterState state) {
          return const ReadArticlesView();
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.userLikedArticlesRouteName,
        path: '/userlikedarticles',
        builder: (BuildContext context, GoRouterState state) {
          return const LikedArticlesView();
        },
      ),
      GoRoute(
        name: ViNewsAppRouteConstants.aboutViNewsScreenRouteName,
        path: '/aboutviNewsscreen',
        builder: (BuildContext context, GoRouterState state) {
          return const AboutViNewsView();
        },
      ),
    ],
    // errorBuilder: (context, state) => RouteErrorScreen(
    //       errorMessage: ViNewsAppTexts.routeErrorScreenMessage,
    //       key: state.pageKey,
    //     )
  );
});
