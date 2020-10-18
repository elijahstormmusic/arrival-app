/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../../partners/page.dart';
import '../../partners/partner.dart';
import '../../data/link.dart';
import '../../data/arrival.dart';
import '../../bookmarks/casing.dart';

class PartnerFavorites extends CasingFavorites {

  @override
  void open(Map<String, dynamic> data) {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => PartnerDisplayPage(
        data['link'],
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  Map<String, dynamic> generateListData(int i) {
    return {
      'link': ArrivalData.partners[i].cryptlink,
      'icon': ArrivalData.partners[i].images.logo,
      'name': ArrivalData.partners[i].name,
    };
  }

  @override
  int listSize() {
    return ArrivalData.partners.length;
  }
}
