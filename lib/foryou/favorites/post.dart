/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../explore.dart';
import '../../data/link.dart';
import '../../data/arrival.dart';
import '../../users/data.dart';
import '../../bookmarks/casing.dart';
import '../../posts/story.dart';


class PostFavorites extends CasingFavorites {
  void explore() {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => Explore(type: 'posts'),
      fullscreenDialog: true,
    ));
  }

  @override
  void open(Map<String, dynamic> data) {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => StoryDisplay(
        data['story'],
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  Map<String, dynamic> generateListData(int i) => {
            'link': Story.TestData.cryptlink,
            'icon': Story.TestData.icon,
            'name': Story.TestData.name,
            'story': Story.TestData,
          };
  // @override
  // Map<String, dynamic> generateListData(int i) => {
  //           'link': UserData.followers[i].cryptlink,
  //           'icon': UserData.followers[i].media_href(),
  //           'name': UserData.followers[i].name,
  //         };

  @override
  int listSize() => UserData.followers.length + 1;
}
