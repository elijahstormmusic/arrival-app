// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:adobe_xd/pinned.dart';
import '../data/app_state.dart';
import '../data/preferences.dart';
import '../data/partners.dart';
import '../styles.dart';
import '../widgets/partner_card.dart';
// import '../widgets/news_card.dart';
import '../widgets/profile_stats_card.dart';

class ListScreen extends StatelessWidget {
  Widget _generateBusinessRow(Business biz, Preferences prefs,
      {bool isNear = true}) {
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

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        final appState =
            ScopedModel.of<AppState>(context, rebuildOnChange: true);
        final prefs =
            ScopedModel.of<Preferences>(context, rebuildOnChange: true);
        final themeData = CupertinoTheme.of(context);
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: ArrivalTitle(),
            backgroundColor: Styles.mainColor,
          ),
          child: SafeArea(
            bottom: false,
            child: ListView.builder(
              itemCount: appState.allBusinesses.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 265.0,
                          child: Pinned.fromSize(
                            bounds: Rect.fromLTWH(18.0, 26.0, 387.0, 205.0),
                            size: Size(412.0, 1600.0),
                            pinLeft: true,
                            pinRight: true,
                            pinTop: true,
                            fixedHeight: true,
                            child: UserProfilePlacard(),
                          ),
                        ),
                        Text('Near you',
                            style: Styles.headlineText(themeData)),
                      ],
                    ),
                  );
                } else if (index <= appState.availableBusinesses.length) {
                  return _generateBusinessRow(
                    appState.availableBusinesses[index - 1],
                    prefs,
                  );
                } else if (index <= appState.availableBusinesses.length + 1) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Text(appState.unavailableBusinesses.length==0 ? '' :
                                'A fun trip',
                        style: Styles.headlineText(themeData)),
                  );
                } else {
                  var relativeIndex =
                      index - (appState.availableBusinesses.length + 2);
                  return _generateBusinessRow(
                      appState.unavailableBusinesses[relativeIndex], prefs,
                      isNear: false);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
