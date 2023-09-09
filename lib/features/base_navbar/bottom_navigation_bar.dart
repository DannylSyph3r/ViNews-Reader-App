import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vinews_news_reader/features/bookmarks/views/bookmarks_views.dart';
import 'package:vinews_news_reader/features/explore/views/explore_view.dart';
import 'package:vinews_news_reader/features/home/views/home_screen.dart';
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
  List<Widget> pages = const [
    UserHomePageView(),
    UserExploreView(),
    UserBookmarksView(),
    UserProfileSettingsView()
  ];

  final ValueNotifier<int> _page = ValueNotifier(0);

  @override
  void initState() {
    _page.value = 0;
    super.initState();
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: _page,
          builder: (context, value, child) => pages[_page.value]),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: _page,
          builder: (context, value, child) => Material(
                  child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 88, 88, 88).withOpacity(
                            0.2), // Adjust opacity for desired effect
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: GNav(
                        tabBorderRadius: 22.5,
                        tabMargin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        backgroundColor: Pallete.transparent,
                        activeColor: Pallete.whiteColor,
                        tabBackgroundColor: Pallete.blackColor,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInToLinear,
                        gap: 8,
                        iconSize: 22,
                        selectedIndex: _page.value,
                        onTabChange: (index) {
                          _page.value = index;
                        },
                        tabs: [
                          GButton(
                            icon: PhosphorIcons.bold.house,
                            text: "Home",
                            textStyle: TextStyle(
                                fontSize: 14.sp, color: Pallete.whiteColor),
                            padding: 12.0.padA,
                          ),
                          GButton(
                            icon: PhosphorIcons.bold.globeHemisphereWest,
                            text: "Explore",
                            textStyle: TextStyle(
                                fontSize: 14.sp, color: Pallete.whiteColor),
                            padding: 12.0.padA,
                          ),
                          GButton(
                            icon: PhosphorIcons.bold.bookmarks,
                            text: "Bookmark",
                            textStyle: TextStyle(
                                fontSize: 14.sp, color: Pallete.whiteColor),
                            padding: 12.0.padA,
                          ),
                          GButton(
                            icon: PhosphorIcons.bold.user,
                            text: "Profile",
                            textStyle: TextStyle(
                                fontSize: 14.sp, color: Pallete.whiteColor),
                            padding: 12.0.padA,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ))),
    );
  }
}
