import 'package:doit/utils/constants.dart';
import 'package:flutter/material.dart';

class ScalableText extends StatelessWidget {
  final String title;
  final TextStyle? style;
  ScalableText(this.title, {Key? key, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double textScale =
        MediaQuery.of(context).size.width / AppSizeConstants.BaseScreenWidth;

    return Text(
      this.title,
      style: this.style,
      textScaleFactor: textScale,
    );
  }
}
