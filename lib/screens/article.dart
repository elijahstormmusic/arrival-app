/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:drop_cap_text/drop_cap_text.dart';

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
  int _articleTitleBestSize = 30;
  double _safeareaPadding;
  double _maxHeaderHeight = 126.0, _minHeaderHeight = 66.0;
  double _headerDrawY = 71.0, _headerDrawHeight = 35.0;
  double _headerHeight;
  double _articlePadding = 24.0;
  double _articleProgress = 0.0;
  double _lastScrollExtent;
  double _progressBarHeight = 10.0;
  double _lastRatio = 0.0;
  String _adjustedArticleTitle;
  Duration _animationDuration = Duration(seconds: 1);
  ScrollController _scrollController;

  String _breakLines(String input, int size) {
    if(input.length<=size) return input;
    return input.substring(0, size) + '' + _breakLines(
      input.substring(size, input.length), size);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();

    if (widget.article.title.length>_articleTitleBestSize) {
      _maxHeaderHeight += _headerDrawHeight;
      _headerDrawHeight*=2;
      _adjustedArticleTitle =
        _breakLines(widget.article.title, _articleTitleBestSize);
    }
    else _adjustedArticleTitle = widget.article.title + '                              '
            .substring(0, _articleTitleBestSize-widget.article.title.length);

    _headerHeight = _maxHeaderHeight;

    SchedulerBinding.instance.addPostFrameCallback((_) =>
      _lastScrollExtent = _scrollController.position.maxScrollExtent
    );
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    double thisScrollExtent = _scrollController.position.maxScrollExtent;
    double ratio = _scrollController.offset
      / (((thisScrollExtent + _lastScrollExtent) / 2) * 0.95);
    ratio = (ratio * 10.0).floor().toDouble() / 10.0;
    ratio += 0.05 - (ratio * 0.05);
    if (ratio!=_lastRatio) {
      _lastRatio = ratio;
      if (ratio>0.2) {
        _headerHeight = _minHeaderHeight;
        _progressBarHeight = 5.0;
      } else {
        _headerHeight = _maxHeaderHeight;
        _progressBarHeight = 10.0;
      }
      setState(() => _articleProgress = ratio);
    }
    _lastScrollExtent = thisScrollExtent;
  }

  String _makeDateReadable(String fullDate) {
    return fullDate.substring(0, 15);
  }

  Widget _buildHeader(BuildContext context, AppState model) {
    return AnimatedContainer(
      duration: _animationDuration,
      curve: Curves.easeOutBack,
      height: _headerHeight + _safeareaPadding,
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
          Positioned(
            top: _headerDrawY,
            left: _articlePadding,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Styles.articleColorsSecondary,
                ),
                width: MediaQuery.of(context).size.width - (_articlePadding*2),
                height: _headerDrawHeight,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(_articlePadding/2, 0, _articlePadding/2, 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _adjustedArticleTitle,
                          style: Styles.smallerArticleHeadline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: _headerDrawY + _headerDrawHeight,
            left: _articlePadding,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Styles.articleColorsSecondary,
                ),
                width: MediaQuery.of(context).size.width - (_articlePadding*2),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(_articlePadding/2, 0, _articlePadding/2, 0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.article.author + '        ',
                          style: Styles.articleAuthor,
                        ),
                        TextSpan(
                          text: _makeDateReadable(widget.article.date),
                          style: Styles.articleDate,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return AnimatedContainer(
      width: MediaQuery.of(context).size.width * _articleProgress,
      height: _progressBarHeight,
      duration: _animationDuration,
      curve: Curves.ease,
      decoration: BoxDecoration(
        color: Styles.ArrivalPalletteRed,
      ),
    );
  }

  Widget _buildStarterText(var content) {
    return Padding(
      padding: EdgeInsets.all(_articlePadding),
      child: DropCapText(
        content,
        dropCapPadding: EdgeInsets.all(4),
        forceNoDescent: true,
        style: Styles.articleContent,
        textAlign: TextAlign.justify,
        dropCapChars: 1,
      ),
    );
  }
  Widget _buildText(var content) {
    return Padding(
      padding: EdgeInsets.all(_articlePadding),
      child: Text(
        content,
        style: Styles.articleContent,
        textAlign: TextAlign.justify,
      ),
    );
  }
  Widget _buildImage(var content) {
    return Image.network(
      widget.article.image_link(content)
    );
  }
  Widget _buildImageTextWrap(var content, var textWrap, bool leftWrap) {
    return Padding(
      padding: EdgeInsets.all(_articlePadding),
      child: DropCapText(
        textWrap,
        style: Styles.articleContent,
        textAlign: TextAlign.justify,
        dropCapPosition: leftWrap ? DropCapPosition.start : DropCapPosition.end,
        dropCap: DropCap(
          width: 200.0,
          height: 200.0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              leftWrap ? 0 : _articlePadding, 0,
              leftWrap ? _articlePadding : 0, 0
            ),
            child: Image.network(
              widget.article.image_link(content),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildQuote(var content) {
    return Padding(
      padding: EdgeInsets.all(_articlePadding*2),
      child: Container(
        decoration: BoxDecoration(
          color: Styles.articleColorsPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(_articlePadding),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: content[0],
                  style: Styles.articleQuoteStart,
                ),
                TextSpan(
                  text: content.substring(1, content.length),
                  style: Styles.articleQuote,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildArticle() {
    bool skipNext = false;
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      controller: _scrollController,
      itemCount: widget.article.body.length + 1,
      itemBuilder: (context, index) {
        if (index==0) {
          return _buildStarterText(widget.article.body[index]['content']);
        }
        if (index==widget.article.body.length) {
          return Padding(
            padding: EdgeInsets.all(_articlePadding),
            child: Column(
              children: <Widget>[
                SizedBox(height: _articlePadding),
                widget.article.extra_info!='' && widget.article.extra_info!=null
                  ? Text(
                    widget.article.extra_info,
                    style: Styles.articleDate,
                  )
                  : Container(),
                SizedBox(height: _articlePadding*2),
                Text(
                  widget.article.author,
                  style: Styles.articleAuthor,
                ),
                Text(
                  _makeDateReadable(widget.article.date),
                  style: Styles.articleDate,
                ),
                SizedBox(height: _articlePadding*2),
              ],
            ),
          );
        }
        if (skipNext) {
          skipNext = false;
          return Container();
        }
        if (widget.article.body[index]['type']==0) {
          return _buildText(widget.article.body[index]['content']);
        }
        else if (widget.article.body[index]['type']==1) {
          if (index+1<widget.article.body.length) {
            if (widget.article.body[index+1]['type']==0) {
              skipNext = true;
              return _buildImageTextWrap(
                widget.article.body[index]['content'],
                widget.article.body[index+1]['content'],
                index%2==0,
              );
            }
          }
          return _buildImage(widget.article.body[index]['content']);
        }
        else if (widget.article.body[index]['type']==2) {
          return _buildQuote(widget.article.body[index]['content']);
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    _safeareaPadding = MediaQuery.of(context).padding.top;

    return CupertinoPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              children: <Widget>[
                _buildHeader(context, appState),
                _buildProgressBar(context),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Styles.articleColorsSecondary,
                    ),
                    height: MediaQuery.of(context).size.height - _headerHeight,
                    child: _buildArticle(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
