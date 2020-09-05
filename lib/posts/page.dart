// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

import '../data/app_state.dart';
import '../styles.dart';
import '../widgets/close_button.dart';
import '../posts/post.dart';
import '../users/profile.dart';
import '../users/page.dart';
import '../data/socket.dart';

class PostDisplayPage extends StatefulWidget {
  Post post;
  ArrivalSocket socket;

  PostDisplayPage(Post _p, ArrivalSocket _s) {
    this.post = _p;
    this.socket = _s;
    this.socket.target = this;
  }

  @override
  _PostDisPState createState() => _PostDisPState();
}

class _PostDisPState extends State<PostDisplayPage> {
  bool response = false;

  void responded(Post input) {
    setState(() => widget.post = input);
  }

  Widget profileDisplay(Profile user) {
    return GestureDetector(
      child: SizedBox(
        height: 50,
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9999.0),
                child: user.iconBySize(35.0),
              ),
            ),
            Positioned(
              top: 14,
              left: 50,
              child: Text(
                user.name,
                style: Styles.profileName
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push<void>(CupertinoPageRoute(
          builder: (context) => ProfilePage.user(user),
          fullscreenDialog: true,
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    final themeData = CupertinoTheme.of(context);
    final padding = 7.0;
    final lineSize = 3.0;
    var clientHasLikedPost = false;
    var ClientHeartStyle = Styles.heart;
    var ClientHeartColor = Colors.black;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Back',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView(
              children: [
                profileDisplay(
                  widget.post.user==null ? Profile.empty : widget.post.user
                ),
                Divider(height: lineSize, thickness: lineSize),
                widget.post.image(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                  child: SizedBox(
                    height: 300,
                    child: ListView(
                      children: [
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              child: Expanded(
                                flex: 1,
                                child: Icon(
                                  ClientHeartStyle,
                                  size: 35.0,
                                  color: ClientHeartColor,
                                ),
                              ),
                              onTap: () {
                                print(
                                  'liking post'
                                );
                                if(clientHasLikedPost) {
                                  ClientHeartStyle = Styles.heart;
                                  ClientHeartColor = Colors.black;
                                } else {
                                  ClientHeartStyle = Styles.heart_full;
                                  ClientHeartColor = Colors.red;
                                }
                                setState(() => clientHasLikedPost = !clientHasLikedPost);
                              },
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Styles.comment,
                                size: 35.0,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Material(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Styles.share,
                                size: 35.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: padding),
                        Text.rich(
                          TextSpan(
                            style: Styles.postText,
                            children: [
                              TextSpan(
                                text:
                                widget.post.likes.toString() + ' likes & ',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text:
                                widget.post.comments.toString() + ' comments',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: padding),
                        Text.rich(
                          TextSpan(
                            style: Styles.postText,
                            children: [
                              TextSpan(
                                text: widget.post.user==null ? 'no user' : widget.post.user.name
                                + '  ',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(text: '  ' + widget.post.caption),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: padding),
                        Text.rich(
                          TextSpan(
                            style: Styles.postText,
                            children: [
                              TextSpan(
                                text: '(comments will go here later...)',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                )
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
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
