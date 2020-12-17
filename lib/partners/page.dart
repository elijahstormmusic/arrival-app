/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import '../foryou/cards/sale_card.dart';
import '../data/preferences.dart';
import '../partners/partner.dart';
import '../partners/industries.dart';
import '../data/link.dart';
import '../data/socket.dart';
import '../data/arrival.dart';
import '../styles.dart';
import '../widgets/close_button.dart';
import '../widgets/cards.dart';
import '../maps/maps.dart';
import '../users/data.dart';


class SellerView extends StatelessWidget {
  final biz;
  int _alreadyRequested = 0;

  SellerView(this.biz);

  @override
  Widget build(BuildContext context) {
    final prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
    final themeData = CupertinoTheme.of(context);

    if (biz.sales.length==0) {
      socket.emit('partners request sales', {
        'link': biz.cryptlink,
        'amount': 10,
        'skip': _alreadyRequested,
      });

      return Padding(
        padding: EdgeInsets.all(64),
        child: Column(
          children: [
            Text(
              'Sales and in-app Purchases will come with the full release! Expect to find them here!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Styles.ArrivalPalletteBlack,
              ),
            ),
            Container(
              height: 100,
              child: Image.asset('assets/loading/Bucket-1s-200px.gif'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: RowSale(biz.sales).generate(prefs),
    );
  }
}

class InfoView extends StatelessWidget {
  final biz;

  const InfoView(this.biz);

  void _rateAtIndex(var prefs, int index) async {
    socket.emit('partners set rating', {
      'link': biz.cryptlink,
      'user': UserData.client.cryptlink,
      'rating': index,
    });

    prefs.ratePartner(biz.cryptlink, index);
  }

  Widget _drawRatingRow(var prefs, int rating, List<Color> colors, bool hasNotBeenRatedBefore) {
    return Row(
      children: [
        for (int i=1;i<6;i++) ...[
          SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              _rateAtIndex(prefs, i + 1);
              if (hasNotBeenRatedBefore) {
                biz.ratingAmount++;
              }
            },
            child: Icon(
              Styles.ratingIconData[i<rating ? 1 : (i-1<rating && rating%1>0.5 ? 2 : 0)],
              semanticLabel: rating.toString(),
              color: Styles.ratingColors[i<rating ? 1 : (i-1<rating && rating%1>0.5 ? 2 : 0)],
            ),
          ),
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
    final themeData = CupertinoTheme.of(context);

    const double _internalSpacing = 16;
    const double _generalPadding = 24;
    const double _reduceIconForWidth = .5;
    final double _flexableThirdWidth = (MediaQuery.of(context).size.width - 112) / 3;


    final List<Widget> _contactList = <Widget>[];

    if (biz.contact.website != null) {
      _contactList.add(GestureDetector(
        child: Container(
          decoration: Styles.backgroundRadiusGradient(6),
          width: _flexableThirdWidth,
          height: _flexableThirdWidth * 2 + _internalSpacing,
          child: Icon(
            Icons.open_in_browser,
            size: _flexableThirdWidth * _reduceIconForWidth,
            color: Styles.ArrivalPalletteWhite,
          ),
        ),
        onTap: () {
          if (biz.contact.website.substring(0, 4) == 'http')
            launch(biz.contact.website);
          else launch('http://${biz.contact.website}');
        },
      ));
    }
    if (biz.contact.email != null) {
      _contactList.add(GestureDetector(
        child: Container(
          decoration: Styles.backgroundRadiusGradient(6),
          width: _flexableThirdWidth,
          height: _flexableThirdWidth,
          child: Icon(
            Icons.email,
            size: _flexableThirdWidth * _reduceIconForWidth,
            color: Styles.ArrivalPalletteWhite,
          ),
        ),
        onTap: () {
          launch('mailto:${biz.contact.email}');
        },
      ));
    }
    if (biz.contact.facebook != null) {
      _contactList.add(GestureDetector(
        child: Container(
          decoration: Styles.backgroundRadiusGradient(6),
          width: _flexableThirdWidth,
          height: _flexableThirdWidth,
          padding: EdgeInsets.all(_flexableThirdWidth / 4),
          child: //Icon(
            Styles.facebookIcon,
          //   size: _flexableThirdWidth * _reduceIconForWidth,
          //   color: Styles.ArrivalPalletteWhite,
          // ),
        ),
        onTap: () {
          launch('http://facebook.com/${biz.contact.facebook}');
        },
      ));
    }
    if (biz.contact.twitter != null) {
      _contactList.add(GestureDetector(
        child: Container(
          decoration: Styles.backgroundRadiusGradient(6),
          width: _flexableThirdWidth,
          height: _flexableThirdWidth,
          padding: EdgeInsets.all(_flexableThirdWidth / 4),
          child: //Icon(
            Styles.twitterIcon,
          //   size: _flexableThirdWidth * _reduceIconForWidth,
          //   color: Styles.ArrivalPalletteWhite,
          // ),
        ),
        onTap: () {
          launch('http://twitter.com/${biz.contact.twitter}');
        },
      ));
    }
    if (biz.contact.instagram != null) {
      _contactList.add(GestureDetector(
        child: Container(
          decoration: Styles.backgroundRadiusGradient(6),
          width: _flexableThirdWidth,
          height: _flexableThirdWidth,
          padding: EdgeInsets.all(_flexableThirdWidth / 4),
          child: //Icon(
            Styles.instagramIcon,
          //   size: _flexableThirdWidth * _reduceIconForWidth,
          //   color: Styles.ArrivalPalletteWhite,
          // ),
        ),
        onTap: () {
          launch('http://instagram.com/${biz.contact.instagram}');
        },
      ));
    }
    if (biz.contact.pinterest != null) {
      _contactList.add(GestureDetector(
        child: Container(
          decoration: Styles.backgroundRadiusGradient(6),
          width: _flexableThirdWidth,
          height: _flexableThirdWidth,
          padding: EdgeInsets.all(_flexableThirdWidth / 4),
          child: //Icon(
            Styles.pinterestIcon,
          //   size: _flexableThirdWidth * _reduceIconForWidth,
          //   color: Styles.ArrivalPalletteWhite,
          // ),
        ),
        onTap: () {
          launch('http://pinterest.com//${biz.contact.pinterest}');
        },
      ));
    }
    if (biz.contact.phoneNumber != null) {
      _contactList.add(GestureDetector(
        child: Container(
          decoration: Styles.backgroundRadiusGradient(6),
          width: _flexableThirdWidth,
          height: _flexableThirdWidth * 2 + _internalSpacing,
          child: Icon(
            Icons.call,
            size: _flexableThirdWidth * _reduceIconForWidth,
            color: Styles.ArrivalPalletteWhite,
          ),
        ),
        onTap: () {
          launch('tel://${biz.contact.phoneNumber}');
        },
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(_generalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FutureBuilder<Set<SourceIndustry>>(
                future: prefs.preferredIndustries,
                builder: (context, snapshot) {
                  return Text(
                    LocalIndustries.industryGrabber(biz.industry).name.toUpperCase(),
                    style: (snapshot.hasData &&
                        snapshot.data.contains(biz.industry))
                        ? Styles.detailsPreferredCategoryText(themeData)
                        : Styles.detailsCategoryText(themeData),
                  );
                },
              ),
              Spacer(),

              FutureBuilder<int>(
                future: prefs.hasBeenRated(biz.cryptlink),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) =>
                snapshot.hasData && snapshot.data != -1 ?
                  _drawRatingRow(prefs, snapshot.data, Styles.ratingColors, snapshot.data == -1)
                  : _drawRatingRow(prefs, biz.rating.toInt(), Styles.unratedRatingColors, snapshot.data == -1),
              ),

              Spacer(),
              Text(
                ' (' + biz.ratingAmount.toString() + ')',
                style: Styles.detailsDescriptionText(themeData),
              ),
            ],
          ),

          SizedBox(height: _generalPadding),
          Text(
            biz.shortDescription,
            style: Styles.detailsDescriptionText(themeData),
          ),

          SizedBox(height: _generalPadding),
          Center(
            child: GestureDetector(
              child: Container(
                decoration: Styles.backgroundRadiusGradient(10),
                padding: EdgeInsets.all(20),
                width: 250,
                child: Text(
                  'TAKE ME HERE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Styles.ArrivalPalletteWhite,
                  ),
                ),
              ),
              onTap: () {
                Arrival.navigator.currentState.push(MaterialPageRoute(
                  builder: (context) => Maps.directions(biz),
                  fullscreenDialog: true,
                ));
              },
            ),
          ),
          Center(
              child: Text(
              biz.contact.address + ', ' + biz.contact.zip,
              textAlign: TextAlign.center,
              style: Styles.detailsAddressText,
            ),
          ),

          SizedBox(height: _generalPadding * 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Contact US ❤️',
                style: Styles.cardTitleText,
              ),
              SizedBox(height: _generalPadding / 2),

              Container(
                padding: EdgeInsets.all(16),
                height: _contactList.length <= 3 ? (_flexableThirdWidth * 2 + (_internalSpacing * 1)) : (_flexableThirdWidth * 4 + (_internalSpacing * 3)),
                width: _flexableThirdWidth * 3 + (_internalSpacing * 2),
                child: Wrap(
                  spacing: _internalSpacing,
                  runSpacing: _internalSpacing,
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  alignment: WrapAlignment.start,
                  children: _contactList,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PartnerDisplayPage extends StatefulWidget {
  final String cryptlink;

  PartnerDisplayPage(this.cryptlink);

  @override
  _PartnerDisplayPageState createState() => _PartnerDisplayPageState();
}

class _PartnerDisplayPageState extends State<PartnerDisplayPage> {
  int _selectedViewIndex = 0;
  final double _headerHeight = 350.0;

  Widget _buildHeader(BuildContext context) {
    final biz = ArrivalData.getPartner(widget.cryptlink);

    return SizedBox(
      height: _headerHeight,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            child: Image.network(
              biz.images.logo,
              fit: BoxFit.cover,
              semanticLabel: 'A background image of ',
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: ArrCloseButton(() {
                Navigator.of(context).pop();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentDisplay(var prefs, var biz) => Column(
    children: [
      Container(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: GestureDetector(
                onTap: () async {
                  await prefs.toggleBookmarked(DataType.partner, biz.cryptlink);
                  setState(() => 0);
                },
                child: FutureBuilder<bool>(
                  future: prefs.isBookmarked(DataType.partner, biz.cryptlink),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
                  snapshot.hasData ?
                    (snapshot.data ? Styles.bookmark_filled : Styles.bookmark_icon)
                    : Styles.bookmark_icon,
                ),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width - 100,
              child: Text(
                biz.name,
                style: Styles.PartnerNameText,
              ),
            ),
          ],
        ),
      ),

      InfoView(biz),
      SellerView(biz),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final biz = ArrivalData.getPartner(widget.cryptlink);
    var prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);

    return Scaffold(
      body: Stack(
        children: [

          _buildHeader(context),

          SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 60),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      color: Styles.transparentColor,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Styles.ArrivalPalletteWhite,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: _contentDisplay(prefs, biz),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
