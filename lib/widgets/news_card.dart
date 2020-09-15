// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import '../data/cards/partners.dart';
import '../screens/biz_details.dart';
import '../styles.dart';
import '../widgets/cards.dart';

class NewsCard extends StatelessWidget {
  NewsCard(this.news, this.isNear, this.isFavIndustry);

  final Business news;
  final bool isNear;
  final bool isFavIndustry;

  Widget _buildDetails() {
    return FrostyBackground(
      color: Color(0x90ffffaa),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              news.name,
              style: Styles.cardTitleText,
            ),
            Text(
              news.shortDescription,
              style: Styles.cardDescriptionText,
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
          builder: (context) => BusinessDisplayPage(news.id),
          fullscreenDialog: true,
        ));
      },
      child: Stack(
        children: [
          Semantics(
            label: 'A card background featuring ${news.name}',
            child: Container(
              height: isNear ? 300 : 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                      isNear ? null : Styles.desaturatedColorFilter,
                  image: NetworkImage(
                    news.images.storefront,
                  ),
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
