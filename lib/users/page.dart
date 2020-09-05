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
import '../styles.dart';
import '../widgets/close_button.dart';
import '../users/data.dart';
import '../users/profile.dart';
import '../widgets/cards.dart';

class First extends StatelessWidget {
  Profile profile;
  First(this.profile);

  @override
  Widget build(BuildContext context) {
    return Material();
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
class Other extends StatelessWidget {
  Profile profile;
  Other(this.profile);

  @override
  Widget build(BuildContext context) {
    return Material();
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
  ArrivalSocket socket;

  @override
  void initState() {
    socket = ArrivalSocket();
    socket.init();
    socket.source = this;
    socket.emit('profile get', {
      'link': widget.profile.cryptlink,
    });
    super.initState();
  }

  void responded(Profile _input) {
    setState(() => widget.profile = _input);
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
              children: [
                _buildPersonalDetails(context, appState),
                SizedBox(height: 20),
                CupertinoSegmentedControl<int>(
                  children: {
                    0: Text('First'),
                    1: Text('Second'),
                    2: Text('Other'),
                  },
                  groupValue: _selectedViewIndex,
                  onValueChanged: (value) {
                    setState(() => _selectedViewIndex = value);
                  },
                ),
                _selectedViewIndex == 0
                    ? First(widget.profile)
                  : _selectedViewIndex == 1
                    ? Second(widget.profile)
                    : Other(widget.profile),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
