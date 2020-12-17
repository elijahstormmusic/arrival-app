/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../data/arrival.dart';
import '../data/socket.dart';
import '../users/profile.dart';
import '../const.dart';

import 'page.dart';
import 'categories.dart';

class Article {
  static int index = 0;
  static final String source =
    Constants.media_source;
  static final String default_img =
    Constants.default_profile_pic;

  final int id;
  final String cryptlink;
  final String title;
  final String date;
  final String topic;
  final List<dynamic> body;
  final List<dynamic> images;
  final String short_intro;
  final String extra_info;
  final ArticleCategories category;
  String author;
  Profile profileAuthor;

  dynamic toJson() {
    return {
      'link': cryptlink,
      'title': title,
      'author': author,
      'category': category.index,
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
    this.category = ArticleCategories.none,
    @required this.date,
    @required this.topic,
    @required this.body,
    @required this.images,
    @required this.extra_info,
    this.short_intro,
  }) {
    if (images.length<1) images.add(Article.default_img);

    if (author.substring(0, 1)=='\$') {
      profileAuthor = Profile.lite(author);
      author = profileAuthor.name;
    }
  }

  NetworkImage headline_image() {
    return NetworkImage(Article.source + images[0]);
  }
  String image_link(int index) {
    if (index>=images.length) return Article.source + images[0];
    return Article.source + images[index];
  }

  static Article link(String input) {
    for (var i=0;i<ArrivalData.articles.length;i++) {
      if (ArrivalData.articles[i].cryptlink==input) {
        return ArrivalData.articles[i];
      }
    }
    Article A = Article(
      id: null,
      cryptlink: input,
      title: null,
      author: null,
      date: null,
      topic: null,
      body: null,
      images: null,
      extra_info: null,
    );
    socket.emit('articles get link', {
      'link': input,
    });
    ArrivalData.innocentAdd(ArrivalData.articles, A);
    return A;
  }
  static Article json(var data) {
    return Article(
      id: Article.index++,
      cryptlink: data['link'],
      title: data['title'],
      author: data['author'],
      category: ArticleCategories.values[data['category']],
      date: data['date'],
      topic: data['topic'],
      body: data['body'],
      images: data['images'],
      extra_info: data['extra_info'],
      short_intro: data['short_intro'],
    );
  }
  ArticleDisplayPage navigateTo() {
    return ArticleDisplayPage(cryptlink);
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
