/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../../partners/sale.dart';
import '../../partners/page.dart';
import '../../styles.dart';
import '../../widgets/cards.dart';
import '../../data/preferences.dart';
import '../../data/link.dart';
import '../../data/arrival.dart';
import 'row_card.dart';

class SaleCard extends StatefulWidget {
  SaleCard(this.prefs, this.sale);

  final Preferences prefs;
  final Sale sale;

  @override
  _SaleCardState createState() => _SaleCardState();
}

class _SaleCardState extends State<SaleCard> {

  Widget _buildDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.sale.name,
                  style: Styles.saleTitle,
                ),
                SizedBox(height: 8.0),
                Expanded(
                  child: Text(
                    widget.sale.info,
                    style: Styles.saleInfo,
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 130,
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  widget.sale.partner.name,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.saleOwner,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await widget.prefs.toggleBookmarked(DataType.sale, widget.sale.cryptlink);
                  setState(() => 0);
                },
                child: FutureBuilder<bool>(
                  future: widget.prefs.isBookmarked(DataType.sale, widget.sale.cryptlink),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
                    snapshot.hasData ?
                    (snapshot.data ? Styles.bookmark_filled : Styles.bookmark_icon)
                    : Styles.bookmark_icon,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sale==null) return Container();
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      width: 220,
      height: 300,
      margin: const EdgeInsets.only(bottom: 10),
      child: PressableCard(
        onPressed: () {
          Arrival.navigator.currentState.push(MaterialPageRoute(
            builder: (context) => PartnerDisplayPage(widget.sale.partner.cryptlink),
            fullscreenDialog: true,
          ));
        },
        color: Styles.ArrivalPalletteWhite,
        upElevation: 5,
        downElevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Column(
          children: [
            Container(
              height: 150,
              child: Stack(
                children: [
                  Semantics(
                    label: 'Logo for ${widget.sale.name}',
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: widget.sale.card_image(),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Text(
                      'PROMOTION',
                      style: Styles.saleCardType,
                    ),
                  ),
                ],
              ),
            ),
            _buildDetails(),
          ],
        ),
      ),
    );
  }
}

class RowSale extends RowCard {

  final List<Sale> sales;

  RowSale(
    @required this.sales,
  );

  @override
  Widget generate(Preferences prefs) {

    List<SaleCard> list_of_sales = List<SaleCard>();
    for (int i=0;i<sales.length;i++) {
      list_of_sales.add(SaleCard(prefs, sales[i]));
    }

    return Container(
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
