import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vinews_news_reader/features/base_navbar/controller/bottom_nav_controller.dart';

class NavBarWidget extends ConsumerWidget {
  final NavItem navItem;
  const NavBarWidget({
    Key? key,
    required this.navItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int indexFromController = ref.watch(baseNavControllerProvider);
    return Container(
      alignment: Alignment.center,
      height: 70.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(
                  size: 25.0,
                  color: indexFromController == navItem.navEnum.index
                      ? const Color.fromARGB(255, 255, 246, 246)
                      : const Color.fromARGB(255, 143, 140, 140)),
              child: Icon(navItem.iconData),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 6.0),
          //   child: Material(
          //     type: MaterialType.transparency,
          //     child: FittedBox(
          //       child: Text(
          //         navItem.label,
          //         style: TextStyle(
          //           color: indexFromController == navItem.navEnum.index
          //               ? const Color.fromARGB(255, 255, 246, 246)
          //               : const Color.fromARGB(255, 143, 140, 140),
          //           fontWeight: FontWeight.w400,
          //           fontSize: 12.5,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
