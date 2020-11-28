/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../../partners/page.dart';
import '../../partners/partner.dart';
import '../../data/link.dart';
import '../../data/arrival.dart';
import '../../bookmarks/casing.dart';

class PartnerFavorites extends CasingFavoritesBox {

  @override
  void open(Map<String, dynamic> data) {
    print(data['link']);
    // Arrival.navigator.currentState.push(MaterialPageRoute(
    //   builder: (context) => PartnerDisplayPage(
    //     data['link'],
    //   ),
    //   fullscreenDialog: true,
    // ));
  }

  @override
  Map<String, dynamic> generateListData(int i) {
    return {
      'link': LocalIndustries.all[i].type,
      'color': LocalIndustries.all[i].color,
      'icon': 'https://res.cloudinary.com/arrival-kc/image/upload/v1599325166/sample.jpg',
      'name': LocalIndustries.all[i].name,
    };
  }

  @override
  int listSize() {
    return LocalIndustries.all.length;
  }
}
