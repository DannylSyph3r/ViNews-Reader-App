import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/core/controllers/app_providers.dart';
import 'package:vinews_news_reader/features/base_navbar/controller/bottom_nav_controller.dart';
import 'package:vinews_news_reader/features/base_navbar/navigation_bar_build_widget.dart';
import 'package:vinews_news_reader/features/bookmarks/views/bookmarks_views.dart';
import 'package:vinews_news_reader/features/explore/views/explore_view.dart';
import 'package:vinews_news_reader/features/home/views/home_screen_listview.dart';
import 'package:vinews_news_reader/features/settings/views/user_profile_settings.dart';
import 'package:vinews_news_reader/themes/color_scheme_palette.dart';
import 'package:vinews_news_reader/utils/nav_utils.dart';
import 'package:vinews_news_reader/utils/widget_extensions.dart';

class ViNewsBottomNavBar extends ConsumerStatefulWidget {
  const ViNewsBottomNavBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViNewsBottomNavBarState();
}

class _ViNewsBottomNavBarState extends ConsumerState<ViNewsBottomNavBar> {
  final ValueNotifier<bool> navBarVisible = true.notifier;

  @override
  void dispose() {
    navBarVisible.dispose();
    super.dispose();
  }

  void hideNav() {
    navBarVisible.value = false;
  }

  void showNav() {
    navBarVisible.value = true;
  }

  @override
  Widget build(BuildContext context) {
    int indexFromController = ref.watch(baseNavControllerProvider);
    return WillPopScope(
      onWillPop: stopWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: indexFromController,
          children: [
            UserHomePageView(
              hideNavBar: hideNav,
              showNavBar: showNav,
            ),
            UserExploreView(
              hideNavBar: hideNav,
              showNavBar: showNav,
            ),
            UserBookmarksView(
              hideNavBar: hideNav,
              showNavBar: showNav,
            ),
            UserProfileSettingsView(
              hideNavBar: hideNav,
              showNavBar: showNav,
            )
          ],
        ),
        bottomNavigationBar:
            navBarVisible.sync(builder: (context, isVisible, child) {
          return AnimatedContainer(
            duration: 500.milliseconds,
            curve: Curves.easeInOut,
            height: isVisible ? 80.h : 0,
            child: Material(
              elevation: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.r),
                  topRight: Radius.circular(25.r),
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 60.w, right: 60.w),
                  color: Palette.blackColor,
                  height: 70.h,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      navItems.length, // Use navItems instead of nav
                      (index) => NavBarWidget(navItem: navItems[index]).inkTap(
                          onTap: () {
                        moveToPage(
                          context: context,
                          ref: ref,
                          index: index,
                        );
                        index != 0
                            ? ref.invalidate(homeScreenOverlayActiveProvider)
                            : null;
                        index != 1
                            ? ref.invalidate(exploreScreenOverlayActiveProider)
                            : null;
                        index != 2
                            ? ref.invalidate(
                                bookmarksScreenOverlayActiveProvider)
                            : null;
                      }), // Pass navItem
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
