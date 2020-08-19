import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

class nextLevelProgressBar extends StatelessWidget {
  nextLevelProgressBar({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 215.0, 9.0),
          size: Size(215.0, 9.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child:
              // Adobe XD layer: 'nextLevelRequiredPo…' (shape)
              Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              border: Border.all(width: 1.0, color: const Color(0xff707070)),
            ),
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 146.0, 9.0),
          size: Size(215.0, 9.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child:
              // Adobe XD layer: 'nextLevelPointsProg…' (shape)
              Container(
            decoration: BoxDecoration(
              color: const Color(0xffd33731),
              border: Border.all(width: 1.0, color: const Color(0xff707070)),
            ),
          ),
        ),
      ],
    );
  }
}
