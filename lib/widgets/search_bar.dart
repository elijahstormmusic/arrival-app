// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../styles.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  SearchBar({
    @required this.controller,
    @required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = CupertinoTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Styles.ArrivalPalletteWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Styles.ArrivalPalletteGrey,
            spreadRadius: 4,
            blurRadius: 6,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        child: Row(
          children: [
            ExcludeSemantics(
              child: Icon(
                CupertinoIcons.search,
                color: Styles.searchIconColor,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: CupertinoTextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: null,
                  style: Styles.searchText(themeData),
                  cursorColor: Styles.searchCursorColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.clear();
              },
              child: Icon(
                CupertinoIcons.clear_thick_circled,
                semanticLabel: 'Clear search terms',
                color: Styles.searchIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
