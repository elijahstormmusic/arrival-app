// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/preferences.dart';
import '../data/socket.dart';
import '../data/arrival.dart';
import '../styles.dart';
import '../widgets/close_button.dart';
import '../posts/post.dart';
import '../posts/page.dart';
import '../users/data.dart';
import '../users/profile.dart';
import '../widgets/cards.dart';


class UserPosts extends StatefulWidget {
  _ProfilePageState parentPage;
  UserPosts(this.parentPage);

  @override
  _UserPostsState createState() => _UserPostsState();
}
class _UserPostsState extends State<UserPosts> {

  ScrollController _scrollController;
  var userstate;
  bool _allowRequest = true, _requestFailed = false;

  @override
  void initState() {
    userstate = {
      'link': widget.parentPage.widget.profile.cryptlink,
      'amount': 18,
      'index': 0,
    };
    if (!widget.parentPage.has_reached_end) {
      socket.emit('profile get posts', userstate);
    }
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _pullNext() {
    if (!_allowRequest) return;
    _allowRequest = false;
    if (widget.parentPage.has_reached_end) return;
    userstate['index'] = widget.parentPage.userPosts.length;
    socket.emit('profile get posts', userstate);
  }
  void _loadMore() {
    if (!_allowRequest) return;
    _pullNext();
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

    return Container(
      child: GridView.count(
        shrinkWrap: true,
        childAspectRatio: 1,
        scrollDirection: Axis.vertical,
        crossAxisCount: 3,
        controller: _scrollController,
        physics: NeverScrollableScrollPhysics(),
        children: new List<Widget>.generate(
          widget.parentPage.userPosts.length, (index) {
            return PressableCard(
              onPressed: () {
                Navigator.of(context).push<void>(CupertinoPageRoute(
                  builder: (context) => PostDisplayPage(
                    widget.parentPage.userPosts[index].cryptlink
                  ), fullscreenDialog: true,
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: const Color(0xff757575)),
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: widget.parentPage.userPosts[index].icon(),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

class Second extends StatelessWidget {
  Profile profile;
  Second(this.profile);

  @override
  Widget build(BuildContext context) {
    return Material();
  }
}
class UserContact extends StatelessWidget {
  Profile profile;
  UserContact(this.profile);

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AppState>(context, rebuildOnChange: true);

    return Container(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
      // physics: ClampingScrollPhysics(),
      child: Container(

      ),
    );
  }
}


class ProfilePage extends StatefulWidget {
  Profile profile;

  ProfilePage() {
    this.profile = UserData.client;
  }
  ProfilePage.user(this.profile);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedViewIndex = 0;
  bool loaded = false;
  List<Post> userPosts;
  UserPosts _postScroller;
  bool has_reached_end = false;

  @override
  void initState() {
    userPosts = List<Post>();
    _postScroller = UserPosts(this);
    socket.profile = this;
    if(widget.profile.email=='') {
      socket.emit('profile get', {
        'link': widget.profile.cryptlink,
      });
    }
    super.initState();
  }

  void responded(int index) {
    if(index==null) return;
    widget.profile = ArrivalData.profiles[index];
    setState(() => loaded = true);
  }
  void loadedPosts(List<Post> input, bool at_end) {
    for (int i=0;i<input.length;i++) {
      ArrivalData.innocentAdd(userPosts, input[i]);
    }

    setState(() => has_reached_end = at_end);
  }

  Widget _buildPersonalDetails(BuildContext context, AppState model) {
    final themeData = CupertinoTheme.of(context);
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            child: widget.profile.icon(),
          ),
          Positioned(
            right: 20,
            left: 60,
            top: 30,
            child: Text(
              widget.profile.name,
              style: Styles.headlineText(themeData)
            ),
          ),
          Positioned(
            right: 20,
            left: 60,
            top: 60,
            child: Text(
              'level ' + widget.profile.level.toString(),
              style: Styles.headlineText(themeData)
            ),
          ),
          Positioned(
            right: 20,
            left: 60,
            top: 90,
            child: Text(
              widget.profile.shortBio,
              style: widget.profile.shortBio=='' ?
               Styles.noTextInput : Styles.shortBio
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
            right: 0,
            left: 0,
            bottom: 6,
            child: SafeArea(
              child: Divider(
                height: 3.0,
                thickness: 3.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);

    return CupertinoPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                _buildPersonalDetails(context, appState),
                SizedBox(height: 20),
                CupertinoSegmentedControl<int>(
                  children: {
                    0: Text('Posts'),
                    1: Text('Second'),
                    2: Text('Message'),
                  },
                  groupValue: _selectedViewIndex,
                  onValueChanged: (value) {
                    setState(() => _selectedViewIndex = value);
                  },
                ),
                SizedBox(height: 20),
                _selectedViewIndex == 0
                  ? _postScroller
                  : _selectedViewIndex == 1
                    ? Second(widget.profile)
                    : UserContact(widget.profile),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
