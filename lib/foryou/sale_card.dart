/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../data/cards/sales.dart';
import '../screens/biz_details.dart';
import '../styles.dart';
import '../widgets/cards.dart';
import '../data/preferences.dart';
import 'row_card.dart';

class SaleCard extends StatelessWidget {
  SaleCard(this.sale, this.isNear);

  final Sale sale;
  final bool isNear;

  Widget _buildDetails() {
    return FrostyBackground(
      color: Color(0x90ffffaa),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              sale.name,
              style: Styles.saleTitle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: PressableCard(
        onPressed: () {
          Navigator.of(context).push<void>(CupertinoPageRoute(
            builder: (context) => BusinessDisplayPage(sale.biz),
            fullscreenDialog: true,
          ));
        },
        child: Stack(
          children: [
            Semantics(
              label: 'Logo for ${sale.name}',
              child: Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter:
                    isNear ? null : Styles.desaturatedColorFilter,
                    image: sale.card_image(),
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
      ),
    );
    return FractionallySizedBox(
      widthFactor: 0.45,
      child: PressableCard(
        onPressed: () {
          Navigator.of(context).push<void>(CupertinoPageRoute(
            builder: (context) => BusinessDisplayPage(sale.biz),
            fullscreenDialog: true,
          ));
        },
        child: Stack(
          children: [
            Semantics(
              label: 'Logo for ${sale.name}',
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter:
                    isNear ? null : Styles.desaturatedColorFilter,
                    image: sale.card_image(),
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
      ),
    );
  }
}

class RowSale extends RowCard {

  final Sale sale;
  final bool isNear = true;

  RowSale(
    @required this.sale,
    // this.isNear,
  );

  @override
  Widget generate(Preferences prefs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            SaleCard(sale, isNear),
            SaleCard(sale, isNear),
            SaleCard(sale, isNear),
            SaleCard(sale, isNear),
            SaleCard(sale, isNear),
            SaleCard(sale, isNear),
            SaleCard(sale, isNear),
            SaleCard(sale, isNear),
          ],
        ),
      ),
    );
  }
}
