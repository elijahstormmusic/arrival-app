import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

class exampleNewsArticle extends StatelessWidget {
  exampleNewsArticle({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 332.0, 79.0),
          size: Size(332.0, 79.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child:
              // Adobe XD layer: 'exampleNewsArticleB…' (shape)
              Container(
            decoration: BoxDecoration(
              color: const Color(0xffe8e8e8),
              border: Border.all(width: 15.0, color: const Color(0xffe8e8e8)),
            ),
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(15.0, 43.0, 312.0, 30.0),
          size: Size(332.0, 79.0),
          pinLeft: true,
          pinRight: true,
          pinBottom: true,
          fixedHeight: true,
          child:
              // Adobe XD layer: 'exampleNewsArticleS…' (text)
              Text(
            '- In this article, you’ll learn all about how…',
            style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: 16,
              color: const Color(0xff5f5f5f),
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(9.0, 7.0, 220.0, 40.0),
          size: Size(332.0, 79.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          fixedHeight: true,
          child:
              // Adobe XD layer: 'exampleNewsArticleT…' (text)
              Text(
            'Example Post',
            style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: 22,
              color: const Color(0xff5f5f5f),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
