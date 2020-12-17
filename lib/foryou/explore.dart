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
import '../data/link.dart';
import '../data/app_state.dart';
import '../data/preferences.dart';
import '../partners/partner.dart';
import '../articles/article.dart';
import '../partners/sale.dart';
import '../posts/post.dart';
import '../users/profile.dart';

import '../styles.dart';
import 'search.dart';

class Explore extends StatefulWidget {
  _ExploreState currentState;
  final String type;

  Explore({this.type = null});

  void response(var data) => currentState.response(data);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

  final ScrollController _scrollController = ScrollController();
  final _textInputController = TextEditingController();
  String searchTerms = '';
  int REQUEST_AMOUNT = 10;
  final _scrollTargetDistanceFromBottom = 400.0;
  Search _search;

  List<Map<String, dynamic>> _exploreResults = List<Map<String, dynamic>>();

  @override
  void initState() {
    super.initState();
    socket.delivery.add(this);
    _scrollController.addListener(_scrollListener);
    widget.currentState = this;
    _textInputController.addListener(_onTextChanged);
    _search = Search.alwaysOpen();
    _askExplore(REQUEST_AMOUNT);
  }
  @override
  void dispose() {
    socket.delivery.removeWhere((x) => x==this);
    _scrollController.dispose();
    super.dispose();
  }
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
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
  void response(var data) async {
    _responseHeard = true;
    _timesFailedToHearResponse = 0;
    if (data==null) {
      _requestFailed = true;
      _allowRequest = true;
      return;
    }

    List<Map<String, dynamic>> list = List<Map<String, dynamic>>();
    var result, card;

    try {
      for (var i=0;i<data.length;i++) {
        if (data[i]['type']==DataType.partner) {
          try {
            result = Partner.json(data[i]);
            ArrivalData.innocentAdd(ArrivalData.partners, result);
            card = {
              'type': DataType.partner,
              'content': result,
              'link': result.images.logo,
              'color': Styles.ArrivalPalletteBlue,
            };
          } catch (e) {
            continue;
          }
        }
        else if (data[i]['type']==DataType.article) {
          try {
            result = Article.json(data[i]);
            ArrivalData.innocentAdd(ArrivalData.articles, result);
            card = {
              'type': DataType.article,
              'content': result,
              'link': result.image_link(0),
              'color': Styles.ArrivalPalletteBlue,
            };
          } catch (e) {
            continue;
          }
        }
        else if (data[i]['type']==DataType.post) {
          try {
            result = Post.json(data[i]);
            ArrivalData.innocentAdd(ArrivalData.posts, result);
            card = {
              'type': DataType.post,
              'content': result,
              'link': result.media_href(),
              'color': Styles.ArrivalPalletteBlue,
            };
          } catch (e) {
            continue;
          }
        }
        else if (data[i]['type']==DataType.sale) {
          continue;
          try {
            var _sale_list = data[i]['list'];
            List<Sale> result_list = List<Sale>();
            for (int _sale=0;_sale<_sale_list.length;_sale++) {
              try {
                result = Sale.json(_sale_list[_sale]);
                ArrivalData.innocentAdd(result_list, result);
                ArrivalData.innocentAdd(ArrivalData.sales, result);
              }
              catch (e) {
                continue;
              }
            }
            card = {
              'type': DataType.sale,
              'link': 2,
            };
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
    setState(() => _exploreResults += list);
    await Future.delayed(const Duration(seconds: 1));
    _allowRequest = true;
  }
  void _sendSearchRequest(String input) {
    if (input=='' || input==_lastQuery) return;

    if (!_allowRequest) return;
    _allowRequest = false;
    socket.emit('search content', {
      'query': input,
      'limit': REQUEST_AMOUNT,
    });
    _lastQuery = input;
    _checkForFailure();
  }
  void _askExplore(int amount) {
    if (!_allowRequest) return;
    _allowRequest = false;
    socket.emit('foryou ask', {
      'amount': amount,
      'type': widget.type,
    });
    _checkForFailure();
  }


  void _longPressContent(Map<String, dynamic> data) {
    print('long press ${data['link']}');
  }
  void _longPressEndContent(Map<String, dynamic> data) {
    print('long press end ${data['link']}');
  }
  void _openOnTapContent(Map<String, dynamic> data) {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => data['content'].navigateTo(),
      fullscreenDialog: true,
    ));
  }

  Widget _buildExploreBoxContent(double w, double h, Map<String, dynamic> data) {
    return GestureDetector(
      onLongPressStart: (_) => _longPressContent(data),
      onLongPressEnd: (_) => _longPressEndContent(data),
      onTap: () => _openOnTapContent(data),
      child: Container(
        width: w,
        height: h,
        color: data['color'],
        child: Center(
          child: Image.network(
            data['link'],
            width: w,
            height: h,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
  Widget _buildExploreWrapRow(double _size, double _spacing, List<Map<String, dynamic>> data) {
    List<Widget> list = List<Widget>();

    for (int i=0;i<3;i++) {
      list.add(
        _buildExploreBoxContent(_size, _size, data[i])
      );
    }

    return Container(
      height: _size + _spacing,
      child: Wrap(
        spacing: _spacing,
        runSpacing: _spacing,
        direction: Axis.vertical,
        children: list,
      ),
    );
  }
  Widget _buildExploreWrapTall(double _size, double _spacing, List<Map<String, dynamic>> data) {
    List<Widget> list = List<Widget>();

    for (int i=0;i<4;i++) {
      list.add(
        _buildExploreBoxContent(_size, _size, data[i])
      );
    }

    list.add(
      _buildExploreBoxContent(_size, 2 * _size + _spacing, data[4])
    );

    return Container(
      height: (_size + _spacing) * 2,
      child: Wrap(
        spacing: _spacing,
        runSpacing: _spacing,
        direction: Axis.vertical,
        children: list,
      ),
    );
  }
  Widget _buildExploreWrapLarge(double _size, double _spacing, List<Map<String, dynamic>> data) {
    List<Widget> list = List<Widget>();

    list.add(
      _buildExploreBoxContent(2 * _size + _spacing, 2 * _size + _spacing, data[0])
    );

    for (int i=1;i<3;i++) {
      list.add(
        _buildExploreBoxContent(_size, _size, data[i])
      );
    }

    return Container(
      height: (_size + _spacing) * 2,
      child: Wrap(
        spacing: _spacing,
        runSpacing: _spacing,
        direction: Axis.vertical,
        children: list,
      ),
    );
  }
  Widget _buildExploreWrapFromType(double _size, double _spacing, Map<String, dynamic> data) {
    if (data['type']==1)
      return _buildExploreWrapTall(_size, _spacing, data['list']);
    if (data['type']==2)
      return _buildExploreWrapLarge(_size, _spacing, data['list']);
    return _buildExploreWrapRow(_size, _spacing, data['list']);
  }

  Widget _buildExploreBoxes(AppState model) {
    if (_exploreResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Styles.ArrivalBucketLoading,
        ),
      );
    }

    List<Widget> _drawList = List<Widget>();
    List<Map<String, dynamic>> _dataGroup = List<Map<String, dynamic>>();

    int cycle = 6;

    for (int i=0,counter=0;i+3<_exploreResults.length;counter++) {

      if (counter % cycle == 0) {
        if (i+5<_exploreResults.length) {
          _dataGroup.add({
            'type': 1,
            'list': [_exploreResults[i], _exploreResults[i + 1], _exploreResults[i + 2], _exploreResults[i + 3], _exploreResults[i + 4]],
          });
          i += 5;
          continue;
        }
        break;
      }

      if (counter % cycle == 3) {
        _dataGroup.add({
          'type': 2,
          'list': [_exploreResults[i], _exploreResults[i + 1], _exploreResults[i + 2]],
        });
        i += 3;
        continue;
      }

      _dataGroup.add({
        'type': 0,
        'list': [_exploreResults[i], _exploreResults[i + 1], _exploreResults[i + 2]],
      });
      i += 3;
    }

    double _spacing = 4.0;
    double _squareSize = (MediaQuery.of(context).size.width - _spacing * 2) / 3;

    for (int i=0;i<_dataGroup.length;i++) {
      _drawList.add(
        _buildExploreWrapFromType(_squareSize, _spacing, _dataGroup[i])
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      child: Wrap(
        spacing: 0.0,
        runSpacing: 0.0,
        children: _drawList,
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.offset + _scrollTargetDistanceFromBottom
        >= _scrollController.position.maxScrollExtent) {
      _askExplore(REQUEST_AMOUNT);
    }
  }
  void _onEndScroll(ScrollMetrics metrics) {
  }
  void _onStartScroll(ScrollMetrics metrics) {
  }
  void scrollToTop() {
    try {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
    catch (e) {
    }
  }
  void refresh_state() => setState(() => 0);

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: SearchBar(
        controller: _textInputController,
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

    _sendSearchRequest(searchTerms);
  }

  @override
  Widget build(BuildContext context) {
    var appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 70.0,
                margin: EdgeInsets.only(top: 70.0),
                child: _buildExploreBoxes(appState),
              ),

              _search,
            ],
          ),
        ),
      ),
    );
  }
}
