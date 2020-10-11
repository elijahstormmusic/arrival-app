/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../data/arrival.dart';
import '../data/socket.dart';

class Profile {
  static final String default_img =
    'https://arrival-app.herokuapp.com/includes/img/default-profile-pic.png';
  static final String source =
    'https://res.cloudinary.com/arrival-kc/image/upload/';

  final String name;
  final String pic;
  final String shortBio;
  final String email;
  final String cryptlink;
  final int level;
  final int points;

  dynamic toJson() {
    return {
      'name': name,
      'pic': pic,
      'cryptlink': cryptlink,
      'email': email,
      'shortBio': shortBio,
      'level': level,
      'points': points,
    };
  }

  Profile({
    @required this.name,
    @required this.pic,
    @required this.email,
    @required this.shortBio,
    @required this.cryptlink,
    @required this.level,
    @required this.points,
  });
  static final Profile empty = Profile(
    name: '',
    pic: '',
    email: '',
    shortBio: '',
    cryptlink: '',
    level: 0,
    points: 0
  );

  Widget iconBySize(double height) {
    if (pic=='' || pic==null || pic=='null') {
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
      height: height,
    );
  }
  Widget icon() {
    if (pic=='' || pic==null || pic=='null') {
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
  String image_href() {
    if (pic=='' || pic==null || pic=='null') {
      return Profile.default_img;
    }

    return Profile.source + pic;
  }

  static Profile json(var input) {
    return Profile(
      name: input['name'],
      pic: input['pic'],
      cryptlink: input['cryptlink'],
      email: input['email'],
      shortBio: input['shortBio'],
      level: input['level'],
      points: input['points']
    );
  }
  static Profile litejson(var input) {
    return Profile(
      name: input['name'],
      pic: input['pic'],
      cryptlink: input['cryptlink'],
      email: '',
      shortBio: '',
      level: 0,
      points: 0,
    );
  }
  static Profile lite(String input) {
    for (int i=0;i<ArrivalData.profiles.length;i++) {
      if (ArrivalData.profiles[i].cryptlink==input) {
        return ArrivalData.profiles[i];
      }
    }
    Profile P = Profile(
      name: '',
      pic: '',
      email: '',
      shortBio: '',
      cryptlink: input,
      level: 0,
      points: 0
    );
    socket.emit('profile lite', {
      'link': input,
    });
    ArrivalData.innocentAdd(ArrivalData.profiles, P);
    return P;
  }
  static Profile link(String input) {
    for (int i=0;i<ArrivalData.profiles.length;i++) {
      if (ArrivalData.profiles[i].cryptlink==input) {
        return ArrivalData.profiles[i];
      }
    }
    Profile P = Profile(
      name: '',
      pic: '',
      email: '',
      shortBio: '',
      cryptlink: input,
      level: 0,
      points: 0
    );
    socket.emit('profile get', {
      'link': input,
    });
    ArrivalData.innocentAdd(ArrivalData.profiles, P);
    return P;
  }
}
