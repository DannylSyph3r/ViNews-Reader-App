//! the state notifier provider for controlling the state of the base nav wrapper
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

final baseNavControllerProvider =
    StateNotifierProvider<BaseNavController, int>((ref) {
  return BaseNavController();
});

class BaseNavController extends StateNotifier<int> {
  BaseNavController() : super(0);

  void moveToPage({required int index}) {
    state = index;
  }
}

void moveToPage({
  required BuildContext context,
  required WidgetRef ref,
  required int index,
}) {
  ref.read(baseNavControllerProvider.notifier).moveToPage(index: index);
}

class NavItem {
  final Nav navEnum;
  final String label;
  final IconData iconData;

  const NavItem(this.navEnum, this.label, this.iconData);
}

final List<NavItem> navItems = [
  const NavItem(Nav.home, 'Home', PhosphorIconsFill.house),
  const NavItem(Nav.explore, 'Explore', PhosphorIconsFill.globeHemisphereWest),
  const NavItem(Nav.bookmarks, 'Bookmarks', PhosphorIconsFill.bookmarks),
  const NavItem(Nav.profile, 'Profile', PhosphorIconsFill.user),
];

enum Nav {
  home,
  explore,
  bookmarks,
  profile,
}
