/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/search_bar.dart';
import '../data/socket.dart';
import '../data/arrival.dart';
import '../data/preferences.dart';
import '../styles.dart';
import '../data/app_state.dart';
import '../data/preferences.dart';
import '../data/cards/partners.dart';
import '../data/cards/articles.dart';
import '../data/cards/sales.dart';
import '../posts/post.dart';

class Search extends StatefulWidget {
  bool searchOpen = false;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final _textInputController = TextEditingController();
  final _focusNode = FocusNode();
  String searchTerms = '';

  @override
  void initState() {
    _textInputController.addListener(_onTextChanged);
    super.initState();
  }
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildSearchLines(List<Business> places) {
    if (places.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Try simplifiying your search.',
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
          child: Container(),
          // child: BusinessHeadline(places[i]),
        );
      },
    );
  }
  Widget _buildSearchResults(AppState model) {
    List<Post> posts = model.searchPosts(searchTerms);
    List<Business> businesses = model.searchBusinesses(searchTerms);
    return _buildSearchLines(businesses);
  }
  Widget _buildSearchBar() {
    return widget.searchOpen ? Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: SearchBar(
        controller: _textInputController,
        focusNode: _focusNode,
      ),
    ) : Container();
  }

  void _onTextChanged() {
    setState(() => searchTerms = _textInputController.text);
  }

  @override
  Widget build(BuildContext context) {
    var appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);

    return searchTerms==''
      ? _buildSearchBar()
      : Container(
        height: 400.0,
        decoration: BoxDecoration(
          color: Styles.ArrivalPalletteWhite,
        ),
        child: ListView(
          children: <Widget>[
            _buildSearchBar(),
            _buildSearchResults(appState),
          ],
        ),
      );
  }
}
