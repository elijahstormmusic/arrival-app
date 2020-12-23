/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../explore.dart';
import '../../data/link.dart';
import '../../data/arrival.dart';
import '../../users/data.dart';
import '../../bookmarks/casing.dart';
import '../../posts/story/story.dart';
import '../../posts/story/display.dart';


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
            'link': ArrivalData.story_feed[i].user.cryptlink,
            'icon': Story.source + ArrivalData.story_feed[i].user.pic,
            'name': ArrivalData.story_feed[i].user.name,
            'story': ArrivalData.story_feed[i],
          };

  @override
  int listSize() => ArrivalData.story_feed.length;
}
