/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../data/cards/articles.dart';
import '../screens/article.dart';
import '../styles.dart';
import '../widgets/cards.dart';
import '../data/preferences.dart';
import 'row_card.dart';

class ArticleCard extends StatelessWidget {
  ArticleCard(this.article);

  final Article article;

  Widget _buildDetails() {
    return FrostyBackground(
      color: Styles.ArrivalPalletteYellowFrosted,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              article.title,
              style: Styles.cardTitleText,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onPressed: () {
        Navigator.of(context).push<void>(CupertinoPageRoute(
          builder: (context) => ArticleDisplayPage(article),
          fullscreenDialog: true,
        ));
      },
      child: Stack(
        children: [
          Semantics(
            label: 'Logo for ${article.title}',
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: article.headline_image(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildDetails(),
          ),
        ],
      ),
    );
  }
}

class RowArticle extends RowCard {

  final Article post;

  RowArticle(
    @required this.post,
  );

  @override
  Widget generate(Preferences prefs) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: ArticleCard(post),
    );
  }
}
