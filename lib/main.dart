// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:scoped_model/scoped_model.dart';
import 'data/app_state.dart';
import 'data/preferences.dart';

import 'screens/home.dart';
import 'users/data.dart';
import 'data/link.dart';
import 'data/arrival.dart';
import 'login/login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Widget launchState = HomeScreen();
  await UserData.load();
  await ArrivalData.load();
  ArrivalData.carry = true;
  if(UserData.username==null || UserData.username=='null') {
    launchState = LoginPage();
  }
  else if(ArrivalData.partners.length<5) {
    launchState = Data.partners('');
  }

  runApp(
    ScopedModel<AppState>(
      model: AppState(),
      child: ScopedModel<Preferences>(
        model: Preferences()..load(),
        child: CupertinoApp(
          debugShowCheckedModeBanner: false,
          home: launchState,
        ),
      ),
    ),
  );
}
