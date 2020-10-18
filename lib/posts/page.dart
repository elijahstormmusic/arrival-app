/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

import '../data/app_state.dart';
import '../data/link.dart';
import '../posts/post.dart';
import '../users/profile.dart';
import '../users/page.dart';
import '../users/data.dart';
import '../data/arrival.dart';
import '../data/socket.dart';
import '../styles.dart';
import 'display.dart';


class PostDisplayPage extends StatefulWidget {
  final String cryptlink;

  PostDisplayPage(this.cryptlink) {
    if (ArrivalData.getPost(cryptlink)==null) {
      Post.link(cryptlink);
    }
  }

  @override
  _PostDisPState createState() => _PostDisPState();
}

class _PostDisPState extends State<PostDisplayPage> {
  bool loaded = false;
  int _page = 0;

  @override
  void initState() {
    socket.post = this;

        // request data if absent
    if (ArrivalData.getPost(widget.cryptlink).user==null) {
      socket.emit('posts get data', {
        'link': ArrivalData.getPost(widget.cryptlink).cryptlink,
      });
    }

    if (ArrivalData.getPost(widget.cryptlink).commentPage==-1) {
      socket.emit('posts get comments', {
        'link': ArrivalData.getPost(widget.cryptlink).cryptlink,
        'page': _page,
      });
    }

    super.initState();
  }

  void responded() {
    setState(() => loaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: PostDisplay(
          ArrivalData.getPost(widget.cryptlink),
          scrollable: true,
        ),
      ),
    );
  }
}
