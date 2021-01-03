/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../data/preferences.dart';
import '../data/socket.dart';
import '../data/link.dart';
import '../data/socket.dart';
import '../data/arrival.dart';
import '../widgets/close_button.dart';
import '../widgets/cards.dart';
import '../styles.dart';

import 'article.dart';
import 'page.dart';
import 'categories.dart';


class ArticleCategoryDisplay extends StatefulWidget {
  final String index;

  ArticleCategoryDisplay(this.index);

  @override
  _ACDState createState() => _ACDState();
}

class _ACDState extends State<ArticleCategoryDisplay> {
  final double _headerHeight = 300.0;
  final double _internalSpacing = 16.0;
  final double _generalPadding = 24.0;
  final double _reduceIconForWidth = .5;
  List<Article> _articleList;
  Category _category;

  ScrollController _scrollController;
  bool _allowRequest = true, _requestFailed = false;
  final REQUEST_AMOUNT = 10;
  final _scrollTargetDistanceFromBottom = 400.0;
  bool kill_reflow = false;


  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    int index = int.parse(widget.index);
    if (index >= ArticleData.all.length) index = 0;
    _category = ArticleData.all[index];

    socket.delivery.add(this);

    if (ArrivalData.articles.length<=5) {
      _pullNext(REQUEST_AMOUNT);
    }

    _convertDataToList();
  }
  @override
  void dispose() {
    kill_reflow = true;
    socket.delivery.removeWhere((x) => x==this);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset + _scrollTargetDistanceFromBottom
        >= _scrollController.position.maxScrollExtent) {
      _pullNext(REQUEST_AMOUNT);
    }
  }

  SnackBar _snackBar;
  void openSnackBar(Map<String, dynamic> input) {
    try {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(input['text']),
        backgroundColor: Styles.ArrivalPalletteRed,
        elevation: 15.0,
        behavior: SnackBarBehavior.floating,
        duration: input['duration']==null ? Duration(seconds: 3) : Duration(seconds: input['duration']),
        action: input['action']==null ? null : SnackBarAction(
          textColor: Styles.ArrivalPalletteBlue,
          disabledTextColor: Styles.ArrivalPalletteGrey,
          label: input['action-label'],
          onPressed: input['action'],
        ),
      ));
    } catch (e) {

    }
  }


  void _pullNext(int amount) {
    if (!_allowRequest) return;
    _allowRequest = false;
    socket.emit('foryou ask', {
      'amount': amount,
      'type': 'articles',
    });
    _checkForFailure();
  }
  bool _responseHeard, _forceFailCurrentState = false;
  int _timesFailedToHearResponse = 0;
  void _checkForFailure() async {
    _responseHeard = false;
    await Future.delayed(const Duration(seconds: 6));
    if (!_responseHeard) {
      _timesFailedToHearResponse++;
      if (_timesFailedToHearResponse>3) {
        if (kill_reflow) return;
        openSnackBar({
          'text': 'Network error. A-400',
        });
        setState(() => _forceFailCurrentState = true);
        return;
      }
      _checkForFailure();
    }
  }
  void _loadMore() {
    if (!_allowRequest) return;
    _pullNext(REQUEST_AMOUNT);
  }
  void response(var data) async {
    _responseHeard = true;
    _timesFailedToHearResponse = 0;
    if (data.length==0) {
      _requestFailed = true;
      return;
    }

    try {
      for (var i=0;i<data.length;i++) {
        if (data[i]['type']!=DataType.article) continue;
        try {
          ArrivalData.innocentAdd(ArrivalData.articles, Article.json(data[i]));
        } catch (e) {
          continue;
        }
      }
    }
    catch (e) {
      _requestFailed = true;
      print(e);
      return;
    }

    _requestFailed = false;
    if (kill_reflow) return;
    setState(() => _convertDataToList());
    ArrivalData.save();
    await Future.delayed(const Duration(seconds: 1));
    _allowRequest = true;
  }
  void _convertDataToList() {
    _articleList = <Article>[];

    Article article;
    for (int i=0;i<ArrivalData.articles.length;i++) {
      article = ArrivalData.articles[i];
      if (article.category != _category.type) continue;
      _articleList.add(article);
    }

    // _articleList = _articleList.reversed.toList();
  }


  Widget _buildHeader(Category category) => SizedBox(
    height: _headerHeight,
    child: Stack(
      children: [
        Positioned(
          right: 0,
          left: 0,
          child: Image.network(
            category.image,
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

  Widget _createDrawableCard(Article article, double width) => Container(
    width: width,
    padding: EdgeInsets.only(left: 16, right: 16),
    child: PressableCard(
      onPressed: () {
        Arrival.navigator.currentState.push(MaterialPageRoute(
          builder: (context) => ArticleDisplayPage(
            article.cryptlink,
          ),
          fullscreenDialog: true,
        ));
      },
      color: Styles.ArrivalPalletteWhite,
      upElevation: 5,
      downElevation: 1,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Column(
        children: [
          Container(
            height: 140,
            child: Semantics(
              label: 'Logo for ${article.title}',
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: article.headline_image(),
                  ),
                ),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              article.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _contentDisplay(var prefs, Category category) {
    final double _flexableHalfWidth = (MediaQuery.of(context).size.width - 78.0) / 2.0;

    List<Widget> drawerDisplay = <Widget>[];
    Article article;
    for (int i=0;i<_articleList.length;i++) {
      article = _articleList[i];

      drawerDisplay.add(_createDrawableCard(article, _flexableHalfWidth));
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: GestureDetector(
                  onTap: () async {
                    await prefs.toggleBookmarked(DataType.categories, category.type.index.toString());
                    setState(() => 0);
                  },
                  child: FutureBuilder<bool>(
                    future: prefs.isBookmarked(DataType.categories, category.type.index.toString()),
                    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
                    Icon(
                      snapshot.hasData ?
                      (snapshot.data ? Icons.star : Icons.star_border)
                      : Icons.star_border,
                      color: snapshot.hasData ?
                      (snapshot.data ? Styles.ArrivalPalletteYellow : Styles.ArrivalPalletteBlack)
                      : Styles.ArrivalPalletteBlack,
                      size: 35,
                    ),
                  ),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width - 100,
                child: Text(
                  category.name,
                  style: Styles.PartnerNameText,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.all(_generalPadding),
          child: Wrap(
            spacing: _internalSpacing,
            runSpacing: _internalSpacing,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            children: drawerDisplay,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int index = int.parse(widget.index);
    if (index >= ArticleData.all.length) index = 0;
    var prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
    Category category = ArticleData.all[index];

    return Scaffold(
      body: Stack(
        children: [

          _buildHeader(category),

          SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 60),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                child: Column(
                  children: [
                    Container(
                      height: _headerHeight - 150,
                      color: Styles.transparentColor,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Styles.ArrivalPalletteWhite,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: _contentDisplay(prefs, category),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
