import 'package:doit/theme/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'text.dart';

enum DoItButtonType {
  Normal,
  Delete,
}

class DoItButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool loading;
  final DoItButtonType type;

  DoItButton({
    Key? key,
    required this.title,
    this.loading = false,
    required this.onPressed,
    this.type = DoItButtonType.Normal,
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
          color: this.type == DoItButtonType.Normal ? Colors.white : Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: ScalableText(
            this.title,
            style: AppTextStyles.button.copyWith(
              color: this.type == DoItButtonType.Normal
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
