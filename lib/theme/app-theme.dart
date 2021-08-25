import 'package:doit/theme/text.dart';
import 'package:flutter/material.dart';

var appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  accentColor: Colors.black,
  textTheme: TextTheme(
    headline1: AppTextStyles.headline1,
    headline6: AppTextStyles.headline6,
    bodyText2: AppTextStyles.bodyText2,
    bodyText1: AppTextStyles.bodyText1,
    button: AppTextStyles.button,
    subtitle1: AppTextStyles.subtitle1,
  ),
);
