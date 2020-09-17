// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../users/settings.dart';
import '../data/arrival.dart';
import '../data/socket.dart';

class Profile {
  static final String default_img =
    'https://arrival-app.herokuapp.com/includes/img/default-profile-pic.png';
  static final String source =
    'https://arrival-app.herokuapp.com/user/data/';

  final String name;
  final String pic;
  final String shortBio;
  final String email;
  final String cryptlink;
  final int level;
  final int points;
  final SettingsConfig settings;

  String toString() {
    String str = '';
    str += 'name:' + name + ',';
    str += 'pic:' + pic + ',';
    str += 'bio:' + shortBio + ',';
    str += 'email:' + email + ',';
    str += 'cryptlink:' + cryptlink + ',';
    str += 'level:' + level.toString() + ',';
    str += 'points:' + points.toString() + ',';
    str += 'settings:{' + settings.toString() + '}';
    return str;
  }

  Profile({
    @required this.name,
    @required this.pic,
    @required this.email,
    @required this.shortBio,
    @required this.cryptlink,
    @required this.level,
    @required this.points,
    @required this.settings,
  });
  static final Profile empty = Profile(
    name: '',
    pic: '',
    email: '',
    shortBio: '',
    cryptlink: '',
    level: 0,
    points: 0,
    settings: SettingsConfig.empty,
  );

  Widget iconBySize(double height) {
    if (pic=='') {
      return Image.network(
        Profile.default_img,
        fit: BoxFit.cover,
        semanticLabel: 'Profile image for ' + name,
        height: height,
      );
    }

    return Image.network(
      Profile.source + pic,
      fit: BoxFit.cover,
      semanticLabel: 'Profile image for ' + name,
    );
  }
  Widget icon() {
    if (pic=='') {
      return Image.network(
        Profile.default_img,
        fit: BoxFit.cover,
        semanticLabel: 'Profile image for ' + name,
      );
    }

    return Image.network(
      Profile.source + pic,
      fit: BoxFit.cover,
      semanticLabel: 'Profile image for ' + name,
    );
  }

  static Profile parse(String input) {
    if (input.substring(0, 1)=='{')
      input = input.substring(1, input.length-1);

    var name, email, level, shortBio, pic,
        points, settings, cryptlink;

    var startDataLoc, endDataLoc = 0;

    startDataLoc = input.indexOf('name')            + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    name = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('pic')             + 4;
    endDataLoc = input.indexOf(',', startDataLoc);
    pic = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('bio')             + 4;
    endDataLoc = input.indexOf(',', startDataLoc);
    shortBio = input.substring(startDataLoc, endDataLoc);

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
      pic: pic,
      email: email,
      shortBio: shortBio,
      cryptlink: cryptlink,
      level: level,
      points: points,
      settings: settings,
    );
  }
  static Profile json(var input) {
    return Profile(
      name: input['username'],
      pic: input['pic'],
      cryptlink: input['cryptlink'],
      email: input['email'],
      shortBio: input['shortBio'],
      level: input['level'],
      points: input['points'],
    );
  }
  static Profile litejson(var input) {
    return Profile(
      name: input['username'],
      pic: input['pic'],
      cryptlink: input['cryptlink'],
      email: '',
      shortBio: '',
      level: 0,
      points: 0,
    );
  }
  static Profile lite(String input) {
    for (var i=0;i<ArrivalData.profiles.length;i++) {
      if (ArrivalData.profiles[i].cryptlink==input) {
        return ArrivalData.profiles[i];
      }
    }
    var P = Profile(
      name: '',
      pic: '',
      email: '',
      shortBio: '',
      cryptlink: input,
      level: 0,
      points: 0,
      settings: SettingsConfig.empty,
    );
    socket.emit('profile lite', {
      'link': input,
    });
    ArrivalData.profiles.add(P);
    return P;
  }
  static Profile link(String input) {
    for (var i=0;i<ArrivalData.profiles.length;i++) {
      if (ArrivalData.profiles[i].cryptlink==input) {
        return ArrivalData.profiles[i];
      }
    }
    var P = Profile(
      name: '',
      pic: '',
      email: '',
      shortBio: '',
      cryptlink: input,
      level: 0,
      points: 0,
      settings: SettingsConfig.empty,
    );
    socket.emit('profile get', {
      'link': input,
    });
    ArrivalData.profiles.add(P);
    return P;
  }
}
