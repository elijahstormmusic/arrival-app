/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../bookmarks/casing.dart';
import '../foryou/explore.dart';
import '../data/link.dart';
import '../data/arrival.dart';
import '../users/data.dart';
import '../users/profile.dart';
import '../posts/story.dart';
import '../posts/story_upload.dart';
import '../foryou/explore.dart';

class StoriesHighlights extends CasingFavorites {
  Profile user;

  StoriesHighlights(this.user);


  @override
  String getExploreText() => user == UserData.client ?
                            'create new' : 'explore';
  void explore() {
    if (user == UserData.client) {
      Arrival.navigator.currentState.push(MaterialPageRoute(
        builder: (context) => StoryUpload(),
        fullscreenDialog: true,
      ));
    }
    else {
      Arrival.navigator.currentState.push(MaterialPageRoute(
        builder: (context) => Explore(type: 'posts'),
        fullscreenDialog: true,
      ));
    }
  }

  @override
  void open(Map<String, dynamic> data) {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => StoryDisplay(
        data['story']
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  Map<String, dynamic> generateListData(int i) => {
          'link': user.storyHighlights[i].cryptlink,
          'icon': user.storyHighlights[i].icon,
          'name': user.storyHighlights[i].name,
          'story': user.storyHighlights[i],
        };

  @override
  int listSize() => user.storyHighlights.length;
}
