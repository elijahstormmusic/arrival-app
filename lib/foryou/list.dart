/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../adobe/pinned.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/slide_menu.dart';
import '../widgets/blobs.dart';
import '../widgets/cards.dart';
import '../data/socket.dart';
import '../data/arrival.dart';
import '../data/app_state.dart';
import '../data/preferences.dart';
import '../data/cards/partners.dart';
import '../data/cards/articles.dart';
import '../data/cards/sales.dart';
import '../posts/post.dart';
import '../posts/upload.dart';
import '../styles.dart';
import '../foryou/row_card.dart';
import '../foryou/business_card.dart';
import '../foryou/article_card.dart';
import '../foryou/post_card.dart';
import '../foryou/sale_card.dart';
import 'search.dart';

class ForYouPage extends StatefulWidget {
  static _ListState currentState;
  static void scrollToTop() {
    if(ForYouPage.currentState==null) return;
    currentState.scrollToTop();
  }

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<ForYouPage> {

  List<RowCard> forYou;
  ScrollController _scrollController;
  RefreshController _refreshController;
  RowCard _loadingCard;
  bool _allowRequest = true, _requestFailed = false;
  final REQUEST_AMOUNT = 10;
  Search _search;

  @override
  void initState() {
    forYou = List<RowCard>();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _refreshController = RefreshController(initialRefresh: true);
    _loadingCard = RowLoading();
    _search = Search();
    socket.foryou = this;
    ForYouPage.currentState = this;
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _pullNext(int amount) {
    if (!_allowRequest) return;
    _allowRequest = false;
    socket.emit('foryou ask', {
      'amount': amount,
    });
  }
  void _refresh() {
    if (!_allowRequest) return;
    forYou = List<RowCard>();
    _pullNext(REQUEST_AMOUNT);
  }
  void _loadMore() {
    if (!_allowRequest) return;
    _pullNext(REQUEST_AMOUNT);
  }
  void responded(var data) async {
    if (data.length==0) {
      _requestFailed = true;
      _refreshController.loadFailed();
      return;
    }

    List<RowCard> list = List<RowCard>();
    var card, result;

    try {
      for (var i=0;i<data.length;i++) {
        if (data[i]['type']==0) {
          result = Business.json(data[i]);
          card = RowBusiness(result);
          ArrivalData.partners.add(result);
        }
        else if (data[i]['type']==1) {
          result = Article.json(data[i]);
          card = RowArticle(result);
          ArrivalData.articles.add(result);
        }
        else if (data[i]['type']==2) {
          result = Post.json(data[i]['post']);
          card = RowPost(result);
          ArrivalData.posts.add(result);
        }
        else if (data[i]['type']==3) {
          result = Sale.json(data[i]);
          card = RowSale(result);
          ArrivalData.sales.add(result);
        }
        else continue;

        list.add(card);
      }
      _refreshController.loadComplete();
      _refreshController.refreshCompleted();
    }
    catch (e) {
      _requestFailed = true;
      _refreshController.loadFailed();
      return;
    }

    _requestFailed = false;
    setState(() => forYou += list);
    await Future.delayed(const Duration(seconds: 1));
    _allowRequest = true;
  }

  void _scrollListener() {
    if (_scrollController.offset + 400 >= _scrollController.position.maxScrollExtent) {
      _pullNext(REQUEST_AMOUNT);
    }
  }
  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _gotoUpload(BuildContext context) {
    Navigator.of(context).push<void>(CupertinoPageRoute(
      builder: (context) => PostUploadScreen(),
      fullscreenDialog: true,
    ));
  }

  Widget _buildForyouList(BuildContext context, var prefs) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode){
          Widget body;
          if (mode==LoadStatus.idle){
            body = Container();
          }
          else if (mode==LoadStatus.loading){
            body = CupertinoActivityIndicator();
          }
          else if (mode == LoadStatus.failed){
            body = Text("Network Error");
          }
          else if (mode == LoadStatus.canLoading){
            body = Container();
          }
          else {
            body = Container();
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _refresh,
      onLoading: _loadMore,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: forYou.length + 3,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Stack(
              children: <Widget>[
                Blob_Background(height: 305.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 32, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 265.0,
                        child: Pinned.fromSize(
                          bounds: Rect.fromLTWH(18.0, 26.0, 387.0, 205.0),
                          size: Size(412.0, 1600.0),
                          pinLeft: true,
                          pinRight: true,
                          pinTop: true,
                          fixedHeight: true,
                          child: UserProfilePlacecard(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (index <= forYou.length) {
            return forYou[index-1].generate(prefs);
          } else {
            return _loadingCard.generate(prefs);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        var appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);
        var prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
        var themeData = CupertinoTheme.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'ARRIVAL',
              style: Styles.arrTitleText,
            ),
            backgroundColor: Styles.ArrivalPalletteRed,
            // leading: IconButton(
            //   icon: const Icon(Icons.menu),
            //   onPressed: () {
            //
            //   }
            // ),
            actions: <Widget>[
              IconButton(
                onPressed: () =>
                  setState(() => _search.searchOpen = !_search.searchOpen),
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          drawer: SlideMenu(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _gotoUpload(context),
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
            backgroundColor: Styles.ArrivalPalletteBlue,
          ),
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: <Widget>[
                _buildForyouList(context, prefs),
                _search,
              ],
            ),
          ),
        );
      },
    );
  }
}
