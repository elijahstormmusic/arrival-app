// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';


class LatLng {
  final double lat;
  final double lng;

  LatLng(this.lat, this.lng);
}

enum SourceIndustry {
  none,
  cosmetics,
  entertainment,
  media,
  food,
  music,
}
class StoreImages {
  static const String source = 'https://arrival-app.herokuapp.com/partners/';

    // Strings are asset paths
  String href;
  String logo;
  String storefront;
  List<String> extras;

  StoreImages(String _href) {
    href = StoreImages.source + _href;
    logo = href + '/logo.jpg';
    storefront = href + '/stft.jpg';
    extras = List<String>();
  }
}
class Industry {
  final String name;
  final bool essential;
  final SourceIndustry type;
  Map<String, Business> companyList;  // a list of all the Business classes
                                      // contained -> all the ones that have
                                      // the industy enum index link

  Industry({
    @required this.name,
    @required this.type,
    @required this.essential,
  });
}
Industry blankIndustry = Industry(
  name: 'none',
  type: SourceIndustry.none,
  essential: false,
);

class LocalIndustries {
  static List<Industry> all = [
    Industry(
      name: 'Cosmetics',
      type: SourceIndustry.cosmetics,
      essential: false,
    ),
    Industry(
      name: 'Entertainment',
      type: SourceIndustry.entertainment,
      essential: true,
    ),
    Industry(
      name: 'Media',
      type: SourceIndustry.media,
      essential: true,
    ),
    Industry(
      name: 'Food',
      type: SourceIndustry.food,
      essential: true,
    ),
    Industry(
      name: 'Music',
      type: SourceIndustry.music,
      essential: true,
    ),
  ];

  static Industry industryGrabber(SourceIndustry index) {
    for (var i=0;i<all.length;i++) {
      if(all[i].type==index)
      {
        return all[i];
      }
    }
    return blankIndustry;
  }
}


class ContactList {
  String phoneNumber;
  String email;
  String facebook;
  String twitter;
  String instagram;
  String pintrest;
  String address;
  String city;
  String state;
  String zip;
  String website;

  ContactList({
    this.phoneNumber,
    this.email,
    this.facebook,
    this.twitter,
    this.instagram,
    this.pintrest,
    this.address,
    this.city,
    this.state,
    this.zip,
    this.website,
  });
}
class SalesList {
  String name;
  String info;

  SalesList({
    this.name,
    this.info,
  });
}
class Business {
  final int id;
  final String name;
  int yourRating;
  final double rating;
  final int ratingAmount;
  final LatLng location;
  final StoreImages images;
  final SourceIndustry industry; // an enum link to the Industy index
  final ContactList contact;
  final String shortDescription;
  final String cryptlink;
  SalesList sales;
  bool isFavorite;

  String toString() {
    return '>'+name+';'+rating.toString();
  }
  bool isOpen() {
    return true;
  }

  Business({
    @required this.id,
    @required this.name,
    @required this.rating,
    @required this.ratingAmount,
    @required this.location,
    @required this.images,
    @required this.industry,
    @required this.contact,
    @required this.shortDescription,
    @required this.sales,
    @required this.cryptlink,
    this.isFavorite = false,
  });
}
Business blankBusiness = Business(
  id: -1,
  name: 'none',
  rating: 0,
  ratingAmount: 0,
  location: LatLng(0, 0),
  images: StoreImages('empty'),
  industry: SourceIndustry.none,
  contact: ContactList(),
  shortDescription: 'description',
  sales: SalesList(),
  cryptlink: "",
);


enum Season {
  winter,
  spring,
  summer,
  autumn,
}
const Map<Season, String> seasonNames = {
  Season.winter: 'Winter',
  Season.spring: 'Spring',
  Season.summer: 'Summer',
  Season.autumn: 'Autumn',
};