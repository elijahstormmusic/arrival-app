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
    if (sale==null) return Container();
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: PressableCard(
        onPressed: () {
          Navigator.of(context).push<void>(CupertinoPageRoute(
            builder: (context) => BusinessDisplayPage(sale.partner.id),
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
  }
}

class RowSale extends RowCard {

  final List<Sale> sales;
  final bool isNear = true;

  RowSale(
    @required this.sales,
    // this.isNear,
  );

  @override
  Widget generate(Preferences prefs) {

    List<SaleCard> list_of_sales = List<SaleCard>();
    for (int i=0;i<sales.length;i++) {
      list_of_sales.add(SaleCard(sales[i], isNear));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list_of_sales,
        ),
      ),
    );
  }
}
