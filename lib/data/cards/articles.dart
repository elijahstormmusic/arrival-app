/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class Article {
  static final String source =
    'https://arrival-app.herokuapp.com/partners/';

  final int id;
  final String cryptlink;
  final String name;
  final String shortDescription;
  String header_img = 'https://arrival-app.herokuapp.com/includes/img/default-profile-pic.png';

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

  Article({
    @required this.id,
    @required this.cryptlink,
    @required this.name,
    @required this.shortDescription,
  });

  NetworkImage card_image() {
    return NetworkImage(Article.source + 'logo.jpg');
  }
  Widget image() {
    return Image.network(Article.source + 'logo.jpg');
  }

  static Article json(var data) {
    return Article(
      id: Article.index++,
      cryptlink: data['link'],
      name: data['name'],
      shortDescription: data['info'],
    );;
  }
  static Article parse(String input) {
    var id, name, rating, ratingAmount, lat, lng,
        location, images, industry, contact,
        shortDescription, sales, cryptlink;

    var startDataLoc, endDataLoc = 0;

    id = Article.index++;

    startDataLoc = input.indexOf('cryptlink')        + 10;
    endDataLoc = input.indexOf(',', startDataLoc);
    cryptlink = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('name')            + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    name = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('info')            + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    shortDescription = input.substring(startDataLoc, endDataLoc);

    return Article(
      id: id,
      cryptlink: cryptlink,
      name: name,
      shortDescription: shortDescription,
    );
  }
  static int index = 0;
}
Article blankArticle = Article(
  id: -1,
  cryptlink: '',
  name: 'none',
  shortDescription: '',
);
