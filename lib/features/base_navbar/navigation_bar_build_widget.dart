import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class CustomNavBarStyle extends ConsumerWidget {
  final int selectedIndex;
  final List<PersistentBottomNavBarItem> navBarItems;
  final ValueChanged<int>? onItemSelected;
  const CustomNavBarStyle(
      this.selectedIndex, this.navBarItems, this.onItemSelected,
      {super.key});

  Widget _buildNavbarItem(
      PersistentBottomNavBarItem item, bool isItemSelected) {
    return Container(
      alignment: Alignment.center,
      height: kBottomNavigationBarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(
                  size: 26.0,
                  color: isItemSelected
                      ? (item.activeColorSecondary ?? item.activeColorPrimary)
                      : item.inactiveColorPrimary ?? item.activeColorPrimary),
              child:
                  isItemSelected ? item.icon : item.inactiveIcon ?? item.icon,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Material(
              type: MaterialType.transparency,
              child: FittedBox(
                child: Text(
                  item.title ?? "",
                  style: TextStyle(
                      color: isItemSelected
                          ? (item.activeColorSecondary ??
                              item.activeColorPrimary)
                          : item.inactiveColorPrimary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        topRight: Radius.circular(20.r),
      ),
      child: Container(
        color: const Color.fromARGB(255, 176, 171, 171).withOpacity(0.3),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navBarItems.map((item) {
              int index = navBarItems.indexOf(item);
              return Expanded(
                child: InkWell(
                  onTap: () {
                    onItemSelected?.call(index);
                  },
                  child: _buildNavbarItem(item, selectedIndex == index),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
