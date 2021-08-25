import 'package:flutter/material.dart';

class BaseButton extends StatefulWidget {
  Widget child;
  Function() onPressed;

  final Duration duration = const Duration(milliseconds: 3000);
  final double opacity = 0.5;

  BaseButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  _BaseButtonState createState() {
    return _BaseButtonState();
  }
}

class _BaseButtonState extends State<BaseButton> {
  bool isDown = true;

  @override
  void initState() {
    super.initState();
    setState(() => isDown = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      onTapDown: (_) => setState(() => isDown = true),
      onTapUp: (_) => setState(() => isDown = false),
      onTapCancel: () => setState(() => isDown = false),
      child: AnimatedOpacity(
        child: widget.child,
        duration: widget.duration,
        opacity: isDown ? widget.opacity : 1,
      ),
    );
  }
}
