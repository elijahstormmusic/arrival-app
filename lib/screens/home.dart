// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:arrival_kc/screens/list.dart';
//import 'package:arrival_kc/screens/favorites.dart';
import 'package:arrival_kc/maps/maps.dart';
import 'package:arrival_kc/screens/search.dart';
import 'package:arrival_kc/screens/settings.dart';
import 'package:arrival_kc/styles.dart';
import 'package:arrival_kc/data/link.dart';

class HomeScreen extends StatelessWidget {

  void initState() {
    Data.partners('');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home, size: 42.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.location, size: 42.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search, size: 42.0),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings, size: 42.0),
          ),
        ],
        backgroundColor: Styles.mainColor,
        activeColor: Styles.activeColor,
        inactiveColor: Styles.inactiveColor,
      ),
      tabBuilder: (context, index) {
        if (index == 0) {
          return ListScreen();
        } else if (index == 1) {
          return Maps();
        } else if (index == 2) {
          return SearchScreen();
        } else {
          return SettingsScreen();
        }
      },
    );
  }
}
