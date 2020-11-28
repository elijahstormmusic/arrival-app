/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../users/data.dart';
import '../styles.dart';


class OurMission extends StatelessWidget {

  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: Material(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 36,
            ),
            child: ListView(
              children: [
                Text(
                  'put in our mission statement...',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
