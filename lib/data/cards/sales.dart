/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class Sale {
  static final String source =
    'https://arrival-app.herokuapp.com/partners/';

  final int id;
  final String cryptlink;
  final String name;
  final String shortDescription;

  String toString() {
    String str = '';
    str += 'cryptlink:' + cryptlink + ',';
    str += 'name:' + name + ',';
    str += 'info:' + shortDescription + ',';
    return str;
  }
  bool isOpen() {
    return true;
  }

  Sale({
    @required this.id,
    @required this.cryptlink,
    @required this.name,
    @required this.shortDescription,
  });

  NetworkImage card_image() {
    return NetworkImage(Sale.source + 'partners/logo.jpg');
  }
  Widget image() {
    return Image.network(Sale.source + 'partners/logo.jpg');
  }

  static Sale json(var data) {
    return Sale(
      id: Sale.index++,
      cryptlink: data['link'],
      name: data['name'],
      shortDescription: data['info'],
    );;
  }
  static Sale parse(String input) {
    var id, name, rating, ratingAmount, lat, lng,
        location, images, industry, contact,
        shortDescription, sales, cryptlink;

    var startDataLoc, endDataLoc = 0;

    id = Sale.index++;

    startDataLoc = input.indexOf('cryptlink')        + 10;
    endDataLoc = input.indexOf(',', startDataLoc);
    cryptlink = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('name')            + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    name = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('info')            + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    shortDescription = input.substring(startDataLoc, endDataLoc);

    return Sale(
      id: id,
      cryptlink: cryptlink,
      name: name,
      shortDescription: shortDescription,
    );
  }
  static int index = 0;
}
Sale blankSale = Sale(
  id: -1,
  cryptlink: '',
  name: 'none',
  shortDescription: '',
);
