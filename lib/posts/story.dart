/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/socket.dart';
import '../users/data.dart';
import '../styles.dart';


class StoryDisplay extends StatefulWidget {
  String link;

  StoryDisplay(this.link);

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<StoryDisplay> {

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
