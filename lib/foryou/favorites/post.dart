/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../../users/page.dart';
import '../../data/link.dart';
import '../../data/arrival.dart';
import '../../bookmarks/casing.dart';

class PostFavorites extends CasingFavorites {

  @override
  void open(Map<String, dynamic> data) {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => ProfilePage.fromLink(
        data['link'],
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  Map<String, dynamic> generateListData(int i) {
    return {
      'link': ArrivalData.profiles[i].cryptlink,
      'icon': ArrivalData.profiles[i].media_href(),
      'name': ArrivalData.profiles[i].name,
    };
  }

  @override
  int listSize() {
    return ArrivalData.profiles.length;
  }
}
