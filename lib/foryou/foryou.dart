/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets/profile_stats_card.dart';
import '../widgets/notifications_card.dart';
import '../widgets/slide_menu.dart';
import '../widgets/cards.dart';
import '../data/socket.dart';
import '../data/arrival.dart';
import '../data/app_state.dart';
import '../data/preferences.dart';
import '../partners/partner.dart';
import '../articles/article.dart';
import '../partners/sale.dart';
import '../data/link.dart';
import '../posts/post.dart';
import '../posts/upload.dart';
import '../styles.dart';
import '../foryou/cards/row_card.dart';
import '../foryou/cards/partner_card.dart';
import '../foryou/cards/article_card.dart';
import '../foryou/cards/post_card.dart';
import '../foryou/cards/sale_card.dart';
import 'search.dart';

class ForYouPage extends StatefulWidget {
  static _ListState _s;

  static void scrollToTop() => _s.scrollToTop();
  static void refresh_state() => _s.refresh_state();
  static void addUploadingMediaProgress(String id) => _s.addUploadingMediaProgress(id);
  static void finishUploadingMediaProgress(String id) => _s.finishUploadingMediaProgress(id);
  static void displayUploadingMediaProgress(String id, String display) => _s.displayUploadingMediaProgress(id, display);

  static void openSnackBar(Map<String, dynamic> input) => _s.openSnackBar(input);

  static void showUploadButton() =>
    _s.setState(() => _s.showUploadButton = true);
  static void hideUploadButton() =>
    _s.setState(() => _s.showUploadButton = false);

  @override
  _ListState createState() {
    _s = _ListState();
    return _s;
  }
}

class _ListState extends State<ForYouPage> {

  ScrollController _scrollController;
  RefreshController _refreshController;
  RowCard _loadingCard;
  bool showUploadButton = true;
  bool _allowRequest = true, _requestFailed = false;
  final REQUEST_AMOUNT = 10;
  bool kill_reflow = false;
  final _scrollTargetDistanceFromBottom = 400.0;
  Search _search;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _refreshController = RefreshController(
      initialRefresh: false,
    );
    _loadingCard = RowLoading();
    _search = Search();
    socket.foryou = this;
    if (ArrivalData.foryou==null) {
      ArrivalData.foryou = List<RowCard>();
    }

    if (ArrivalData.foryou.length==0) {
      _pullNext(REQUEST_AMOUNT);
    }
  }
  @override
  void dispose() {
    kill_reflow = true;
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic> > _uploadingMedia = List<Map<String, dynamic> >();
  void addUploadingMediaProgress(String id) {
    if (kill_reflow) return;
    setState(() => _uploadingMedia.add({
      'id': id,
      'progress': 0,
    }));
  }
  void finishUploadingMediaProgress(String id) {
    for (int index=0;index<_uploadingMedia.length;index++) {
      if (_uploadingMedia[index]['id']==id) {
        if (kill_reflow) return;
        setState(() => _uploadingMedia.removeAt(index));
        // setState(() => _uploadingMedia[index]['progress'] = 1);
        break;
      }
    }
  }
  void displayUploadingMediaProgress(String id, String display) {
    for (int index=0;index<_uploadingMedia.length;index++) {
      if (_uploadingMedia[index]['id']==id) {
        _uploadingMedia[index]['post'] = RowPost(display);
        if (kill_reflow) return;
        setState(() => _uploadingMedia[index]['progress'] = 2);
        break;
      }
    }
  }
  Widget _generateUploadingMediaProgress(var prefs) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: 100.0 * _uploadingMedia.length,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: _uploadingMedia.length,
        itemBuilder: (context, index) {
          return _uploadingMedia[index]['progress']==2
            ? _uploadingMedia[index]['post'].generate(prefs)
            : FutureBuilder<void>(
                future: Future.delayed(Duration(milliseconds: 200)),
                builder: (c, s) => Container(
                  height: 84,
                  margin: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Styles.ArrivalPalletteCream,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Uploading your content...',
                        style: TextStyle(
                          color: Styles.ArrivalPalletteBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        // width: MediaQuery.of(context).size.width - 76,
                        decoration: BoxDecoration(
                          color: Styles.ArrivalPalletteCream,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1.0, color: Styles.ArrivalPalletteBlack),
                        ),
                        child: AnimatedContainer(
                          duration: Duration(seconds: 3),
                          curve: Curves.easeOut,
                          height: 20,
                          width: s.connectionState == ConnectionState.done
                              ? MediaQuery.of(context).size.width - 76 : 0,
                          decoration: BoxDecoration(
                            color: Styles.ArrivalPalletteRed,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
        },
      ),
    );
  }

  void _pullNext(int amount) {
    if (!_allowRequest) return;
    _allowRequest = false;
    socket.emit('foryou ask', {
      'amount': amount,
    });
    _checkForFailure();
  }
  bool _reponsedHeard, _forceFailCurrentState = false;
  int _timesFailedToHearResponse = 0;
  void _checkForFailure() async {
    _reponsedHeard = false;
    await Future.delayed(const Duration(seconds: 6));
    if (!_reponsedHeard) {
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
  void _refresh() {
    if (!_allowRequest) return;
    _uploadingMedia = List<Map<String, dynamic> >();
    ArrivalData.foryou = List<RowCard>();
    _pullNext(REQUEST_AMOUNT);
  }
  void _loadMore() {
    if (!_allowRequest) return;
    _pullNext(REQUEST_AMOUNT);
  }
  void responded(var data) async {
    _reponsedHeard = true;
    _timesFailedToHearResponse = 0;
    if (data.length==0) {
      _requestFailed = true;
      _refreshController.loadComplete();
      _refreshController.refreshCompleted();
      return;
    }

    List<RowCard> list = List<RowCard>();
    var card, result;

    try {
      for (var i=0;i<data.length;i++) {
        if (data[i]['type']==DataType.partner) {
          try {
            result = Partner.json(data[i]);
            card = RowPartner(result);
            ArrivalData.innocentAdd(ArrivalData.partners, result);
          } catch (e) {
            continue;
          }
        }
        else if (data[i]['type']==DataType.article) {
          try {
            result = Article.json(data[i]);
            card = RowArticle(result);
            ArrivalData.innocentAdd(ArrivalData.articles, result);
          } catch (e) {
            continue;
          }
        }
        else if (data[i]['type']==DataType.post) {
          try {
            result = Post.json(data[i]);
            ArrivalData.innocentAdd(ArrivalData.posts, result);
            card = RowPost(result.cryptlink);
          } catch (e) {
            print('''
            =======================
              post ERRR
                ${e}
            =======================
            ''');
            continue;
          }
        }
        else if (data[i]['type']==DataType.sale) {
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
            card = RowSale(result_list);
          } catch (e) {
            continue;
          }
        }
        else continue;

        list.add(card);
      }
      _refreshController.loadComplete();
      _refreshController.refreshCompleted();
    }
    catch (e) {
      _requestFailed = true;
      _refreshController.loadComplete();
      _refreshController.refreshCompleted();
      print(e);
      return;
    }

    _requestFailed = false;
    if (kill_reflow) return;
    setState(() => ArrivalData.foryou += list);
    ArrivalData.save();
    await Future.delayed(const Duration(seconds: 1));
    _allowRequest = true;
  }
  void search_response(var data) {
    _search.response(data);
  }

  void _scrollListener() {
    if (_scrollController.offset + _scrollTargetDistanceFromBottom
        >= _scrollController.position.maxScrollExtent) {
      _pullNext(REQUEST_AMOUNT);
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

  void _gotoUpload(BuildContext context) {
    Arrival.navigator.currentState.push(MaterialPageRoute(
      builder: (context) => PostUploadScreen(),
      fullscreenDialog: true,
    ));
  }

  Widget _buildForyouList(BuildContext context, var prefs) {
    return Container(
      color: Styles.transparentColor,
      child: SmartRefresher(
        enablePullDown: false,
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
              openSnackBar({
                'text': 'Network Error'
              });
              body = Container();
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
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollStartNotification) {
              _onStartScroll(scrollNotification.metrics);
            } else if (scrollNotification is ScrollEndNotification) {
              _onEndScroll(scrollNotification.metrics);
            }
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: ArrivalData.foryou.length + 3,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  height: 195.0,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NotificationsCard(prefs),

                      UserProfilePlacecard(),
                    ],
                  ),
                );
              } else if (index == 1) {
                return _generateUploadingMediaProgress(prefs);
              } else if (index - 2 < ArrivalData.foryou.length) {
                return ArrivalData.foryou[index - 2].generate(prefs);
              } else {
                if (_forceFailCurrentState) {
                  return Styles.ArrivalErrorPage('Make sure you are conntected to the internet.');
                }
                return _loadingCard.generate(prefs);
              }
            },
          ),
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {

    return CupertinoTabView(
      builder: (context) {
        var appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);
        var prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
        var themeData = CupertinoTheme.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Styles.ArrivalAppbarTitle(),
            backgroundColor: Styles.ArrivalPalletteRed,
            actions: <Widget>[
              IconButton(
                onPressed: () => setState(() => _search.toggleSearch()),
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          drawer: SlideMenu(),
          floatingActionButton: Visibility(
            visible: showUploadButton,
            child: FloatingActionButton(
              onPressed: () => _gotoUpload(context),
              tooltip: 'Upload Content',
              child: Icon(Icons.cloud_upload),
              backgroundColor: Styles.ArrivalPalletteBlue,
            ),
          ),
          resizeToAvoidBottomPadding: false,
          backgroundColor: Styles.transparentColor,
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

  static double inital_fade = 0;
}
