/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../../partners/partner.dart';
import '../../partners/industries.dart';
import '../../data/arrival.dart';
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

  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        SizedBox(height: 8.0),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .8,
                height: 26.0,
                child: Text(
                  biz.name,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.partnerCardTitle,
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: biz.rating > 5
                    ? Styles.ArrivalPalletteGreenLighten
                    : Styles.ArrivalPalletteCream,
                  borderRadius: BorderRadius.circular(99.0),
                ),
                width: 28,
                height: 28,
                child: Center(
                  child: Text(
                    (((biz.rating - 1.0) * 10.0).floor() / 10.0).toString(),
                    style: TextStyle(
                      color: biz.rating > 5
                        ? Styles.ArrivalPalletteGreenDarken
                        : Styles.ArrivalPalletteBlack,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 4.0),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          // height: 12,
          child: Text(
            biz.priceRangeToString() + ' • ' + biz.shortDescription,
            overflow: TextOverflow.ellipsis,
            style: Styles.partnerCardSub,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Arrival.navigator.currentState.push(MaterialPageRoute(
          builder: (context) => PartnerDisplayPage(biz.cryptlink),
          fullscreenDialog: true,
        ));
      },
      child: PhysicalModel(
        elevation: 7,
        shape: BoxShape.rectangle,
        shadowColor: Styles.ArrivalPalletteGrey,
        color: Styles.ArrivalPalletteWhite,
        child: Container(
          height: 320.0,
          color: Styles.ArrivalPalletteWhite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Semantics(
                label: 'Logo for ${biz.name}',
                child: Container(
                  height: isNear ? 250 : 100,
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

              _buildDetails(context),
            ],
          ),
        ),
      ),
    );
  }
}

class RowPartner extends RowCard {

  final Partner biz;
  final bool isNear = true;

  int get datatype => DataType.partner;
  String get cryptlink => biz.cryptlink;

  RowPartner(
    @required this.biz,
    // this.isNear,
  );

  @override
  Widget generate(Preferences prefs) {
      return Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
        child: FutureBuilder<Set<SourceIndustry>>(
          future: prefs.preferredIndustries,
          builder: (context, snapshot) {
            final data = snapshot.data ?? <SourceIndustry>{};
            return PartnerCard(biz, isNear, data.contains(biz.industry));
          }),
      );
    }
}
