/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../data/socket.dart';
import '../foryou/list.dart';
import '../maps/maps.dart';
import '../screens/settings.dart';
import '../posts/upload.dart';
import '../styles.dart';


class HomeScreen extends StatefulWidget {
  @override
  _MainAppStates createState() => _MainAppStates();
}

class _MainAppStates extends State<HomeScreen> {
  int _selectedIndex = 0;
  BuildContext recentlySavedContext;

  @override
  void initState() {
    socket.home = this;
    super.initState();
  }

  void openSnackBar(var details) {
    // details['text'] -> normal text
    // ['action'] -> action text
    // ['function'] -> onclick function
    // ['timeout'] -> duration
  }

  void gotoForyou() {
    if(recentlySavedContext!=null)
      Navigator.of(recentlySavedContext).popUntil((route) => route.isFirst);
    setState(() => _selectedIndex = 0);
  }

  void _selectedTab(int index) {
    if (_selectedIndex == index) {
      if (index == 0) {
        ForYouPage.scrollToTop();
      }
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    recentlySavedContext = context;

    return Scaffold(
      body: _selectedIndex==0 ? ForYouPage() : Maps(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedTab,
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
          size: 24.0,
        ),
        unselectedIconTheme: IconThemeData(
          color: Styles.ArrivalPalletteWhite,
          size: 24.0,
        ),
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        selectedItemColor: Styles.ArrivalPalletteYellow,
        unselectedItemColor: Styles.ArrivalPalletteWhite,
      ),
    );
  }
}
