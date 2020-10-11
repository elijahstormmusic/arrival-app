/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/scheduler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'data/app_state.dart';
import 'data/preferences.dart';
import 'data/socket.dart';
import 'screens/home.v2.dart';
import 'users/data.dart';
import 'users/profile.dart';
import 'data/arrival.dart';

import 'login/login.dart';
import 'login/dashboard_screen.dart';
import 'login/transition_route_observer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await UserData.load();
  await ArrivalData.load();
  await ArrivalData.refresh();
  await socket.init();
  if (UserData.client.cryptlink=='') {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      socket.home.forceLogin();
    });
  } else {
    socket.emit('client set state', {
      'link': UserData.client.cryptlink,
      'password': UserData.password,
    });
  }

  runApp(
    ScopedModel<AppState>(
      model: AppState(),
      child: ScopedModel<Preferences>(
        model: Preferences()..load(),
        child: RefreshConfiguration(
          enableLoadingWhenFailed: true,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              // brightness: Brightness.dark,
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.orange,
              cursorColor: Colors.orange,
              // fontFamily: 'SourceSansPro',
              textTheme: TextTheme(
                display2: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 45.0,
                  // fontWeight: FontWeight.w400,
                  color: Colors.orange,
                ),
                button: TextStyle(
                  // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
                  fontFamily: 'OpenSans',
                ),
                caption: TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.deepPurple[300],
                ),
                display4: TextStyle(fontFamily: 'Quicksand'),
                display3: TextStyle(fontFamily: 'Quicksand'),
                display1: TextStyle(fontFamily: 'Quicksand'),
                headline: TextStyle(fontFamily: 'NotoSans'),
                title: TextStyle(fontFamily: 'NotoSans'),
                subhead: TextStyle(fontFamily: 'NotoSans'),
                body2: TextStyle(fontFamily: 'NotoSans'),
                body1: TextStyle(fontFamily: 'NotoSans'),
                subtitle: TextStyle(fontFamily: 'NotoSans'),
                overline: TextStyle(fontFamily: 'NotoSans'),
              ),
            ),
            home: HomeScreen(),
            navigatorObservers: [TransitionRouteObserver()],
            routes: {
              LoginScreen.routeName: (context) => LoginScreen(),
              DashboardScreen.routeName: (context) => DashboardScreen(),
            },
          ),
        ),
      ),
    ),
  );
}
