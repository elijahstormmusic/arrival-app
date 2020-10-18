/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/search_bar.dart';
import '../widgets/partner_headline.dart';
import '../data/socket.dart';
import '../data/arrival.dart';
import '../data/preferences.dart';
import '../styles.dart';
import '../data/app_state.dart';
import '../data/preferences.dart';
import '../partners/partner.dart';
import '../articles/article.dart';
import '../partners/sale.dart';
import '../posts/post.dart';
import 'foryou.dart';

class Search extends StatefulWidget {
  _SearchState currentState;

  void toggleSearch() => currentState.toggleSearch();

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final ScrollController _scrollController = ScrollController();
  final _textInputController = TextEditingController();
  final _focusNode = FocusNode();
  bool _searchOpen = false;
  String searchTerms = '';

  @override
  void initState() {
    widget.currentState = this;
    _textInputController.addListener(_onTextChanged);
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void toggleSearch() {
    try {
      if (_searchOpen) ForYouPage.showUploadButton();
      else ForYouPage.hideUploadButton();
    } //  typically breaks if not on ForYouPage
    catch (e) {}
    setState(() => _searchOpen = !_searchOpen);
  }

  Widget _buildSearchLines(List<Partner> places) {
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
          child: PartnerHeadline(places[i]),
        );
      },
    );
  }
  Widget _buildSearchResults(AppState model) {
    List<Post> posts = model.searchPosts(searchTerms);
    List<Partner> Partners = model.searchPartners(searchTerms);
    return _buildSearchLines(Partners);
  }
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: SearchBar(
        controller: _textInputController,
        focusNode: _focusNode,
      ),
    );
  }

  void _onTextChanged() {
    setState(() => searchTerms = _textInputController.text);
  }

  @override
  Widget build(BuildContext context) {
    var appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);

    if (!_searchOpen) return Container();

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: searchTerms==''
          ? Styles.transparentColor
          : Styles.ArrivalPalletteWhite,
      ),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          _buildSearchBar(),
          Container(
            height: MediaQuery.of(context).size.height - 100.0,
            child: searchTerms==''
              ? GestureDetector(
                onTap: toggleSearch,
                child: Container(
                  height: MediaQuery.of(context).size.height - 100.0,
                  decoration: BoxDecoration(
                    color: Styles.transparentColor,
                  ),
                ),
              )
              : _buildSearchResults(appState),
          ),
        ],
      ),
    );
  }
}
