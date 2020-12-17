/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../explore.dart';
import '../../articles/page.dart';
import '../../articles/categories.dart';
import '../../articles/category_display.dart';
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
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => ArticleCategoryDisplay(
        data['link'],
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  Map<String, dynamic> generateListData(int i) => {
          'link': ArticleData.all[i].type.index.toString(),
          'color': ArticleData.all[i].color,
          'icon': ArticleData.all[i].image,
          'name': ArticleData.all[i].name,
        };

  @override
  int listSize() => ArticleData.all.length;

  @override
  int bookmarkableType() => DataType.categories;
}
