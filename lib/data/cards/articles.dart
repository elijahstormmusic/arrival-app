/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:convert';
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

  dynamic toJson() {
    return {
      'link': cryptlink,
      'title': title,
      'author': author,
      'date': date,
      'topic': topic,
      'body': body,
      'images': images,
      'extra_info': extra_info,
    };
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
    if (images.length<1) images.add(Article.default_img);
  }

  NetworkImage headline_image() {
    return NetworkImage(Article.source + images[0]);
  }
  String image_link(int index) {
    if (index>=images.length) return images[0];
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
