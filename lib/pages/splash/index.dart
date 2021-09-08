import 'dart:async';
import 'dart:convert';

import 'package:doit/models/quote.dart';
import 'package:doit/shared/widgets/pulse-wdget.dart';
import 'package:doit/shared/widgets/text.dart';
import 'package:doit/theme/text.dart';
import 'package:doit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void navigate(bool first, Object? data) {
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(
        context,
        first ? AppConstants.Index : AppConstants.Home,
        arguments: data,
      ),
    );
  }

  Future<void> fetchQuote() async {
    String apiEndpoint = "https://quotes.rest/qod?category=inspire&language=en";
    final translator = GoogleTranslator();
    var url = Uri.parse(apiEndpoint);

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedQuote = prefs.getString(formattedDate) ?? "none";

    bool firstTime = prefs.getBool('IsFirsTime') ?? true;
    if (firstTime) await prefs.setBool('IsFirsTime', false);

    if (savedQuote != "none") {
      navigate(firstTime, Quote.fromJson(jsonDecode(savedQuote)));
      return;
    }

    try {
      var response = await http.get(url);
      var quoteString = await translator.translate(
        jsonDecode(response.body)["contents"]["quotes"][0]["quote"],
        from: 'en',
        to: 'pt',
      );

      var data = {
        "quote": quoteString.text,
        "author": jsonDecode(response.body)["contents"]["quotes"][0]["author"],
      };

      // save to prefs
      await prefs.setString(formattedDate, jsonEncode(data));

      navigate(firstTime, Quote.fromJson(data));
      return;
    } catch (error) {
      print(error);
      // TODO: make error page!
      navigate(firstTime, null);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: PulsingWidget(
            child: ScalableText(
              'DoIt',
              style: AppTextStyles.appTitle.copyWith(
                fontSize: 72,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
