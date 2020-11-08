/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../data/arrival.dart';
import '../data/socket.dart';

import 'partner.dart';
import 'page.dart';

class Sale {
  static final String source =
    'https://res.cloudinary.com/arrival-kc/image/upload/';
  static final String default_img =
    'https://arrival-app.herokuapp.com/includes/img/default-profile-pic.png';

  final int id;
  final String cryptlink;
  final String name;
  String pic;
  final String shortDescription;
  final Partner partner;

  bool isOpen() {
    return true;
  }

  Sale({
    @required this.id,
    @required this.cryptlink,
    @required this.name,
    @required this.shortDescription,
    @required this.partner,
  }) {
    ArrivalData.innocentAdd(partner.sales, this);
  }

  AssetImage card_image() {
    if (pic==null) return AssetImage(Sale.default_img);
    return AssetImage(Sale.default_img);
    // return NetworkImage(Sale.source + pic);
  }
  Widget image() {
    if (pic==null) return Image.asset('assets/loading/Bucket-1s-200px.gif');
    return Image.network(Sale.source + pic);
  }
  String media_href() {
    if (pic==null) return Sale.default_img;
    return Sale.source + pic;
  }

  static Sale json(var data) {
    return Sale(
      id: Sale.index++,
      cryptlink: data['link'],
      name: data['name'],
      shortDescription: data['info'],
      partner: Partner.link(data['partner']),
    );
  }
  static PartnerDisplayPage navigateTo(String link) {
    return PartnerDisplayPage(Partner.link(link).cryptlink);
  }
  static int index = 0;
}
Sale blankSale = Sale(
  id: -1,
  cryptlink: '',
  name: 'no sale',
  shortDescription: 'we apologize, but no sale could be found',
  partner: blankPartner,
);
