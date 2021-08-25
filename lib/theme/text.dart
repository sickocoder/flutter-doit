import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextStyle headline1 = GoogleFonts.ubuntu(
    fontSize: 66.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle headline6 = GoogleFonts.ubuntu(
    fontSize: 30.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static final TextStyle bodyText2 = GoogleFonts.ubuntu(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static final TextStyle bodyText1 = GoogleFonts.ubuntu(
    fontSize: 26.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static final TextStyle button = GoogleFonts.ubuntu(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static final TextStyle subtitle1 = GoogleFonts.ubuntu(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
    color: Color(0xFF828282),
  );

  static final TextStyle inputText = GoogleFonts.ubuntu(
    fontSize: 22.0,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle formTitleText = GoogleFonts.ubuntu(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle formReminderText = GoogleFonts.ubuntu(
    fontSize: 16.0,
    fontWeight: FontWeight.w300,
  );

  static final TextStyle appTitle = TextStyle(
    fontFamily: 'StyleScript',
    fontSize: 35,
    color: Colors.white,
  );
}
