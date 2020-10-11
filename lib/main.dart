/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/scheduler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'data/link.dart';
import 'data/arrival.dart';
import 'data/app_state.dart';
import 'data/preferences.dart';
import 'data/socket.dart';
import 'screens/home.v2.dart';
import 'users/data.dart';
import 'users/profile.dart';
import 'login/login.dart';
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

print(UserData.client.cryptlink);

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
            home: HomeScreen(),
            navigatorObservers: [TransitionRouteObserver()],
            routes: {
              LoginScreen.routeName: (context) => LoginScreen(),
              HomeScreen.routeName: (context) => HomeScreen(),
              Maps.routeName: (context) => Maps(),
            },
          ),
        ),
      ),
    ),
  );
}
