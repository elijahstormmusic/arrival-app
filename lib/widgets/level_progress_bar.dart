/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import '../adobe/pinned.dart';
import '../styles.dart';


class _GrowTransition extends StatelessWidget {
  _GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) => AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Container(
                  height: 9.0,
                  width: animation.value,
                  child: child,
                  alignment: Alignment.centerLeft,
                ),
            child: child,
      );
}

class LevelProgress extends StatefulWidget {
  double progress;

  LevelProgress(this.progress);

  _LevelProgressState createState() => _LevelProgressState();
}

class _LevelProgressState extends State<LevelProgress> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  Animation curve;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = Tween<double>(begin: 0, end: 215.0 * widget.progress).animate(curve);
    controller.forward();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Styles.ArrivalPalletteWhite,
            border: Border.all(width: 1.0, color: const Color(0xff707070)),
          ),
          width: 215.0,
          height: 9.0,
        ),
        _GrowTransition(
          child: Container(
            decoration: BoxDecoration(
              color: Styles.ArrivalPalletteRed,
              border: Border.all(width: 1.0, color: const Color(0xff707070)),
            ),
          ),
          animation: animation,
        ),
      ],
    );
  }
}
