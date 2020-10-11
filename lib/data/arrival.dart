/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:convert';
import '../posts/post.dart';
import '../data/cards/partners.dart';
import '../data/cards/articles.dart';
import '../data/cards/sales.dart';
import '../posts/page.dart';
import '../users/profile.dart';
import '../users/data.dart';
import '../data/local.dart';
import '../data/link.dart';
import '../foryou/row_card.dart';

class ArrivalData {
  static List<RowCard> foryou;

  static List<Post> posts;
  static List<Profile> profiles;
  static List<Business> partners;
  static List<Article> articles;
  static List<Sale> sales;

  static final DateTime default_time = new DateTime(1996, 9, 29);
  static final PARTNERS = 'partners.json';
  static final ARTICLES = 'articles.json';

  static int innocentAdd(List<dynamic> _list, dynamic _input) {
    for (int i=0;i<_list.length;i++) {
      if (_list[i].cryptlink==_input.cryptlink) {
        return i;
      }
    }
    _list.add(_input);
    return _list.length - 1;
  }

  static void save() async {
    ArrivalFiles file = ArrivalFiles(PARTNERS);

    Map<String, dynamic> data = Map<String, dynamic>();

    for (var i=0;i<ArrivalData.partners.length;i++) {
      data[ArrivalData.partners[i].cryptlink] =
        jsonEncode(ArrivalData.partners[i].toJson());
    }

    await file.write(data);

    file = ArrivalFiles(ARTICLES);

    data = Map<String, dynamic>();

    for (var i=0;i<ArrivalData.articles.length;i++) {
      data[ArrivalData.articles[i].cryptlink] =
        jsonEncode(ArrivalData.articles[i].toJson());
    }

    await file.write(data);
  }
  static void load() async {
    ArrivalData.partners = List<Business>();
    ArrivalData.posts = List<Post>();
    ArrivalData.profiles = List<Profile>();
    ArrivalData.articles = List<Article>();
    ArrivalData.sales = List<Sale>();

    try {
      (await ArrivalFiles(PARTNERS).readAll())
        .forEach((String key, dynamic value) =>
          ArrivalData.innocentAdd(ArrivalData.partners, Business.json(
            jsonDecode(value)
          )));
    } catch (e) {
      print('-------');
      print('Arrival Error: when loading partner data');
      print(e);
      print('-------');
    }
    try {
      (await ArrivalFiles(ARTICLES).readAll())
        .forEach((String key, dynamic value) =>
          ArrivalData.innocentAdd(ArrivalData.articles, Article.json(
            jsonDecode(value)
        )));
    } catch (e) {
      print('-------');
      print('Arrival Error: when loading article data');
      print(e);
      print('-------');
    }
  }
  static void refresh() async {
    try {
      ArrivalFiles(PARTNERS).delete();
    } catch (e) {
      print('-------');
      print('Arrival Error: when deleting partner file');
      print(e);
      print('-------');
    }
    try {
      ArrivalFiles(ARTICLES).delete();
    } catch (e) {
      print('-------');
      print('Arrival Error: when deleting article file');
      print(e);
      print('-------');
    }
  }
}
