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
    'https://res.cloudinary.com/arrival-kc/image/upload/v1599325166/sample.jpg';

  final String cryptlink;
  final String name;
  final String info;
  String pic;
  final Partner partner;

  bool isOpen() {
    return true;
  }

  Sale({
    @required this.cryptlink,
    @required this.name,
    @required this.info,
    @required this.partner,
  }) {
    ArrivalData.innocentAdd(partner.sales, this);
  }

  NetworkImage card_image() {
    if (pic==null) return NetworkImage(Sale.default_img);
    return NetworkImage(Sale.default_img);
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
      cryptlink: data['link'],
      name: data['name'],
      info: data['info'],
      partner: Partner.link(data['partner']),
    );
  }
  PartnerDisplayPage navigateTo() {
    return PartnerDisplayPage(partner.cryptlink);
  }
}
Sale blankSale = Sale(
  cryptlink: '',
  name: 'no sale',
  info: 'we apologize, but no sale could be found',
  partner: blankPartner,
);
