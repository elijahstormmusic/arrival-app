// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import '../data/app_state.dart';
import '../partners/partner.dart';
import '../styles.dart';
import '../widgets/partner_headline.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        final model = ScopedModel.of<AppState>(context, rebuildOnChange: true);

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('My Favorites'),
          ),
          child: Center(
            child: model.favoritePartners.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'You haven\'t added any favorite Partners to your group yet.',
                      style: Styles.headlineDescription(
                          CupertinoTheme.of(context)),
                    ),
                  )
                : ListView(
                    children: [
                      SizedBox(height: 24),
                      for (Partner biz in model.favoritePartners)
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
                          child: PartnerHeadline(biz),
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
