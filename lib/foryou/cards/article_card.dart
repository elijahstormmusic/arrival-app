/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../../articles/article.dart';
import '../../data/link.dart';
import '../../articles/page.dart';
import '../../styles.dart';
import '../../widgets/cards.dart';
import '../../data/preferences.dart';
import 'row_card.dart';

class ArticleCard extends StatelessWidget {
  ArticleCard(this.article);

  final Article article;

  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          article.date.substring(2, 10).replaceAll('-', ' / ') + '\n'
          + 'by ' + article.author,
          style: Styles.articleCardTitleAuthor,
        ),
        SizedBox(height: 16),
        Text(
          article.title,
          style: Styles.articleCardTitleText,
        ),
        SizedBox(height: 8),
        Expanded(
          child: Text(
            article.short_intro,
            style: Styles.articleCardTitleShortIntro,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onPressed: () {
        Arrival.navigator.currentState.push(MaterialPageRoute(
          builder: (context) => ArticleDisplayPage(article.cryptlink),
          fullscreenDialog: true,
        ));
      },
      color: Styles.ArrivalPalletteWhite,
      borderRadius: const BorderRadius.all(Radius.circular(0)),
      upElevation: 7,
      downElevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 140,
              height: 160,
              padding: EdgeInsets.only(right: 10),
              child: _buildDetails(context),
            ),
            Semantics(
              label: 'Logo for ${article.title}',
              child: Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Styles.ArrivalPalletteBlue,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: article.headline_image(),
                  ),
                ),
              ),
            ),
          ],
        ),
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
      padding: EdgeInsets.only(bottom: 24),
      child: ArticleCard(post),
    );
  }
}
