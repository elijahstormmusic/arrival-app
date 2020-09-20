/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/preferences.dart';
import '../data/cards/articles.dart';
import '../styles.dart';
import '../widgets/close_button.dart';
import '../widgets/cards.dart';
import '../maps/maps.dart';

class ArticleDisplayPage extends StatefulWidget {
  final Article article;

  ArticleDisplayPage(this.article);

  @override
  _ArticleDisplayPageState createState() => _ArticleDisplayPageState();
}

class _ArticleDisplayPageState extends State<ArticleDisplayPage> {
  int _selectedViewIndex = 0;

  Widget _buildHeader(BuildContext context, AppState model) {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            child: Image.network(
              widget.article.image_link(0),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
