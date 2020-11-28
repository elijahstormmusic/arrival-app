/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../../partners/partner.dart';
import '../../data/link.dart';
import '../../partners/page.dart';
import '../../styles.dart';
import '../../widgets/cards.dart';
import '../../data/preferences.dart';
import 'row_card.dart';

class PartnerCard extends StatelessWidget {
  PartnerCard(this.biz, this.isNear, this.isFavIndustry);

  final Partner biz;
  final bool isNear;
  final bool isFavIndustry;

  Widget _buildDetails() {
    return FrostyBackground(
      color: Styles.ArrivalPalletteWhiteFrosted,
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
        Arrival.navigator.currentState.push(MaterialPageRoute(
          builder: (context) => PartnerDisplayPage(biz.cryptlink),
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
      borderRadius: const BorderRadius.all(Radius.circular(5)),
    );
  }
}

class RowPartner extends RowCard {

  final Partner biz;
  final bool isNear = true;

  RowPartner(
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
            final data = snapshot.data ?? <SourceIndustry>{};
            return PartnerCard(biz, isNear, data.contains(biz.industry));
          }),
      );
    }
}
