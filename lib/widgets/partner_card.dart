// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:Arrival/data/partners.dart';
import 'package:Arrival/screens/details.dart';
import 'package:Arrival/styles.dart';
import 'package:Arrival/widgets/cards.dart';

class BusinessCard extends StatelessWidget {
  BusinessCard(this.biz, this.isNear, this.isFavIndustry);

  final Business biz;
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
              biz.name,
              style: Styles.cardTitleText,
            ),
            Text(
              biz.shortDescription,
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
          builder: (context) => DetailsScreen(biz.id),
          fullscreenDialog: true,
        ));
      },
      child: Stack(
        children: [
          Semantics(
            label: 'A card background featuring ${biz.name}',
            child: Container(
              height: isNear ? 300 : 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                      isNear ? null : Styles.desaturatedColorFilter,
                  image: AssetImage(
                    biz.images.storefront,
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

class VeggieCard extends StatelessWidget {
  VeggieCard(this.veggie, this.isInSeason, this.isPreferredCategory);

  /// Veggie to be displayed by the card.
  final Veggie veggie;

  /// If the veggie is in season, it's displayed more prominently and the
  /// image is fully saturated. Otherwise, it's reduced and de-saturated.
  final bool isInSeason;

  /// Whether [veggie] falls into one of user's preferred [VeggieCategory]s
  final bool isPreferredCategory;

  Widget _buildDetails() {
    return FrostyBackground(
      color: Color(0x90ffffff),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              veggie.name,
              style: Styles.cardTitleText,
            ),
            Text(
              veggie.shortDescription,
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
          builder: (context) => DetailsScreen(veggie.id),
          fullscreenDialog: true,
        ));
      },
      child: Stack(
        children: [
          Semantics(
            label: 'A card background featuring ${veggie.name}',
            child: Container(
              height: isInSeason ? 300 : 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                      isInSeason ? null : Styles.desaturatedColorFilter,
                  image: AssetImage(
                    veggie.imageAssetPath,
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
