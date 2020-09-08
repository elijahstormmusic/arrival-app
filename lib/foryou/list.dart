/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:adobe_xd/pinned.dart';
import '../widgets/profile_stats_card.dart';
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

  ScrollController _scrollController;
  var appState, prefs, themeData;
  bool onetimeRefresh = true;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    socket.foryou = this;
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void pullNext(int amount) {
    socket.emit('foryou ask', {
      'amount': amount,
    });
  }
  void refresh() {
    appState.forYou = List<RowCard>();
    pullNext(10);
  }
  void responded(var data) {
    onetimeRefresh = true;
    List<RowCard> list = List<RowCard>();
    var card;

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

    setState(() => appState.forYou += list);
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        pullNext(10);
      });
    }
    if (_scrollController.offset + 40 <= _scrollController.position.minScrollExtent &&
        onetimeRefresh) {
      onetimeRefresh = false;
      setState(() {
        refresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        if(appState==null) {
          appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);
          prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
          themeData = CupertinoTheme.of(context);
        }
        if(appState.forYou.length==0) {
          for(var i=0;i<ArrivalData.partners.length;i++) {
            appState.forYou.add(RowBusiness(ArrivalData.partners[i]));
          }
        }
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: ArrivalTitle(),
            backgroundColor: Styles.mainColor,
          ),
          child: SafeArea(
            bottom: false,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: appState.forYou.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
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
                            child: UserProfilePlacard(),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (index <= appState.forYou.length) {
                  return appState.forYou[index-1].generate(prefs);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
