import 'package:doit/shared/widgets/base-button.dart';
import 'package:flutter/material.dart';

class DoitCheckbox extends StatefulWidget {
  bool value;
  Function(bool value)? onValueChanged;
  DoitCheckbox({Key? key, required this.value, this.onValueChanged})
      : super(key: key);

  @override
  _DoitCheckboxState createState() => _DoitCheckboxState();
}

class _DoitCheckboxState extends State<DoitCheckbox> {
  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: () {
        this.widget.onValueChanged!(!this.widget.value);
      },
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: widget.value ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Center(
          child: Icon(
            Icons.check,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
