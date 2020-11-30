/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../explore.dart';
import '../../articles/page.dart';
import '../../articles/article.dart';
import '../../data/link.dart';
import '../../data/arrival.dart';
import '../../bookmarks/casing.dart';
import '../../styles.dart';

class ArticleFavorites extends CasingFavoritesBox {
  void explore() {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => Explore(type: 'articles'),
      fullscreenDialog: true,
    ));
  }

  @override
  void open(Map<String, dynamic> data) {
    print(data['link']);
    // Arrival.navigator.currentState.push(MaterialPageRoute(
    //   builder: (context) => ArticleDisplayPage(
    //     data['link'],
    //   ),
    //   fullscreenDialog: true,
    // ));
  }

  @override
  Map<String, dynamic> generateListData(int i) {
    return {
      'link': ArrivalData.articles[i].cryptlink,
      'color': Styles.ArrivalPalletteRedDarken,
      'icon': ArrivalData.articles[i].image_link(0),
      'name': ArrivalData.articles[i].author,
    };
  }

  @override
  int listSize() {
    return ArrivalData.articles.length;
  }
}
