/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:scoped_model/scoped_model.dart';
import 'data/app_state.dart';
import 'data/preferences.dart';

import 'screens/home.v2.dart';
import 'users/data.dart';
import 'data/link.dart';
import 'data/arrival.dart';
import 'login/login.dart';
import 'data/socket.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Widget launchState = HomeScreen();
  await UserData.load();
  await ArrivalData.load();
  await socket.init();
  ArrivalData.carry = true;
  if (UserData.username==null || UserData.username=='null') {
    launchState = LoginPage();
  } else {
    socket.emit('userdata get link', {
      'link': UserData.client.cryptlink,
      'password': UserData.password,
    });
  }

  runApp(
    ScopedModel<AppState>(
      model: AppState(),
      child: ScopedModel<Preferences>(
        model: Preferences()..load(),
        child: CupertinoApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          home: launchState,
        ),
      ),
    ),
  );
}
