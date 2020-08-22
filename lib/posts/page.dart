// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../styles.dart';
import '../widgets/close_button.dart';
import '../posts/post.dart';

class PostDisplayPage extends StatefulWidget {
  Post post;

  PostDisplayPage(Post _p) {
    this.post = _p;
  }

  @override
  _PostDisPState createState() => _PostDisPState();
}

class _PostDisPState extends State<PostDisplayPage> {

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
              children: [
                Positioned(
                  top: 16,
                  left: 16,
                  child: SafeArea(
                    child: ArrCloseButton(() {
                      Navigator.of(context).pop();
                    }),
                  ),
                ),
                SizedBox(height: 20),
                widget.post.image(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
