import 'package:flutter/material.dart';

class Pallete {
  static const blackColor = Color.fromRGBO(1, 1, 1, 1);
  static const whiteColor = Color.fromARGB(255, 226, 226, 226);
  static const blueColor = Color.fromARGB(255, 0, 140, 255);
  static const onboardDescTxtColor = Color(0xFF606060);
  static const greyColor = Color.fromARGB(255, 212, 206, 206);
  static const greenColor = Color.fromARGB(255, 0, 253, 8);
  static const transparent = Colors.transparent;
  static const buttonOutineColorBlack = Color.fromRGBO(1, 1, 1, 1);
  static const buttonOutineColorWhite = Colors.white;
  static const appButtonColor = Color(0xFF151924);
  static const appButtonShadowColor = Color(0x3A000000);
  static const redColor = Color.fromARGB(255, 255, 17, 0);
  static const whiteTextColor = Colors.white;
  static const textFieldColor = Color.fromARGB(255, 105, 105, 105);
  static const textFieldOutlineColor = Colors.grey;
  static const scaffoldLightModeCOlor = Color(0xFFEFEFEB);

  static var darkModeTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: blackColor,
    appBarTheme: const AppBarTheme(backgroundColor: blackColor, elevation: 0),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: blackColor, elevation: 0),
    colorScheme:
        const ColorScheme.dark(secondary: greyColor, background: blackColor),
  );

  static var lightModeTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: whiteColor,
    appBarTheme: const AppBarTheme(
        backgroundColor: transparent,
        elevation: 0,
        titleTextStyle: TextStyle(color: blackColor),
        iconTheme: IconThemeData(color: blackColor)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(elevation: 0),
    colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        secondary: greyColor,
        background: whiteColor),
  );
}