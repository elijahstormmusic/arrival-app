/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

import '../data/socket.dart';
import '../data/link.dart';
import '../arrival_team/agreements.dart';
import '../users/data.dart';
import '../foryou/foryou.dart';
import '../foryou/feeds/article_feed.dart';
import '../foryou/feeds/partner_feed.dart';
import '../foryou/feeds/post_feed.dart';
import '../login/login.dart';
import '../maps/maps.dart';
import '../screens/settings.dart';
import '../widgets/blobs.dart';
import '../posts/upload.dart';
import '../styles.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  static _MainAppStates _s;
  static bool first_load = true;

  static void gotoForyou() => _s.gotoForyou();
  static void forceLogin() => _s.forceLogin();
  static void forceQuit() => _s.forceQuit();
  static void toggleVerion() => _s.toggleVerion();
  static void reflow() => _s.reflow();

  static void openSnackBar(Map<String, dynamic> input) => _s.openSnackBar(input);

  @override
  _MainAppStates createState() {
    _s = _MainAppStates();
    return _s;
  }
}

class _MainAppStates extends State<HomeScreen> {
  int _selectedIndex = 2;
  bool _pulltoforyou = false,
        _runningLoginScreen = false,
        _forcelogin = false, _forcequit = false;

  @override
  void initState() {
    super.initState();
    socket.home = this;
  }

  void gotoForyou() => setState(() => _pulltoforyou = true);
  void forceLogin() => setState(() => _forcelogin = true);
  void forceQuit() => setState(() => _forcequit = true);
  void refresh() => setState(() => true);

  bool versionTwo = true;
  void toggleVerion() => setState(() => versionTwo = !versionTwo);

  void scrollToTop() {
    if (_selectedIndex==0) {
      ArticleFeed.scrollToTop();
    }
    else if (_selectedIndex==1) {
      PostFeed.scrollToTop();
    }
    else if (_selectedIndex==2) {
      ForYouPage.scrollToTop();
    }
    else if (_selectedIndex==3) {
      PartnerFeed.scrollToTop();
    }
    else if (_selectedIndex==4) {
      Maps.scrollToTop();
    }
    else {
      ForYouPage.scrollToTop();
    }
  }
  void openSnackBar(Map<String, dynamic> input) {
    if (_selectedIndex==0) {
      ArticleFeed.openSnackBar(input);
    }
    else if (_selectedIndex==1) {
      PostFeed.openSnackBar(input);
    }
    else if (_selectedIndex==2) {
      ForYouPage.openSnackBar(input);
    }
    else if (_selectedIndex==3) {
      PartnerFeed.openSnackBar(input);
    }
    else if (_selectedIndex==4) {
      Maps.openSnackBar(input);
    }
    else {
      ForYouPage.openSnackBar(input);
    }
  }
  void _selectedTab(int index) {
    if (_selectedIndex == index) {
      Arrival.navigator.currentState.popUntil((route) => route.isFirst);
      if (_selectedIndex==0) {
        ArticleFeed.scrollToTop();
      }
      else if (_selectedIndex==1) {
        PostFeed.scrollToTop();
      }
      else if (_selectedIndex==2) {
        ForYouPage.scrollToTop();
      }
      else if (_selectedIndex==3) {
        PartnerFeed.scrollToTop();
      }
      else if (_selectedIndex==4) {
        Maps.scrollToTop();
      }
      else {
        ForYouPage.scrollToTop();
      }
    }
    setState(() => _selectedIndex = index);
  }
  void reflow() => setState(() => 0);

  Widget _loadingScreen(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Styles.ArrivalPalletteRed,
        ),
        child: Center(
          child: Image.asset('assets/loading/Bucket-1s-200px.gif'),
        ),
      ),
    );
  }
  Widget _decideInteriorBody() {
    var choice;

    switch (_selectedIndex) {
      case 0:
        choice = ArticleFeed();
        break;
      case 1:
        choice = PostFeed();
        break;
      case 2:
        choice = ForYouPage();
        break;
      case 3:
        choice = PartnerFeed();
        break;
      case 4:
        choice = Maps();
        break;
      default:
        choice = ForYouPage();
        break;
    }

    return Stack(
      children: [
        Blob_Loader_Animation(),
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: HomeScreen.first_load ? 0.0 : 1.0,
          child: choice,
        ),
      ],
    );
  }

  Widget _buildBottomNavBarVTwo(BuildContext context) {
    return BottomNavigationBar(
      onTap: _selectedTab,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.subject),
          title: Text('mag'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervisor_account),
          title: Text('social'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('for you'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          title: Text('market'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('maps'),
        ),
      ],
      currentIndex: _selectedIndex,
      backgroundColor: Styles.ArrivalPalletteWhite,
      selectedIconTheme: IconThemeData(
        color: Styles.ArrivalPalletteRed,
        size: 24.0,
      ),
      unselectedIconTheme: IconThemeData(
        color: Styles.ArrivalPalletteBlack,
        size: 24.0,
      ),
      selectedFontSize: 16.0,
      unselectedFontSize: 16.0,
      selectedItemColor: Styles.ArrivalPalletteRed,
      unselectedItemColor: Styles.ArrivalPalletteBlack,
    );
  }
  BottomNavigationBar _buildBottomNavBarVOne(BuildContext context) {
    return BottomNavigationBar(
      onTap: _selectedTab,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('for you'),
          backgroundColor: Styles.ArrivalPalletteRed,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.subject),
          title: Text('what\'s happenin'),
          backgroundColor: Styles.ArrivalPalletteRed,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          title: Text('partners'),
          backgroundColor: Styles.ArrivalPalletteRed,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('maps'),
          backgroundColor: Styles.ArrivalPalletteRed,
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
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_pulltoforyou) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _selectedTab(2);
      });
      _pulltoforyou = false;
    }
    else if (_forcelogin) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Arrival.navigator.currentState.popUntil((route) => route.isFirst);
        Arrival.navigator.currentState.push(MaterialPageRoute(
          builder: (context) => LoginScreen(),
          fullscreenDialog: true,
        ));
      });
      _forcelogin = false;
    }
    else if (_forcequit) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Arrival.navigator.currentState.popUntil((route) => route.isFirst);
        Arrival.navigator.currentState.pop();
      });
      _forcequit = false;
    }
    else if (!UserData.UGC_Agreement) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Arrival.navigator.currentState.popUntil((route) => route.isFirst);
        Arrival.navigator.currentState.push(MaterialPageRoute(
          builder: (context) => LegalAgreements.UGC(),
          fullscreenDialog: true,
        ));
      });
    }

    var scaffoldBody, bottomNav;
    var _foryouFloatingVTwo = Container(
      width: 60,
      height: 60,
      child: FittedBox(
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Styles.ArrivalPalletteWhite,
          foregroundColor: Styles.ArrivalPalletteWhite,
          child: CircleAvatar(
            radius: 22,
            child: Icon(
              Icons.home,
              color: Styles.ArrivalPalletteWhite,
            ),
            backgroundColor: Styles.ArrivalPalletteRed,
          ),
          onPressed: () => _selectedTab(2),
        )
      ),
    ), _foryouFloatingSettingsVTwo = FloatingActionButtonLocation.centerDocked;
    if (UserData.password!='') {
      scaffoldBody = _decideInteriorBody();
      if (versionTwo) {
        bottomNav = _buildBottomNavBarVTwo(context);
      }
      else {
        bottomNav = _buildBottomNavBarVOne(context);
        _foryouFloatingSettingsVTwo = null;
        _foryouFloatingVTwo = null;
      }
    }
    else {
      scaffoldBody = _loadingScreen(context);
    }

    return Scaffold(
        body: scaffoldBody,
        floatingActionButton: _foryouFloatingVTwo,
        floatingActionButtonLocation: _foryouFloatingSettingsVTwo,
        bottomNavigationBar: bottomNav,
        resizeToAvoidBottomInset : false,
      );
  }
}
