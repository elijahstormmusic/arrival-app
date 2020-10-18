// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:scoped_model/scoped_model.dart';
import 'arrival.dart';
import 'link.dart';
import '../partners/partner.dart';
import '../articles/article.dart';
import '../partners/sale.dart';
import '../posts/post.dart';

class AppState extends Model {

  List<Partner> get allPartners => List<Partner>.from(ArrivalData.partners);

  Partner getPartner(String link) => ArrivalData.partners.singleWhere((v) => v.cryptlink == link);

  List<Partner> get availablePartners {
    return ArrivalData.partners.where((v) => v.isOpen()).toList();
  }

  List<Partner> get unavailablePartners {
    return ArrivalData.partners.where((v) => !v.isOpen()).toList();
  }

  List<Partner> get favoritePartners =>
      ArrivalData.partners.where((v) => v.isFavorite).toList();

  List<Post> searchPosts(String terms) => ArrivalData.posts
      .where((v) => v.caption.toLowerCase().contains(terms.toLowerCase()))
      .toList();
  List<Partner> searchPartners(String terms) => ArrivalData.partners
      .where((v) => v.name.toLowerCase().contains(terms.toLowerCase()))
      .toList();

  void setFavorite(String link, bool isFavorite) {
    var Partner = getPartner(link);
    Partner.isFavorite = isFavorite;
    notifyListeners();
  }

  static Season _getSeasonForDate(DateTime date) {
    // Technically the start and end dates of seasons can vary by a day or so,
    // but this is close enough for produce.
    switch (date.month) {
      case 1:
        return Season.winter;
      case 2:
        return Season.winter;
      case 3:
        return date.day < 21 ? Season.winter : Season.spring;
      case 4:
        return Season.spring;
      case 5:
        return Season.spring;
      case 6:
        return date.day < 21 ? Season.spring : Season.summer;
      case 7:
        return Season.summer;
      case 8:
        return Season.summer;
      case 9:
        return date.day < 22 ? Season.autumn : Season.winter;
      case 10:
        return Season.autumn;
      case 11:
        return Season.autumn;
      case 12:
        return date.day < 22 ? Season.autumn : Season.winter;
      default:
        throw ArgumentError('Can\'t return a season for month #${date.month}.');
    }
  }
}
