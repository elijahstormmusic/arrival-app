/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../adobe/pinned.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/blobs.dart';
import '../data/socket.dart';
import '../data/arrival.dart';
import '../data/app_state.dart';
import '../data/preferences.dart';
import '../data/cards/partners.dart';
import '../data/cards/articles.dart';
import '../data/cards/sales.dart';
import '../posts/post.dart';
import '../styles.dart';
import '../foryou/row_card.dart';
import '../foryou/business_card.dart';
import '../foryou/article_card.dart';
import '../foryou/post_card.dart';
import '../foryou/sale_card.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<ListScreen> {

  List<RowCard> forYou;
  ScrollController _scrollController;
  RefreshController _refreshController;
  RowCard _loadingCard;
  bool _allowRequest = true, _requestFailed = false;
  final REQUEST_AMOUNT = 10;

  @override
  void initState() {
    forYou = List<RowCard>();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _refreshController = RefreshController(initialRefresh: true);
    _loadingCard = RowLoading();
    socket.foryou = this;
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _pullNext(int amount) {
    if(!_allowRequest) return;
    _allowRequest = false;
    socket.emit('foryou ask', {
      'amount': amount,
    });
  }
  void _refresh() {
    if(!_allowRequest) return;
    forYou = List<RowCard>();
    _pullNext(REQUEST_AMOUNT);
  }
  void _loadMore() {
    if(!_allowRequest) return;
    _pullNext(REQUEST_AMOUNT);
  }
  void responded(var data) async {
    if(data.length==0) {
      _requestFailed = true;
      _refreshController.loadFailed();
      return;
    }

    List<RowCard> list = List<RowCard>();
    var card;

    try {
      for(var i=0;i<data.length;i++) {
        if(data[i]['type']==0) {
          card = RowBusiness(Business.json(data[i]));
        }
        else if(data[i]['type']==1) {
          card = RowArticle(Article.json(data[i]));
        }
        else if(data[i]['type']==2) {
          card = RowPost(Post.json(data[i]['post'], data[i]['user']));
        }
        else if(data[i]['type']==3) {
          card = RowSale(Sale.json(data[i]));
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

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        var appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);
        var prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
        var themeData = CupertinoTheme.of(context);
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: ArrivalTitle(),
            backgroundColor: Styles.mainColor,
          ),
          child: SafeArea(
            bottom: false,
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode){
                  Widget body;
                  if(mode==LoadStatus.idle){
                    body = Container();
                  }
                  else if(mode==LoadStatus.loading){
                    body = CupertinoActivityIndicator();
                  }
                  else if(mode == LoadStatus.failed){
                    body = Text("Network Error");
                  }
                  else if(mode == LoadStatus.canLoading){
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
            ),
          ),
        );
      },
    );
  }
}
