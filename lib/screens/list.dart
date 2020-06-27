// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:arrival_kc/data/app_state.dart';
import 'package:arrival_kc/data/preferences.dart';
import 'package:arrival_kc/data/partners.dart';
import 'package:arrival_kc/styles.dart';
import 'package:arrival_kc/widgets/partner_card.dart';

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
                    child: Text('A fun trip',
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
