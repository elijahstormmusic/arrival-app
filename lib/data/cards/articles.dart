/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class Article {
  static int index = 0;
  static final String source =
    'https://res.cloudinary.com/arrival-kc/image/upload/';
  static final String default_img =
    'https://arrival-app.herokuapp.com/includes/img/default-profile-pic.png';

  final int id;
  final String cryptlink;
  final String title;
  final String author;
  final String date;
  final String topic;
  final List<dynamic> body;
  final List<dynamic> images;
  final String extra_info;

  String toString() {
    String str = '';
    str += 'cryptlink:' + cryptlink + ',';
    str += 'title:' + title + ',';
    str += 'author:' + author + ',';
    str += 'date:' + date + ',';
    str += 'topic:' + topic + ',';
    str += 'body:' + jsonEncode(body) + ',';
    str += 'images:' + jsonEncode(images) + ',';
    str += 'extra_info:' + extra_info + ',';
    return str;
  }

  Article({
    @required this.id,
    @required this.cryptlink,
    @required this.title,
    @required this.author,
    @required this.date,
    @required this.topic,
    @required this.body,
    @required this.images,
    @required this.extra_info,
  }) {
    if(images.length<1) images.add(Article.default_img);
  }

  NetworkImage headline_image() {
    return NetworkImage(Article.source + images[0]);
  }
  String image_link(int index) {
    if(index>=images.length) return images[0];
    return Article.source + images[index];
  }

  static Article json(var data) {
    return Article(
      id: Article.index++,
      cryptlink: data['link'],
      title: data['title'],
      author: data['author'],
      date: data['date'],
      topic: data['topic'],
      body: data['body'],
      images: data['images'],
      extra_info: data['extra_info'],
    );
  }
  static Article parse(String input) {
    var id, title, author, date, topic,
        body, images, extra_info, cryptlink;

    var startDataLoc, endDataLoc = 0;

    id = Article.index++;

    startDataLoc = input.indexOf('cryptlink')        + 10;
    endDataLoc = input.indexOf(',', startDataLoc);
    cryptlink = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('title')             + 6;
    endDataLoc = input.indexOf(',', startDataLoc);
    title = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('author')            + 7;
    endDataLoc = input.indexOf(',', startDataLoc);
    author = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('date')              + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    date = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('topic')             + 6;
    endDataLoc = input.indexOf(',', startDataLoc);
    topic = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('body')              + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    body = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('images')            + 7;
    endDataLoc = input.indexOf(',', startDataLoc);
    images = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('extra_info')       + 11;
    endDataLoc = input.indexOf(',', startDataLoc);
    extra_info = input.substring(startDataLoc, endDataLoc);

    return Article(
      id: id,
      cryptlink: cryptlink,
      title: title,
      author: author,
      date: date,
      topic: topic,
      body: body,
      images: images,
      extra_info: extra_info,
    );
  }
}
Article blankArticle = Article(
  id: -1,
  cryptlink: '',
  title: '',
  author: '',
  date: '',
  topic: '',
  body: [],
  images: [],
  extra_info: '',
);
