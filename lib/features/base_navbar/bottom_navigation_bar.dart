import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/base_navbar/navigation_bar_build_widget.dart';
import 'package:vinews_news_reader/features/bookmarks/views/bookmarks_search_view.dart';
import 'package:vinews_news_reader/features/bookmarks/views/bookmarks_views.dart';
import 'package:vinews_news_reader/features/explore/views/explore_search_view.dart';
import 'package:vinews_news_reader/features/explore/views/explore_view.dart';
import 'package:vinews_news_reader/features/home/views/home_screen.dart';
import 'package:vinews_news_reader/features/settings/views/about_vinews_view.dart';
import 'package:vinews_news_reader/features/settings/views/liked_articles_view.dart';
import 'package:vinews_news_reader/features/settings/views/news_language_picker_screen.dart';
import 'package:vinews_news_reader/features/settings/views/read_articles_view.dart';
import 'package:vinews_news_reader/features/settings/views/user_account_view.dart';
import 'package:vinews_news_reader/features/settings/views/user_profile_settings.dart';
import 'package:vinews_news_reader/themes/color_pallete.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class ViNewsBottomNavBar extends ConsumerStatefulWidget {
  const ViNewsBottomNavBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViNewsBottomNavBarState();
}

class _ViNewsBottomNavBarState extends ConsumerState<ViNewsBottomNavBar> {
  final PersistentTabController _navController =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return const [
      UserHomePageView(),
      UserExploreView(),
      UserBookmarksView(),
      UserProfileSettingsView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarSelection() {
    return [
      PersistentBottomNavBarItem(
          icon: PhosphorIcons.fill.house.iconslide(),
          title: "Home",
          activeColorPrimary: Pallete.blackColor,
          inactiveColorPrimary: const Color.fromARGB(255, 142, 142, 142),
          inactiveColorSecondary: Pallete.greyColor,
          routeAndNavigatorSettings:
              RouteAndNavigatorSettings(initialRoute: '/', routes: {
            '/accountSettings': (context) => const UserAccountSettingsView(),
          })),
      PersistentBottomNavBarItem(
          icon: PhosphorIcons.fill.globeHemisphereWest.iconslide(),
          title: "Explore",
          activeColorPrimary: Pallete.blackColor,
          inactiveColorPrimary: const Color.fromARGB(255, 142, 142, 142),
          inactiveColorSecondary: Pallete.greyColor,
          routeAndNavigatorSettings:
              RouteAndNavigatorSettings(initialRoute: '/', routes: {
            '/exploreSearchScreen': (context) =>
                const ExploreScreenSearchView(),
          })),
      PersistentBottomNavBarItem(
          icon: PhosphorIcons.fill.bookmarks.iconslide(),
          title: "Bookmarks",
          activeColorPrimary: Pallete.blackColor,
          inactiveColorPrimary: const Color.fromARGB(255, 142, 142, 142),
          inactiveColorSecondary: Pallete.greyColor,
          routeAndNavigatorSettings:
              RouteAndNavigatorSettings(initialRoute: '/', routes: {
            '/bookmarkSearchScreen': (context) => const BookmarksSearchView(),
          })),
      PersistentBottomNavBarItem(
          icon: PhosphorIcons.fill.user.iconslide(),
          title: "Profile",
          activeColorPrimary: Pallete.blackColor,
          inactiveColorPrimary: const Color.fromARGB(255, 142, 142, 142),
          inactiveColorSecondary: Pallete.greyColor,
          routeAndNavigatorSettings:
              RouteAndNavigatorSettings(initialRoute: '/', routes: {
            'readArticles': (context) => const ReadArticlesView(),
            '/likedArticles': (context) => const LikedArticlesView(),
            '/accountSettings': (context) => const UserAccountSettingsView(),
            '/languageSelector': (context) => const NewsLanguageSelectorView(),
            '/aboutViNews': (context) => const AboutViNewsView(),
          })),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView.custom(
        context,
        controller: _navController,
        screens: _buildScreens(),
        items: _navBarSelection(),
        itemCount: 4,
        confineInSafeArea: true,
        handleAndroidBackButtonPress: true, 
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        popAllScreensOnTapOfSelectedTab: true,
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 250),
        ),
        navBarHeight: 80.h,
        customWidget: (navBarLineUp) => CustomNavBarStyle(
            _navController.index, _navBarSelection(), (index) {
          setState(() {
            navBarLineUp.onItemSelected?.call(index);
          });
        }),
      ),
    );
  }
}
