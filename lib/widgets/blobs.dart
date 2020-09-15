/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import '../styles.dart';


class _SlideTransition extends StatelessWidget {
  _SlideTransition({
    this.child, this.animation,
    this.positions,
  });

  final Widget child;
  final Animation<double> animation;
  final Positions positions;

  Widget build(BuildContext context) => AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Stack(
              children: <Widget>[
                Positioned(
                  left: positions.startLeft + animation.value * positions.offsetLeft,
                  top: positions.startTop + animation.value * positions.offsetTop,
                  child: Container(
                    height: animation.value * positions.size,
                    width: animation.value * positions.size,
                    child: child,
                  ),
                ),
              ],
            ),
            child: child,
      );
}

class Blob_Background extends StatefulWidget {
  final double height;

  Blob_Background({@required this.height});

  _Blobs createState() => _Blobs();
}

class Positions {
  double startLeft, startTop, endLeft, endTop, size;
  double offsetLeft, offsetTop;
  Random rand;
  int randStart = 50, randEnd = 10;

  Positions({
    @required this.startLeft,
    @required this.startTop,
    @required this.endLeft,
    @required this.endTop,
    @required this.size,
  }) {
    rand = Random();
    startLeft += rand.nextInt(randStart) - (randStart/2);
    startTop += rand.nextInt(randStart) - (randStart/2);
    endLeft += rand.nextInt(randEnd) - (randEnd/2);
    endTop += rand.nextInt(randEnd) - (randEnd/2);
    offsetLeft = endLeft - startLeft;
    offsetTop = endTop - startTop;
  }
}

class _Blobs extends State<Blob_Background> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  Animation curve;
  AnimationController controller;

  Positions redPosition = Positions(
    startLeft: -160.0,
    startTop: -100.0,
    endLeft: -50.0,
    endTop: 115.0,
    size: 200.0,
  );
  Positions yellowPosition = Positions(
    startLeft: -30.0,
    startTop: -110.0,
    endLeft: 10.0,
    endTop: -20.0,
    size: 200.0,
  );
  Positions bluePosition = Positions(
    startLeft: 410.0,
    startTop: -60.0,
    endLeft: 280.0,
    endTop: -20.0,
    size: 200.0,
  );

  @override
  void initState() {
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = Tween<double>(begin: 0, end: 1.0).animate(curve);
    controller.forward();
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) => Stack(
          children: <Widget>[
            SizedBox(
              height: widget.height,
              child: _SlideTransition(
                positions: redPosition,
                child: Container(
                  child: Styles.ArrivalBlobRed,
                ),
                animation: animation,
              ),
            ),
            SizedBox(
              height: widget.height,
              child: _SlideTransition(
                positions: yellowPosition,
                child: Container(
                  child: Styles.ArrivalBlobYellow,
                ),
                animation: animation,
              ),
            ),
            SizedBox(
              height: widget.height,
              child: _SlideTransition(
                positions: bluePosition,
                child: Container(
                  child: Styles.ArrivalBlobBlue,
                ),
                animation: animation,
              ),
            ),
          ],
      );
}
