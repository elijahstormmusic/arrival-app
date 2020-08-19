// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import '../data/app_state.dart';
import '../data/partners.dart';
import '../styles.dart';
import '../widgets/search_bar.dart';
import '../widgets/partner_headline.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  String terms = '';

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() => terms = controller.text);
  }

  Widget _createSearchBox() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Styles.mainColor,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: SearchBar(
          controller: controller,
          focusNode: focusNode,
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<Business> places) {
    if (places.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'No locations match your search.',
            style: Styles.headlineDescription(CupertinoTheme.of(context)),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: BusinessHeadline(places[i]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AppState>(context, rebuildOnChange: true);

    return CupertinoTabView(
      builder: (context) {
        return SafeArea(
          bottom: false,
          child: Column(
            children: [
              _createSearchBox(),
              Expanded(
                child: _buildSearchResults(model.searchBusinesses(terms)),
              ),
            ],
          ),
        );
      },
    );
  }
}
