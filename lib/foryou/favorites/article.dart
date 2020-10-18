/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../../articles/page.dart';
import '../../articles/article.dart';
import '../../data/link.dart';
import '../../data/arrival.dart';
import '../../bookmarks/casing.dart';

class ArticleFavorites extends CasingFavorites {

  @override
  void open(Map<String, dynamic> data) {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => ArticleDisplayPage(
        data['link'],
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  Map<String, dynamic> generateListData(int i) {
    return {
      'link': ArrivalData.articles[i].cryptlink,
      'icon': ArrivalData.articles[i].image_link(0),
      'name': ArrivalData.articles[i].author,
    };
  }

  @override
  int listSize() {
    return ArrivalData.articles.length;
  }
}
