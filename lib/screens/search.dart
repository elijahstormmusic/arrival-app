// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import '../data/socket.dart';
import '../data/link.dart';
import '../data/app_state.dart';
import '../data/partners.dart';
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
  final controller = TextEditingController();
  final focusNode = FocusNode();
  final userstate = {
    'link': UserData.client.cryptlink,
  };
  String terms = '';
  ArrivalSocket socket;
  ScrollController _scrollController;

  @override
  void initState() {
    controller.addListener(_onTextChanged);
    socket = ArrivalSocket();
    socket.init();
    socket.emit('posts set state', userstate);
    socket.source = this;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() => terms = controller.text);
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

  int _exploreFlow = ArrivalData.posts.length;
  Future<Post> _fetchPostData(BuildContext context, String link) async {
    return Post.empty;
    // final response = await http.get(link);
    //
    // return Post.parse(response.body);
  }
  Widget _postImageBuilder(String link) {
    return FutureBuilder(
      future: _fetchPostData(context, link),
      builder: (context, snap) {
        if(snap.hasData) {
          return snap.data.icon;
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
  String _getPostLink(int index) {
    return Post.source + ArrivalData.posts[index].cryptlink;
  }
  Widget _buildExploreBoxes(List<Post> posts) {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: 1,
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      controller: _scrollController,
      children: new List<Widget>.generate(_exploreFlow, (index) {
        return PressableCard(
          onPressed: () {
            socket.emit('posts get data', {
              'link': ArrivalData.posts[index].cryptlink,
            });
              // display post
            Navigator.of(context).push<void>(CupertinoPageRoute(
              builder: (context) => PostDisplayPage(ArrivalData.posts[index]),
              fullscreenDialog: true,
            ));
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: const Color(0xff757575)),
            ),
            child: FittedBox(
              fit: BoxFit.cover,
              child: ArrivalData.posts[index].icon(),
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
            'No locations match your search.',
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

  void responded() {
    _exploreFlow = ArrivalData.posts.length;
    setState(() => terms = controller.text);
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        socket.emit('posts get', userstate);
      });
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        // reached the top
      });
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
                child: _buildSearch(model, terms),
              ),
            ],
          ),
        );
      },
    );
  }
}
