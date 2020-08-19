import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './searchBar.dart';

class SearchPage extends StatelessWidget {
  SearchPage({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd33731),
      body: Stack(
        children: <Widget>[
          Pinned.fromSize(
            bounds: Rect.fromLTWH(22.5, 23.5, 367.0, 41.0),
            size: Size(412.0, 1600.0),
            pinLeft: true,
            pinRight: true,
            pinTop: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'searchBar' (component)
                searchBar(),
          ),
        ],
      ),
    );
  }
}
