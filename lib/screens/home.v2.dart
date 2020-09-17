/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../foryou/list.dart';
import '../maps/maps.dart';
import '../screens/search.dart';
import '../screens/settings.dart';
import '../posts/upload.dart';
import '../styles.dart';


class HomeScreen extends StatefulWidget {
  @override
  _MainAppStates createState() => _MainAppStates();
}

class _MainAppStates extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex==0 ? ForYouPage() : Maps(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('for you'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('maps'),
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Styles.ArrivalPalletteRed,
        selectedIconTheme: IconThemeData(
          color: Styles.ArrivalPalletteYellow,
          size: 30.0,
        ),
        unselectedIconTheme: IconThemeData(
          color: Styles.ArrivalPalletteWhite,
          size: 26.0,
        ),
        selectedFontSize: 18.0,
        unselectedFontSize: 16.0,
        selectedItemColor: Styles.ArrivalPalletteYellow,
        unselectedItemColor: Styles.ArrivalPalletteWhite,
        onTap: (int index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
