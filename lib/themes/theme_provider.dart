import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinews_news_reader/themes/color_palette.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({ThemeMode mode = ThemeMode.dark})
      : _mode = mode,
        super(
          Palette.darkModeTheme,
        ) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    if (theme == 'lightTheme') {
      _mode = ThemeMode.light;
      state = Palette.lightModeTheme;
    } else {
      _mode = ThemeMode.dark;
      state = Palette.darkModeTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = Palette.lightModeTheme;
      prefs.setString('theme', 'lightTheme');
    } else {
      _mode = ThemeMode.dark;
      state = Palette.darkModeTheme;
      prefs.setString('theme', 'darkTheme');
    }
  }
}