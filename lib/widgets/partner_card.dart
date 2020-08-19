// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import '../data/partners.dart';
import '../screens/details.dart';
import '../styles.dart';
import '../widgets/cards.dart';

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
            label: 'Logo for ${biz.name}',
            child: Container(
              height: isNear ? 300 : 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter:
                      isNear ? null : Styles.desaturatedColorFilter,
                  image: NetworkImage(
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
