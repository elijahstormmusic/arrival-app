/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/socket.dart';
import '../users/data.dart';
import '../styles.dart';

class ArticleCategoryDisplay extends StatefulWidget {
  final String index;

  ArticleCategoryDisplay(@required this.index);

  @override
  _ACDState createState() => _ACDState();
}

class _ACDState extends State<ArticleCategoryDisplay> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: Material(
          child: Text('coming soon...'),
        ),
      ),
    );
  }
}
