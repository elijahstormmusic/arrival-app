/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/link.dart';
import '../../data/socket.dart';
import '../../users/data.dart';
import '../../users/page.dart';
import '../../users/profile.dart';
import '../../styles.dart';
import '../../const.dart';

import 'upload.dart';
import 'display.dart';


class Story {
  static final String source =
    Constants.media_source;

  final String cryptlink;
  final Profile user;
  final List<StoryContent> content;
  bool seen = false;

  Story({
    @required this.cryptlink,
    @required this.user,
    @required this.content,
  });

  static Story json(Map<String, dynamic> data) {

    List<StoryContent> content = <StoryContent>[];

    for (int i=0;i<data['content'].length;i++) {
      data['content'][i]['user'] = data['user'];
      content.add(StoryContent.json(data['content'][i]));
    }

    return Story(
      cryptlink: data['link'],
      user: Profile.link(data['user']),
      content: content,
    );
  }

  Widget navigateTo() => StoryDisplay(this);
}

class StoryContent {

  final String cryptlink;
  final Profile user;
  final String media;
  final int time;
  final DateTime date;

  StoryContent({
    @required this.cryptlink,
    @required this.user,
    @required this.media,
    @required this.time,
    @required this.date,
  });

  static StoryContent json(Map<String, dynamic> data) {

    return StoryContent(
      cryptlink: data['link'],
      user: Profile.link(data['user']),
      media: Story.source + data['media'],
      time: data['time'],
      date: DateTime.parse(data['date']),
    );
  }
}
