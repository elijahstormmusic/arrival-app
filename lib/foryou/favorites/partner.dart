/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../explore.dart';
import '../../partners/page.dart';
import '../../partners/industries.dart';
import '../../partners/industry_display.dart';
import '../../partners/partner.dart';
import '../../data/link.dart';
import '../../data/arrival.dart';
import '../../bookmarks/casing.dart';
import '../../const.dart';

class PartnerFavorites extends CasingFavoritesBox {
  void explore() {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => Explore(type: 'partners'),
      fullscreenDialog: true,
    ));
  }

  @override
  void open(Map<String, dynamic> data) {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => PartnerIndustryDisplay(
        data['link'],
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  Map<String, dynamic> generateListData(int i) => {
            'link': LocalIndustries.all[i].type.index.toString(),
            'color': LocalIndustries.all[i].color,
            'icon': LocalIndustries.all[i].image,
            'name': LocalIndustries.all[i].name,
          };

  @override
  int listSize() => LocalIndustries.all.length;

  @override
  int bookmarkableType() => 11;
}
