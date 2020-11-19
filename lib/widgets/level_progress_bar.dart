/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import '../styles.dart';
import '../users/profile.dart';


class _GrowTransition extends StatelessWidget {
  _GrowTransition({this.child, this.animation, this.size, this.onCycle});

  final Widget child;
  final Animation<double> animation;
  final double size;
  final void Function() onCycle;
  double lastValue = -1;

  Widget build(BuildContext context) => AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
                var currentValue = animation.value % size;
                if (currentValue < lastValue)
                  onCycle();
                lastValue = currentValue;

                return Container(
                  height: 9.0,
                  width: currentValue,
                  child: child,
                  alignment: Alignment.centerLeft,
                );
              },
            child: child,
      );
}

class LevelProgress extends StatefulWidget {
  final void Function() onCycle;
  final double maxSize;
  int level;
  int points;
  int iterations;
  double progress;

  LevelProgress(this.level, this.points, {this.maxSize = 245.0, this.onCycle}) {
    var currentPointsThisLevel = points - Profile.findPointsToNextLevel(level-1);
    progress = currentPointsThisLevel / (Profile.findPointsToNextLevel(level)
                                      - Profile.findPointsToNextLevel(level-1));
    if (progress>1)
      iterations = progress.toInt() + 1;
    else iterations = 1;
  }

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
        AnimationController(duration: Duration(seconds: 2 * widget.iterations), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = Tween<double>(begin: 0, end: widget.maxSize * widget.progress).animate(curve);
    controller.forward();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
          child: Text(
            widget.level.toString(),
            style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: 16,
              color: Styles.ArrivalPalletteBlack,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Styles.ArrivalPalletteWhite,
                  border: Border.all(width: 1.0, color: const Color(0xff707070)),
                ),
                width: widget.maxSize,
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
                size: widget.maxSize,
                onCycle: () {
                  widget.onCycle();
                  setState(() => widget.level++);
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
          child: Text(
            (widget.level+1).toString(),
            style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: 16,
              color: Styles.ArrivalPalletteBlack,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
