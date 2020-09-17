// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../data/socket.dart';
import '../data/link.dart';
import '../data/app_state.dart';
import '../data/cards/partners.dart';
import '../styles.dart';
import '../widgets/search_bar.dart';
import '../widgets/cards.dart';
import '../widgets/partner_headline.dart';
import '../posts/post.dart';
import '../posts/page.dart';
import '../data/arrival.dart';
import '../users/data.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<Post> explorePosts;
  final controller = TextEditingController();
  ScrollController _scrollController;
  RefreshController _refreshController;
  final focusNode = FocusNode();
  final userstate = {
    'link': UserData.client.cryptlink,
    'amount': 25,
  };
  String terms = '';
  bool _allowRequest = true, _requestFailed = false;

  @override
  void initState() {
    explorePosts = List<Post>();
    controller.addListener(_onTextChanged);
    socket.emit('posts get', userstate);
    socket.search = this;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _refreshController = RefreshController(initialRefresh: true);
    super.initState();
  }
  @override
  void dispose() {
    focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildExploreBoxes(List<Post> posts) {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: 1,
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      controller: _scrollController,
      children: new List<Widget>.generate(explorePosts.length, (index) {
        return PressableCard(
          onPressed: () {

              // request data
            socket.emit('posts get data', {
              'link': explorePosts[index].cryptlink,
            });

              // display post
            Navigator.of(context).push<void>(CupertinoPageRoute(
              builder: (context) => PostDisplayPage(
                                  explorePosts[index].cryptlink
              ), fullscreenDialog: true,
            ));
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: const Color(0xff757575)),
            ),
            child: FittedBox(
              fit: BoxFit.cover,
              child: explorePosts[index].icon(),
            ),
          ),
        );
      },
      ).toList(),
    );
  }
  Widget _buildSearchLines(List<Business> places) {
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
          child: BusinessHeadline(places[i]),
        );
      },
    );
  }
  Widget _buildSearch(AppState model, String terms) {
    List<Post> posts = model.searchPosts(terms);
    List<Business> businesses = model.searchBusinesses(terms);

    if (!posts.isEmpty || terms=='') {
      return _buildExploreBoxes(posts);
    }
    return _buildSearchLines(businesses);
  }
  Widget _createSearchBox() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Styles.mainColor,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: SearchBar(
          controller: controller,
          focusNode: focusNode,
        ),
      ),
    );
  }

  void responded(var data) async {
    if (data.length==0) {
      _requestFailed = true;
      _refreshController.loadFailed();
      return;
    }

    try {
      for (int i=0;i<data.length;i++) {
        explorePosts.add(Post.icon(
          cryptlink: data[i]['link'],
          cloudlink: data[i]['cloud'],
        ));
      }
    }
    catch (e) {
      _requestFailed = true;
      _refreshController.loadFailed();
      return;
    }

    _requestFailed = false;
    setState(() => terms = controller.text);
    await Future.delayed(const Duration(seconds: 1));
    _allowRequest = true;
  }

  void _pullNext() {
    if (!_allowRequest) return;
    _allowRequest = false;
    socket.emit('posts get', userstate);
  }
  void _refresh() {
    if (!_allowRequest) return;
    explorePosts = List<Post>();
    _pullNext();
  }
  void _loadMore() {
    if (!_allowRequest) return;
    _pullNext();
  }
  void _onTextChanged() {
    setState(() => terms = controller.text);
  }
  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AppState>(context, rebuildOnChange: true);

    return CupertinoTabView(
      builder: (context) {
        return SafeArea(
          bottom: false,
          child: Column(
            children: [
              _createSearchBox(),
              Expanded(
                child: SmartRefresher(
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
                  child: _buildSearch(model, terms),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
