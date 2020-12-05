/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:math';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import '../screens/home.dart';
import '../styles.dart';

// tap order for secret message
// blue blue blue, red, red, blue, yellow, yellow, blue blue, foryou home button


class Blob_Background extends StatefulWidget {
  Blob_Background();

  _Blobs createState() => _Blobs();
}
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
    startLeft += rand.nextInt(randStart) - (randStart/2.0);
    startTop += rand.nextInt(randStart) - (randStart/2.0);
    endLeft += rand.nextInt(randEnd) - (randEnd/2.0);
    endTop += rand.nextInt(randEnd) - (randEnd/2.0);
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
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
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
              height: MediaQuery.of(buildContext).size.height,
              child: _SlideTransition(
                positions: redPosition,
                child: Container(
                  child: Styles.ArrivalBlobRed,
                ),
                animation: animation,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(buildContext).size.height,
              child: _SlideTransition(
                positions: yellowPosition,
                child: Container(
                  child: GestureDetector(
                    onTap: () => HomeScreen.openSnackBar({
                      'text': 'test',
                    }),
                    child: Styles.ArrivalBlobYellow,
                  ),
                ),
                animation: animation,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(buildContext).size.height,
              child: _SlideTransition(
                positions: bluePosition,
                child: Container(
                  child: GestureDetector(
                    onTap: () => HomeScreen.toggleVerion(),
                    child: Styles.ArrivalBlobBlue,
                  ),
                ),
                animation: animation,
              ),
            ),
          ],
      );
}


class Blob_Loader_Animation extends StatefulWidget {
  static _LoaderAnimationAct _s;

  @override
  State<StatefulWidget> createState() {
    _s = _LoaderAnimationAct();
    return _s;
  }
}
class _LoaderAnimationAct extends State<Blob_Loader_Animation> {

  int _splashIndexRed;
  int _splashIndexBlue;
  int _splashIndexYellow;

  @override
  void initState() {
    super.initState();

    _splashIndexRed = Random().nextInt(5);
    _splashIndexBlue = Random().nextInt(5);
    _splashIndexYellow = Random().nextInt(5);

    WidgetsBinding.instance.addPostFrameCallback((_) => _timeout());
  }

  void _timeout() async {
    await Future.delayed(Duration(milliseconds: 2300));

    _isDone();
  }

  void _isDone() {
    HomeScreen.first_load = false;
    HomeScreen.reflow();
  }

  @override
  Widget build(BuildContext context) => Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    color: Styles.ArrivalPalletteWhite,
    child: Stack(
      children: [
        PaintDropGroup(
          delay: 50,
          dropImage: Styles.ArrivalPaintDropRed,
          centerImage: Styles.ArrivalPaintSplashRed(_splashIndexRed),
          splashImage: Styles.ArrivalPaintSplashRed,
          sprayImage: Styles.ArrivalPaintSprayRed,
          xStart: 40.0,
          yEnd: MediaQuery.of(context).size.height - 280.0,
          dropPaintSpeed: 500,
          drop_size: 100,
          size_difference: 100,
        ),

        PaintDropGroup(
          delay: 400,
          dropImage: Styles.ArrivalPaintDropBlue,
          centerImage: Styles.ArrivalPaintSplashBlue(_splashIndexBlue),
          splashImage: Styles.ArrivalPaintSplashBlue,
          sprayImage: Styles.ArrivalPaintSprayBlue,
          xStart: MediaQuery.of(context).size.width - 150.0,
          yEnd: (MediaQuery.of(context).size.width / 1.6),
          dropPaintSpeed: 400,
          drop_size: 100,
          size_difference: 100,
        ),

        PaintDropGroup(
          delay: 650,
          dropImage: Styles.ArrivalPaintDropYellow,
          centerImage: Styles.ArrivalPaintSplashYellow(_splashIndexYellow),
          splashImage: Styles.ArrivalPaintSplashYellow,
          sprayImage: Styles.ArrivalPaintSprayYellow,
          xStart: 110.0,
          yEnd: 100.0,
          dropPaintSpeed: 300,
          drop_size: 100,
          size_difference: 100,
        ),

        PaintDropGroup(
          delay: 1000,
          dropImage: Styles.ArrivalPaintDropRed,
          centerImage: Styles.ArrivalPaintSplashLogo,
          splashImage: Styles.ArrivalPaintSplashRed,
          sprayImage: Styles.ArrivalPaintSprayRed,
          xStart: ((MediaQuery.of(context).size.width / 2.0) - 70.0) + 15,
          yEnd: ((MediaQuery.of(context).size.height / 2.0) - 70.0) + 20,
          dropPaintSpeed: 400,
          drop_size: 100,
          size_difference: 100,
        ),
      ],
    ),
  );
}

class PaintDropGroup extends StatelessWidget {
  PaintDropGroup({
    @required this.delay,
    @required this.dropImage,
    @required this.splashImage,
    @required this.centerImage,
    @required this.sprayImage,
    @required this.xStart,
    @required this.yEnd,
    @required this.dropPaintSpeed,
    @required this.drop_size,
    @required this.size_difference,
  }) {
    _drawables = List<Widget>();

    int amount = Random().nextInt(5) + 8;

    _drawables.add(PaintDrop(
      delay: delay,
      dropImage: dropImage,
      splashImage: centerImage,
      xStart: xStart,
      yEnd: yEnd,
      dropPaintSpeed: dropPaintSpeed,
      drop_size: drop_size,
      size_difference: size_difference,
    ));

    for (int i=0;i<amount;i++) {
      _drawables.add(PaintDrop(
        delay: delay + Random().nextInt(200) + (50 * amount),
        dropImage: dropImage,
        splashImage: splashImage(Random().nextInt(5)),
        xStart: xStart + ((Random().nextDouble() > .5 ? -1 : 1) * ((Random().nextDouble() * size_difference) + size_difference) * 0.5),
        yEnd: yEnd + ((Random().nextDouble() > .5 ? -1 : 1) * ((Random().nextDouble() * size_difference) + size_difference) * 0.5),
        dropPaintSpeed: dropPaintSpeed,
        drop_size: drop_size / 3.0,
        size_difference: size_difference / 3.0,
      ));
    }

    amount = Random().nextInt(3) + 3;

    return; // remove to debug and test spray

    for (int i=0;i<amount;i++) {
      _drawables.add(PaintSpray(
        delay: delay + dropPaintSpeed + Random().nextInt(200) + (50 * amount),
        sprayImage: sprayImage(Random().nextInt(3)),
        xStart: xStart,
        yStart: yEnd,
        direction: Random().nextDouble() * 6.28,
        radius: size_difference * 1.6,
      ));
    }
  }

  final int delay;
  final double drop_size, size_difference;
  final int dropPaintSpeed;
  final double xStart, yEnd;
  final Widget dropImage, centerImage;
  final Function(int) splashImage, sprayImage;

  List<Widget> _drawables;

  @override
  Widget build(BuildContext context) => Stack(
    children: _drawables,
  );
}

class PaintSpray extends StatefulWidget {

  PaintSpray({
    @required this.delay,
    @required this.sprayImage,
    @required this.xStart,
    @required this.yStart,
    @required this.direction,
    @required this.radius,
  });

  final int delay;
  final double xStart, yStart, radius, direction;
  final Widget sprayImage;

  _PaintSpray createState() => _PaintSpray(
    delay,
    sprayImage,
    xStart,
    yStart,
    direction,
    radius,
  );
}
class _PaintSpray extends State<PaintSpray> {

  _PaintSpray(
    @required this.delay,
    @required this.sprayImage,
    @required this.xStart,
    @required this.yStart,
    @required this.direction,
    @required this.radius,
  );

  final int delay;
  final double xStart, yStart, radius, direction;
  final Widget sprayImage;

  double xChange, yChange;
  final double size_difference = 60;
  bool _splashed = false;

  @override
  void initState() {
    super.initState();

    xChange = radius * cos(direction);
    yChange = radius * sin(direction);

    WidgetsBinding.instance.addPostFrameCallback((_) => _timeout());
  }

  void _timeout() async {
    await Future.delayed(Duration(milliseconds: delay));

    _runPaint();
  }

  void _runPaint() async {
    if (!this.mounted) return;
    setState(() => _splashed = true);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: direction,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: EdgeInsets.only(
          left: max(0.0, xStart + (_splashed ? xChange : 0.0)),
          top: max(0.0, yStart + (_splashed ? yChange : 0.0)),
        ),
        width: _splashed ? size_difference : 0.0,
        height: _splashed ? size_difference : 0.0,
        child: _splashed ? sprayImage : Container(),
      ),
    );
  }
}

class PaintDrop extends StatefulWidget {

  PaintDrop({
    @required this.delay,
    @required this.dropImage,
    @required this.splashImage,
    @required this.xStart,
    @required this.yEnd,
    @required this.dropPaintSpeed,
    @required this.drop_size,
    @required this.size_difference,
  });

  final int delay;
  final double drop_size, size_difference;
  final int dropPaintSpeed;
  final double xStart, yEnd;
  final Widget splashImage, dropImage;

  State<PaintDrop> createState() => _PaintDropState(
    delay,
    dropImage,
    splashImage,
    xStart,
    yEnd,
    dropPaintSpeed,
    drop_size,
    size_difference,
  );
}
class _PaintDropState extends State<PaintDrop> {

  _PaintDropState(
    @required this.delay,
    @required this.dropImage,
    @required this.splashImage,
    @required this.xStart,
    @required this.yEnd,
    @required this.dropPaintSpeed,
    @required this.drop_size,
    @required this.size_difference,
  );

  final int delay;
  final double drop_size, size_difference;
  final int dropPaintSpeed;
  final double xStart, yEnd;
  final Widget splashImage, dropImage;

  bool _dropPaint = false;
  bool _splashPaint = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _timeout());
  }

  void _timeout() async {
    await Future.delayed(Duration(milliseconds: delay));

    _runPaint();
  }

  void _runPaint() async {
    if (!this.mounted) return;
    setState(() => _dropPaint = true);
    await Future.delayed(Duration(milliseconds: dropPaintSpeed));
    if (!this.mounted) return;
    setState(() {
      _splashPaint = true;
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: Duration(milliseconds: _splashPaint ? 100 : dropPaintSpeed),
    curve: _splashPaint ? Curves.decelerate : Curves.easeInQuad,
    margin: EdgeInsets.only(
      left: max(0.0, xStart - (_splashPaint ? (size_difference/2.0) : 0.0)),
      top: max(0.0, (_dropPaint ? yEnd : 0.0) - (_splashPaint ? (size_difference/2.0) : 0.0)),
    ),
    height: (_dropPaint ? (_splashPaint ? size_difference : 0.0) + drop_size : 0.0),
    width: ((_splashPaint ? size_difference : 0.0)) + drop_size,
    child: _splashPaint ? splashImage : dropImage,
  );
}
