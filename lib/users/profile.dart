// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart';
import '../users/settings.dart';

class Profile {
  final String name;
  final String icon;
  final String email;
  final String cryptlink;
  final int level;
  final int points;
  final SettingsConfig settings;

  String toString() {
    String str = '';
    str += 'name:' + name + ',';
    str += 'icon:' + icon + ',';
    str += 'email:' + email + ',';
    str += 'cryptlink:' + cryptlink + ',';
    str += 'level:' + level.toString() + ',';
    str += 'points:' + points.toString() + ',';
    str += 'settings:{' + settings.toString() + '}';
    return str;
  }

  Profile({
    @required this.name,
    @required this.icon,
    @required this.email,
    @required this.cryptlink,
    @required this.level,
    @required this.points,
    @required this.settings,
  });

  static Profile parse(String input)
  {
    if(input.substring(0, 1)=='{')
      input = input.substring(1, input.length-1);

    var name, icon, email, level,
        points, settings, cryptlink;

    var startDataLoc, endDataLoc = 0;

    startDataLoc = input.indexOf('name')            + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    name = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('icon')            + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    icon = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('email')           + 6;
    endDataLoc = input.indexOf(',', startDataLoc);
    email = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('cryptlink')       + 10;
    endDataLoc = input.indexOf(',', startDataLoc);
    cryptlink = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('level')           + 6;
    endDataLoc = input.indexOf(',', startDataLoc);
    level = int.parse(input.substring(startDataLoc, endDataLoc));

    startDataLoc = input.indexOf('points')          + 7;
    endDataLoc = input.indexOf(',', startDataLoc);
    points = int.parse(input.substring(startDataLoc, endDataLoc));

    startDataLoc = input.indexOf('settings')        + 10;
    endDataLoc = input.indexOf('}', startDataLoc);
    settings = SettingsConfig.parse(input.substring(startDataLoc, endDataLoc)+',');

    return Profile(
      name: name,
      icon: icon,
      email: email,
      cryptlink: cryptlink,
      level: level,
      points: points,
      settings: settings,
    );
  }
}
