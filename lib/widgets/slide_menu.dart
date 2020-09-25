/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../screens/settings.dart';
import '../foryou/list.dart';
import '../styles.dart';
import '../users/page.dart';
import '../users/data.dart';
import '../login/login.dart';
import '../arrival_team/contact.dart';

class SlideMenu extends StatefulWidget {

  static const List<String> coverImages = <String>[
    'assets/images/slide_menu/day/city.jpg',
    'assets/images/slide_menu/day/arts.jpg',
    'assets/images/slide_menu/night/city.jpg',
    'assets/images/slide_menu/night/arts.jpg',
    'assets/images/slide_menu/evening/city.jpg',
    'assets/images/slide_menu/evening/arts.jpg',
  ];
  static const List<Color> coverTextColors = <Color>[
    Styles.ArrivalPalletteBlack,
    Styles.ArrivalPalletteWhite,
    Styles.ArrivalPalletteWhite,
    Styles.ArrivalPalletteWhite,
    Styles.ArrivalPalletteWhite,
    Styles.ArrivalPalletteWhite,
  ];

  @override
  _SlideState createState() => _SlideState();
}

class _SlideState extends State<SlideMenu> {
  int _imgIndex = 0;

  void _logout() async {
    await UserData.refresh();
    Navigator.of(context).push<void>(CupertinoPageRoute(
      builder: (context) => LoginPage(),
      fullscreenDialog: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Styles.ArrivalPalletteCream,
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Kansas City',
                style: TextStyle(
                  color: SlideMenu.coverTextColors[_imgIndex],
                  fontSize: 25
                ),
              ),
              decoration: BoxDecoration(
                  color: Styles.ArrivalPalletteRed,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        'assets/images/slide_menu/'
                        + (now.hour < 7 || now.hour > 21 ? 'night'
                        : (now.hour > 7 && now.hour < 15 ? 'day' : 'evening'))
                        + (Random().nextInt(2)==0 ? 'arts' : 'city')
                        + '.jpg'
                      ))),
            ),
            ListTile(
              leading: Icon(Icons.input),
              title: Text('Welcome'),
              onTap: () {
                ForYouPage.scrollToTop();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text(
                'Profile',
                style: TextStyle(color: Styles.ArrivalPalletteBlack),
              ),
              onTap: () => {
                Navigator.of(context).push<void>(CupertinoPageRoute(
                  builder: (context) => ProfilePage(),
                  fullscreenDialog: true,
                ))
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                style: TextStyle(color: Styles.ArrivalPalletteBlack),
              ),
              onTap: () => {
                Navigator.of(context).push<void>(CupertinoPageRoute(
                  builder: (context) => SettingsScreen(),
                  fullscreenDialog: true,
                ))
              },
            ),
            ListTile(
              leading: Icon(Icons.border_color),
              title: Text(
                'Feedback',
                style: TextStyle(color: Styles.ArrivalPalletteBlack),
              ),
              onTap: () => {
                Navigator.of(context).push<void>(CupertinoPageRoute(
                  builder: (context) => ContactUs(),
                  fullscreenDialog: true,
                ))
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(
                'Logout',
                style: TextStyle(color: Styles.ArrivalPalletteBlack),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
