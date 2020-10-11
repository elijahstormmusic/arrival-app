/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';
import '../data/socket.dart';
import '../data/link.dart';
import '../users/data.dart';
import '../foryou/list.dart';
import '../login/login.dart';
import '../maps/maps.dart';
import '../screens/settings.dart';
import '../posts/upload.dart';
import '../styles.dart';


class HomeScreen extends StatefulWidget {
  static _MainAppStates currentState;

  static void gotoForyou() =>
    currentState.gotoForyou();

  @override
  _MainAppStates createState() => _MainAppStates();
}

class _MainAppStates extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _pulltoforyou = false,
        _forcelogin = false;

  @override
  void initState() {
    socket.home = this;
    HomeScreen.currentState = this;
    super.initState();
  }

  void gotoForyou() =>
    setState(() => _pulltoforyou = true);
  void forceLogin() =>
    setState(() => _forcelogin = true);
  void refresh() =>
    setState(() => true);

  void _selectedTab(BuildContext context, int index) {
    if (_selectedIndex == index) {
      if (index == 0) {
        Arrival.navigator.currentState.popUntil((route) => route.isFirst);
        ForYouPage.scrollToTop();
      }
    }
    setState(() => _selectedIndex = index);
  }

  Widget _loadingScreen(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Styles.ArrivalPalletteRed,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_forcelogin) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Arrival.navigator.currentState.push(MaterialPageRoute(
          builder: (context) => LoginPage(),
          fullscreenDialog: true,
        ));
      });
      _forcelogin = false;
    }
    else if (_pulltoforyou) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Arrival.navigator.currentState.popUntil((route) => route.isFirst);
      });
      _pulltoforyou = false;
    }

    return WillPopScope(
      onWillPop: () {
        if (Arrival.navigator.currentState.canPop()) {
          Arrival.navigator.currentState.pop();
          return Future.value(false);
        }
        else {
          socket.close();
          return Future.value(true);
        }
      },
      child: (UserData.client.cryptlink=='')
        ? _loadingScreen(context)
        : Scaffold(
            body: Navigator(
              key: Arrival.navigator,
              onPopPage: (route, result) {
                print('poped');
                return true;
              },
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => _selectedIndex==0 ? ForYouPage() : Maps(),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) => _selectedTab(context, index),
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
        ),
    );
  }
}
