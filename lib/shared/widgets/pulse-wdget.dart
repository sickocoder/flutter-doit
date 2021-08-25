/// Uses fade animation to 'pulse'/'flicker' a widget.
/// [child] - Widget to apply pulse to
/// [duration] - Duration of pulse from low to bright and back to low (default: [Duration(milliseconds 1500)])
/// [tween] - Tween<double> of (0.0 to 1.0) for the pulse alpha (default: [Tween(begin: 0.25, end: 1.0)])
import 'package:flutter/material.dart';

class PulsingWidget extends StatefulWidget {
  final Tween<double>? tween;
  final Widget child;
  final Duration? duration;

  const PulsingWidget({
    required this.child,
    this.duration,
    this.tween,
  });

  _PulsingWidget createState() => _PulsingWidget();
}

class _PulsingWidget extends State<PulsingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Duration _duration;
  late Tween<double> _tween;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _tween = widget.tween ?? Tween(begin: 0.25, end: 1.0);
    _duration = widget.duration ?? Duration(milliseconds: 1500);
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
    );
    final CurvedAnimation curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
    _animation = _tween.animate(curve);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
