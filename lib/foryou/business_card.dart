/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../data/cards/partners.dart';
import '../screens/details.dart';
import '../styles.dart';
import '../widgets/cards.dart';
import '../data/preferences.dart';
import 'row_card.dart';

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

class RowBusiness extends RowCard {

  final Business biz;
  final bool isNear = true;

  RowBusiness(
    @required this.biz,
    // this.isNear,
  );

  @override
  Widget generate(Preferences prefs) {
      return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
        child: FutureBuilder<Set<SourceIndustry>>(
          future: prefs.preferredIndustries,
          builder: (context, snapshot) {
            final data = snapshot.data ?? <Industry>{};
            return BusinessCard(biz, isNear, data.contains(biz.industry));
          }),
        );
      }
}
