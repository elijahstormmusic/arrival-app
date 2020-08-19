import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

class searchBar extends StatelessWidget {
  searchBar({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 367.0, 41.0),
          size: Size(367.0, 41.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child:
              // Adobe XD layer: 'searchBarBackground' (shape)
              Container(
            decoration: BoxDecoration(
              color: const Color(0xff5f5f5f),
              border: Border.all(width: 15.0, color: const Color(0xff5f5f5f)),
            ),
          ),
        ),
        Container(),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(47.5, 7.5, 69.0, 26.0),
          size: Size(367.0, 41.0),
          pinLeft: true,
          fixedWidth: true,
          fixedHeight: true,
          child:
              // Adobe XD layer: 'searchBarPlaceholde…' (text)
              Text(
            'Search',
            style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: 22,
              color: const Color(0xffcecece),
              height: 1.0909090909090908,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
