/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import '../styles.dart';
import '../const.dart';


enum ArticleCategories {
  none,
  film,
  music,
  art,
  world,
  currentEvents,
  tech,
  finance,
  sports,
  fitness,
  fashion,
  auto,
  anime,
  comics,
  thc,
  space,
  travel,
  kansasCity,
  comedy,
  shortStories,
  showerThoughts,
}

class Category {
  final String name;
  final ArticleCategories type;
  final Color color;
  final String image;

  Category({
    @required this.name,
    @required this.type,
    @required this.color,
    @required this.image
  });
}

class ArticleData {
  static List<Category> all = [
    Category(
      name: 'none',
      type: ArticleCategories.none,
      color: Styles.ArrivalPalletteRedDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Film',
      type: ArticleCategories.film,
      color: Styles.ArrivalPalletteBlueDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Music',
      type: ArticleCategories.music,
      color: Styles.ArrivalPalletteYellowDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Art',
      type: ArticleCategories.art,
      color: Styles.ArrivalPalletteRedDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'World',
      type: ArticleCategories.world,
      color: Styles.ArrivalPalletteBlueDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'CurrentEvents',
      type: ArticleCategories.currentEvents,
      color: Styles.ArrivalPalletteYellowDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Tech',
      type: ArticleCategories.tech,
      color: Styles.ArrivalPalletteRedDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Finance',
      type: ArticleCategories.finance,
      color: Styles.ArrivalPalletteBlueDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Sports',
      type: ArticleCategories.sports,
      color: Styles.ArrivalPalletteYellowDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Fitness',
      type: ArticleCategories.fitness,
      color: Styles.ArrivalPalletteRedDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Fashion',
      type: ArticleCategories.fashion,
      color: Styles.ArrivalPalletteBlueDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Auto',
      type: ArticleCategories.auto,
      color: Styles.ArrivalPalletteYellowDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Anime',
      type: ArticleCategories.anime,
      color: Styles.ArrivalPalletteRedDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Comics',
      type: ArticleCategories.comics,
      color: Styles.ArrivalPalletteBlueDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'THC',
      type: ArticleCategories.thc,
      color: Styles.ArrivalPalletteYellowDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Space',
      type: ArticleCategories.space,
      color: Styles.ArrivalPalletteRedDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Travel',
      type: ArticleCategories.travel,
      color: Styles.ArrivalPalletteBlueDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Kansas City',
      type: ArticleCategories.kansasCity,
      color: Styles.ArrivalPalletteYellowDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Comedy',
      type: ArticleCategories.comedy,
      color: Styles.ArrivalPalletteRedDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Short Stories',
      type: ArticleCategories.shortStories,
      color: Styles.ArrivalPalletteBlueDarken,
      image: Constants.basic_plant_image,
    ),
    Category(
      name: 'Shower Thoughts',
      type: ArticleCategories.showerThoughts,
      color: Styles.ArrivalPalletteYellowDarken,
      image: Constants.basic_plant_image,
    ),
  ];

  static Category get(ArticleCategories index) {
    for (var i=0;i<all.length;i++) {
      if (all[i].type==index)
      {
        return all[i];
      }
    }
    return blankCategory;
  }

  static Category blankCategory = Category(
    name: 'none',
    type: ArticleCategories.none,
    color: Styles.ArrivalPalletteRedDarken,
    image: Constants.basic_plant_image,
  );
}
