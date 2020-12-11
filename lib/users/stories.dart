/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../bookmarks/casing.dart';
import '../foryou/explore.dart';
import '../data/link.dart';
import '../data/arrival.dart';
import '../posts/story.dart';

class StoriesHighlights extends CasingFavorites {
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
        data['link'],
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  Map<String, dynamic> generateListData(int i) => {
            'link': ArrivalData.profiles[i].cryptlink,
            'icon': ArrivalData.profiles[i].media_href(),
            'name': ArrivalData.profiles[i].name,
          };

  @override
  int listSize() => ArrivalData.profiles.length;
}
