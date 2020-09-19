import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  primaryColor: Colors.orange,
  primarySwatch: Colors.deepOrange,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryTextTheme: const TextTheme(
    headline6: TextStyle(
      color: Colors.white
    )
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.white
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 18,
      color: Colors.black,
    ),
    headline2: TextStyle(
      fontSize: 14,
    ),
    headline3: TextStyle(

    ),
    bodyText1: TextStyle(
      fontSize: 14,
    ),
  ),
);