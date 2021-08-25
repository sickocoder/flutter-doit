import 'package:doit/theme/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'text.dart';

class DoItButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool loading;

  DoItButton({
    Key? key,
    required this.title,
    this.loading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: 0.9,
      onPressed: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 48.0,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: ScalableText(
            this.title,
            style: AppTextStyles.button,
          ),
        ),
      ),
    );
  }
}
