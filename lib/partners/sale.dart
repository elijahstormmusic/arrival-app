/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../data/arrival.dart';
import '../data/socket.dart';
import '../const.dart';

import 'partner.dart';
import 'page.dart';

class Sale {
  static final String source =
    Constants.media_source;
  static final String default_img =
    Constants.basic_plant_image;

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
    @required this.pic,
    @required this.partner,
  }) {
    ArrivalData.innocentAdd(partner.sales, this);
  }

  NetworkImage card_image() {
    if (pic==null) return NetworkImage(Sale.default_img);
    return NetworkImage(Sale.source + pic);
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
      pic: data['cloud'],
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
  partner: Partner.blankPartner,
);
