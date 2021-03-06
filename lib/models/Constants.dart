import 'package:flutter/material.dart';

String kDefaultProfilePicture = "https://www.pngkey.com/png/full/202-2024792_user-profile-icon-png-download-fa-user-circle.png";
Color primaryLight = Color(0xFF01A38B);
Color primaryMedium = Color(0xFF006455);
Color primaryDark = Color(0xFF003F35);
Color secondary = Colors.white;

ThemeData appTheme = ThemeData(
  textTheme: TextTheme(
    headline6: TextStyle(color: secondary, fontWeight: FontWeight.bold, fontSize: 15),
    headline3: TextStyle(color: primaryMedium, fontWeight: FontWeight.w700, fontSize: 20, fontFamily: 'Barlow'),
    headline1: TextStyle(color: primaryMedium, fontWeight: FontWeight.w900, fontSize: 45, fontFamily: 'Barlow'),
    bodyText2: TextStyle(color: secondary, fontSize: 15),
    subtitle2: TextStyle(color: Colors.redAccent)
  ),
  primaryColorLight: primaryLight,
  primaryColor: primaryMedium,
  primaryColorDark: primaryDark,
  accentColor: secondary,
  scaffoldBackgroundColor: secondary,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: primaryLight,
      onPrimary: secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: secondary,
      primary: primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
);
