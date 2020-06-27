// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import 'package:arrival_kc/data/app_state.dart';
import 'package:arrival_kc/data/preferences.dart';
import 'package:arrival_kc/data/partners.dart';
import 'package:arrival_kc/data/local_saved_businesses.dart';
import 'package:arrival_kc/styles.dart';
import 'package:arrival_kc/widgets/close_button.dart';
import 'package:arrival_kc/widgets/cards.dart';
import 'package:arrival_kc/maps/maps.dart';

class BuyingCards extends StatelessWidget {
  const BuyingCards(this.biz, this.prefs);

  final Business biz;
  final Preferences prefs;

  @override
  Widget build(BuildContext context) {
    return FrostyBackground(
      color: Color(0x90ffffff),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'biz.name',
              style: Styles.cardTitleText,
            ),
            Text(
              'biz.shortDescription',
              style: Styles.cardDescriptionText,
            ),
          ],
        ),
      ),
    );
  }
}

class SellerView extends StatelessWidget {
  final int id;

  const SellerView(this.id);

  @override
  Widget build(BuildContext context) {
    final appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    final prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
    final biz = appState.getBusiness(id);
    final themeData = CupertinoTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 8),
          Text(
            biz.name,
            style: Styles.detailsTitleText(themeData),
          ),
          SizedBox(height: 8),
          Text(
            'here is where we would put items the user can buy with the app at a discount',
            style: Styles.detailsDescriptionText(themeData),
          ),
          // BuyingCards(biz, prefs),
          SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoSwitch(
                value: biz.isFavorite,
                onChanged: (value) {
                  appState.setFavorite(id, value);
                },
              ),
              SizedBox(width: 8),
              Text(
                'Save to Favorites',
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoView extends StatelessWidget {
  final int id;

  const InfoView(this.id);

  @override
  Widget build(BuildContext context) {
    final appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    final prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
    final biz = appState.getBusiness(id);
    final themeData = CupertinoTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 8),
          Text(
            biz.name,
            style: Styles.detailsTitleText(themeData),
          ),
          SizedBox(height: 8),
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
              for (var i=1;i<6;i++) ...[
                SizedBox(width: 12),
                Icon(
                    Styles.ratingIconData[i<biz.rating ? 1 : (i-1<biz.rating && biz.rating%1>0.5 ? 2 : 0)],
                    semanticLabel: biz.rating.toString(),
                    color: Styles.ratingColors[i<biz.rating ? 1 : (i-1<biz.rating && biz.rating%1>0.5 ? 2 : 0)],
                  ),
              ],
              Spacer(),
              Text(
                ' (' + biz.ratingAmount.toString() + ')',
                style: Styles.detailsDescriptionText(themeData),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            biz.shortDescription,
            style: Styles.detailsDescriptionText(themeData),
          ),
          SizedBox(height: 24),
          GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  biz.contact.address + ', ' + biz.contact.zip,
                  style: Styles.detailsAddressText,
                ),
                Text(
                  'take me here'.toUpperCase(),
                  style: Styles.detailsBigLinkText,
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push<void>(CupertinoPageRoute(
                builder: (context) => Maps.directions(biz.name),
                fullscreenDialog: true,
              ));
            },
          ),
          SizedBox(height: 24),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: FrostyBackground(
                color: Styles.frostedBackground,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Contact Links',
                        style: Styles.cardTitleText,
                      ),
                      SizedBox(height: 18),
                      GestureDetector(
                        child: Text(
                          biz.contact.phoneNumber,
                          style: Styles.detailsLinkText,
                        ),
                        onTap: () {
                          launch('tel://' + biz.contact.phoneNumber);
                        },
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        child: Text(
                          'Go to Website',
                          style: Styles.detailsLinkText,
                        ),
                        onTap: () {
                          launch(biz.contact.website);
                        },
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoSwitch(
                value: biz.isFavorite,
                onChanged: (value) {
                appState.setFavorite(id, value);
                },
              ),
              SizedBox(width: 8),
              Text(
                'Save to Favorites',
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  final int id;

  DetailsScreen(this.id);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int _selectedViewIndex = 0;

  Widget _buildHeader(BuildContext context, AppState model) {
    final biz = model.getBusiness(widget.id);

    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            child: Image.asset(
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

  @override
  Widget build(BuildContext context) {
    final appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);

    return CupertinoPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildHeader(context, appState),
                SizedBox(height: 20),
                CupertinoSegmentedControl<int>(
                  children: {
                    0: Text('Sales'),
                    1: Text('Contact Info'),
                  },
                  groupValue: _selectedViewIndex,
                  onValueChanged: (value) {
                    setState(() => _selectedViewIndex = value);
                  },
                ),
                _selectedViewIndex == 0
                    ? SellerView(widget.id)
                    : InfoView(widget.id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
