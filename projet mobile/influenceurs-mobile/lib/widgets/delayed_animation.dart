import 'package:flutter/material.dart';
import 'dart:async';

class DelayedAnimation extends StatefulWidget {
  final Widget child;
  final int delay; //Délai d'apparition du Widget

  const DelayedAnimation({super.key, required this.child, required this.delay});

  @override
  State<DelayedAnimation> createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync:
          this, //Pour synchroniser différentes annimations les unes avec les autres
      duration: const Duration(milliseconds: 800),
    );
    final curve =
        CurvedAnimation(parent: _controller, curve: Curves.decelerate);
//Préciser début et fin de l'annimation
    _animOffset = Tween<Offset>(
      begin: const Offset(0.0, -0.35),
      end: Offset.zero,
    ).animate(curve);
//Controller la durée d'apparition du Widget
    Timer(Duration(milliseconds: widget.delay), () {
      // if (_controller.isDismissed) return;
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}
