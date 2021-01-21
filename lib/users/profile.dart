/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import '../data/arrival.dart';
import '../data/link.dart';
import '../data/socket.dart';
import '../const.dart';
import '../styles.dart';
import '../posts/story/story.dart';

import 'page.dart';

class Profile {
  static final String default_img =
    Constants.default_profile_pic;
  static final String source =
    Constants.media_source;

  final String cryptlink;
  final bool verified;
  String name;
  String pic;
  String shortBio;
  String email;
  int level;
  int points;

  int followersCount;
  int followingCount;

  Story story;

  List<Story> storyHighlights = <Story>[];

  dynamic toJson() {
    return {
      'name': name,
      'pic': pic,
      'verified': verified,
      'cryptlink': cryptlink,
      'email': email,
      'shortBio': shortBio,
      'level': level,
      'points': points,
    };
  }

  Profile({
    @required this.name,
    this.verified = false,
    @required this.pic,
    @required this.email,
    @required this.shortBio,
    @required this.cryptlink,
    @required this.level,
    @required this.points,

    this.followersCount = 0,
    this.followingCount = 0,
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

  Widget clickable_name({
            Color color = Styles.ArrivalPalletteBlack,
            double size = 22.0,
        }) => GestureDetector(
    onTap: () => Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => navigateTo(),
      fullscreenDialog: true,
    )),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            color: color,
            fontSize: size,
            fontFamily: 'Helvetica',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(width: 18.0),
        verified ? Container(width: 0) :
        Styles.VerifiedUserIcon,
      ],
    ),
  );
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
  String media_href() {
    if (pic=='' || pic==null || pic=='null') {
      return Profile.default_img;
    }

    return Profile.source + pic;
  }
  ProfilePage navigateTo() {
    return ProfilePage.fromLink(cryptlink);
  }

  void navigateToProfile() {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => ProfilePage.user(this),
      fullscreenDialog: true,
    ));
  }
  void levelUp() {
    if (points<Profile.findPointsToNextLevel(level)) return;
    level += 1;
  }
  void earnPoints(int amount) {
    points += amount;
    if (points>=Profile.findPointsToNextLevel(level)) levelUp();
  }

  static Profile json(var input) {
    return Profile(
      name: input['name'],
      verified: input['verified'],
      pic: input['pic'],
      cryptlink: input['cryptlink'],
      email: input['email'],
      shortBio: input['shortBio'],
      level: input['level'],
      points: input['points'],
      followersCount: input['followersCount'],
      followingCount: input['followingCount'],
    );
  }
  static Profile litejson(var input) {
    return Profile(
      name: input['name'],
      verified: input['verified'],
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

  static int findPointsToNextLevel(int level) {
    return ((100 * level).toDouble() * .85).toInt();
  }
}
