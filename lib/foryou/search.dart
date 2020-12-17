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
import '../styles.dart';
import '../data/app_state.dart';
import '../data/preferences.dart';
import '../partners/partner.dart';
import '../articles/article.dart';
import '../partners/sale.dart';
import '../posts/post.dart';
import '../users/profile.dart';

import 'search_results/search_results.dart';
import 'foryou.dart';

class Search extends StatefulWidget {
  _SearchState currentState;
  bool _alwaysOpen = false;

  Search();
  Search.alwaysOpen() {
    _alwaysOpen = true;
  }

  bool toggleSearch() {
    return _alwaysOpen ? true : currentState.toggleSearch();
  }
  void response(var data) => currentState.response(data);

  @override
  _SearchState createState() {
    if (_alwaysOpen) return _SearchState.startOpen();
    return _SearchState();
  }
}

class _SearchState extends State<Search> {

  _SearchState();
  _SearchState.startOpen() {
    _searchOpen = true;
    _alwaysOpen = true;
  }
  bool _alwaysOpen = false;

  final ScrollController _scrollController = ScrollController();
  final _textInputController = TextEditingController();
  final _focusNode = FocusNode();
  final _searchBoxHeight = 70.0;
  bool _searchOpen = false;
  String searchTerms = '';

  List<SearchResult> _searchResults = List<SearchResult>();

  @override
  void initState() {
    super.initState();
    socket.search.add(this);
    widget.currentState = this;
    _textInputController.addListener(_onTextChanged);
    if (!_searchOpen) _focusNode.requestFocus();
  }
  @override
  void dispose() {
    socket.search.removeLast();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  bool toggleSearch() {
    if (_alwaysOpen) return true;
    if (!mounted) return null;
    bool changeTo = !_searchOpen;
    setState(() => _searchOpen = changeTo);
    return changeTo;
  }

  bool _allowRequest = true, _requestFailed = false;
  bool _responseHeard, _forceFailCurrentState = false;
  int _timesFailedToHearResponse = 0;
  String _lastQuery;
  void _checkForFailure() async {
    _responseHeard = false;
    await Future.delayed(const Duration(seconds: 6));
    if (!_responseHeard) {
      _timesFailedToHearResponse++;
      if (_timesFailedToHearResponse>3) {
        setState(() => _forceFailCurrentState = true);
        return;
      }
      _checkForFailure();
    }
  }
  @override
  void response(var data) async {
    _responseHeard = true;
    _timesFailedToHearResponse = 0;
    if (data==null) {
      _requestFailed = true;
      _allowRequest = true;
      return;
    }

    List<SearchResult> list = List<SearchResult>();
    var card, result;

    try {
      for (var i=0;i<data.length;i++) {
        if (data[i]['type']==DataType.partner) { // partner_data
          try {
            result = Partner.json(data[i]);
            card = SearchResultPartner(result);
            // ArrivalData.innocentAdd(ArrivalData.partners, result);
          } catch (e) {
            print(e);
            continue;
          }
        }
        else if (data[i]['type']==DataType.article) { // article_data
          try {
            result = Article.json(data[i]);
            card = SearchResultArticle(result);
            // ArrivalData.innocentAdd(ArrivalData.articles, result);
          } catch (e) {
            print(e);
            continue;
          }
        }
        else if (data[i]['type']==DataType.post) { // post_data
          try {
            result = Post.json(data[i]);
            card = SearchResultPost(result.cryptlink);
            // ArrivalData.innocentAdd(ArrivalData.posts, result);
          } catch (e) {
            continue;
          }
        }
        else if (data[i]['type']==DataType.sale) { // sale_data
          try {
            result = Sale.json(data[i]);
            card = SearchResultSale(result);
            // ArrivalData.innocentAdd(ArrivalData.sales, result);
          } catch (e) {
            continue;
          }
        }
        else if (data[i]['type']==DataType.profile) { // user_data
          try {
            result = Profile.json(data[i]);
            card = SearchResultProfile(result);
            // ArrivalData.innocentAdd(ArrivalData.profiles, result);
          } catch (e) {
            continue;
          }
        }
        else continue;

        list.add(card);
      }
    }
    catch (e) {
      _requestFailed = true;
      print(e);
      _allowRequest = true;
      return;
    }

    _requestFailed = false;
    setState(() => _searchResults = list);
    await Future.delayed(const Duration(seconds: 1));
    _allowRequest = true;
  }
  void _sendRequest(String input) {
    if (input=='' || input==_lastQuery) return;

    if (!_allowRequest) return;
    _allowRequest = false;
    socket.emit('search content', {
      'query': input,
      'limit': 10,
    });
    _lastQuery = input;
    _checkForFailure();
  }

  Widget _buildSearchLines(List<SearchResult> results) {
    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 50,
        ),
        child: Text(
          'Try simplifiying your search.',
          style: Styles.headlineDescription(CupertinoTheme.of(context)),
        ),
      );
    }

    return ListView.builder(
      physics: ClampingScrollPhysics(),
      itemCount: results.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: results[i].generate(context,
            MediaQuery.of(context).size.width - (24*2),
          ),
        );
      },
    );
  }
  Widget _buildSearchResults(AppState model) {
    return _buildSearchLines(_searchResults);
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

  DateTime _lastInputChange;
  void _onTextChanged() async {
    setState(() => searchTerms = _textInputController.text);

    const delayTime = 1000;
    _lastInputChange = DateTime.now();

    await Future.delayed(const Duration(milliseconds: delayTime));

    DateTime currentTime = DateTime.now();

    if (currentTime.difference(_lastInputChange).inMilliseconds < delayTime) {
      return;
    }

    _sendRequest(searchTerms);
  }

  @override
  Widget build(BuildContext context) {
    var appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);

    if (!_searchOpen) return Container();

    return Container(
      height: (_alwaysOpen && searchTerms=='') ? _searchBoxHeight : MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: searchTerms==''
          ? Styles.transparentColor
          : Styles.ArrivalPalletteWhite,
      ),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          _buildSearchBar(),

          Container(
            height: MediaQuery.of(context).size.height - _searchBoxHeight,
            child: searchTerms==''
              ? GestureDetector(
                onTap: toggleSearch,
                child: Container(
                  height: MediaQuery.of(context).size.height - _searchBoxHeight,
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
