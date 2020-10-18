/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:drop_cap_text/drop_cap_text.dart';

import '../data/arrival.dart';
import '../data/preferences.dart';
import '../articles/article.dart';
import '../styles.dart';
import '../widgets/close_button.dart';
import '../widgets/cards.dart';
import '../maps/maps.dart';

class ArticleDisplayPage extends StatefulWidget {
  final String cryptlink;

  ArticleDisplayPage(this.cryptlink) {
    if (ArrivalData.getArticle(cryptlink)==null) {
      Article.link(cryptlink);
    }
  }

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
    if (input.length<=size) return input;
    return input.substring(0, size) + '' + _breakLines(
      input.substring(size, input.length), size);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();

    if (ArrivalData.getArticle(widget.cryptlink).title.length>_articleTitleBestSize) {
      _maxHeaderHeight += _headerDrawHeight;
      _headerDrawHeight*=2;
      _adjustedArticleTitle =
        _breakLines(ArrivalData.getArticle(widget.cryptlink).title, _articleTitleBestSize);
    }
    else _adjustedArticleTitle = ArrivalData.getArticle(widget.cryptlink).title + '                              '
            .substring(0, _articleTitleBestSize-ArrivalData.getArticle(widget.cryptlink).title.length);

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

  Widget _buildHeader(BuildContext context) {
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
              ArrivalData.getArticle(widget.cryptlink).image_link(0),
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
            top: _headerDrawY + _headerDrawHeight - 1,
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
                          text: ArrivalData.getArticle(widget.cryptlink).author + '        ',
                          style: Styles.articleAuthor,
                        ),
                        TextSpan(
                          text: _makeDateReadable(ArrivalData.getArticle(widget.cryptlink).date),
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
      ArrivalData.getArticle(widget.cryptlink).image_link(content)
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
              ArrivalData.getArticle(widget.cryptlink).image_link(content),
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
      itemCount: ArrivalData.getArticle(widget.cryptlink).body.length + 1,
      itemBuilder: (context, index) {
        if (index==0) {
          return _buildStarterText(ArrivalData.getArticle(widget.cryptlink).body[index]['content']);
        }
        if (index==ArrivalData.getArticle(widget.cryptlink).body.length) {
          return Padding(
            padding: EdgeInsets.all(_articlePadding),
            child: Column(
              children: <Widget>[
                SizedBox(height: _articlePadding),
                ArrivalData.getArticle(widget.cryptlink).extra_info!='' && ArrivalData.getArticle(widget.cryptlink).extra_info!=null
                  ? Text(
                    ArrivalData.getArticle(widget.cryptlink).extra_info,
                    style: Styles.articleDate,
                  )
                  : Container(),
                SizedBox(height: _articlePadding*2),
                Text(
                  ArrivalData.getArticle(widget.cryptlink).author,
                  style: Styles.articleAuthor,
                ),
                Text(
                  _makeDateReadable(ArrivalData.getArticle(widget.cryptlink).date),
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
        if (ArrivalData.getArticle(widget.cryptlink).body[index]['type']==0) {
          return _buildText(ArrivalData.getArticle(widget.cryptlink).body[index]['content']);
        }
        else if (ArrivalData.getArticle(widget.cryptlink).body[index]['type']==1) {
          if (index+1<ArrivalData.getArticle(widget.cryptlink).body.length) {
            if (ArrivalData.getArticle(widget.cryptlink).body[index+1]['type']==0) {
              skipNext = true;
              return _buildImageTextWrap(
                ArrivalData.getArticle(widget.cryptlink).body[index]['content'],
                ArrivalData.getArticle(widget.cryptlink).body[index+1]['content'],
                index%2==0,
              );
            }
          }
          return _buildImage(ArrivalData.getArticle(widget.cryptlink).body[index]['content']);
        }
        else if (ArrivalData.getArticle(widget.cryptlink).body[index]['type']==2) {
          return _buildQuote(ArrivalData.getArticle(widget.cryptlink).body[index]['content']);
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _safeareaPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              children: <Widget>[
                _buildHeader(context),
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
