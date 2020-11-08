// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_client/cloudinary_client.dart';

import '../data/app_state.dart';
import '../data/preferences.dart';
import '../data/socket.dart';
import '../data/arrival.dart';
import '../data/link.dart';
import '../styles.dart';
import '../widgets/close_button.dart';
import '../posts/post.dart';
import '../posts/page.dart';
import '../users/data.dart';
import '../users/profile.dart';
import '../widgets/cards.dart';


class UserPosts extends StatefulWidget {
  final List<Post> userPosts;
  final String cryptlink;
  final bool has_reached_end;

  UserPosts(this.userPosts, this.cryptlink, this.has_reached_end);

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
      'link': widget.cryptlink,
      'amount': 18,
      'index': 0,
    };
    if (!widget.has_reached_end) {
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
    if (widget.has_reached_end) return;
    userstate['index'] = widget.userPosts.length;
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
          widget.userPosts.length, (index) {
            return PressableCard(
              onPressed: () {
                Arrival.navigator.currentState.push(MaterialPageRoute(
                  builder: (context) => PostDisplayPage(
                    widget.userPosts[index].cryptlink
                  ), fullscreenDialog: true,
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: const Color(0xff757575)),
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: widget.userPosts[index].icon(),
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
  ProfilePage.fromLink(String cryptlink) {
    profile = ArrivalData.getProfile(cryptlink);
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedViewIndex = 0;
  bool loaded = false;
  List<Post> userPosts;
  bool has_reached_end = false;

  File _newProfilePic;
  bool _editingProfile = false;
  TextEditingController _editableShortBio, _editableName;

  @override
  void initState() {
    _editableShortBio = new TextEditingController(text: widget.profile.shortBio);
    _editableName = new TextEditingController(text: widget.profile.name);
    userPosts = List<Post>();
    socket.profile = this;
    if (widget.profile.email=='') {
      socket.emit('profile get', {
        'link': widget.profile.cryptlink,
      });
    }
    super.initState();
  }

  void responded(int index) {
    if (index==null) return;
    widget.profile = ArrivalData.profiles[index];
    setState(() => loaded = true);
  }
  void loadedPosts(List<Post> input, bool at_end) {
    for (int i=0;i<input.length;i++) {
      ArrivalData.innocentAdd(userPosts, input[i]);
    }
    setState(() => has_reached_end = at_end);
  }

  bool _isClientAndEditable() {
    return widget.profile==UserData.client;
  }
  void _saveProfileEdits() async {
    if (!_isClientAndEditable()) return;

    if (_editableShortBio.text!=UserData.client.shortBio) {
      socket.emit('userdata update', {
        'link': UserData.client.cryptlink,
        'password': UserData.password,
        'type': 'bio',
        'value': _editableShortBio.text,
      });

      UserData.client.shortBio = _editableShortBio.text;
    }

    if (_editableName.text!='') {
      if (_editableName.text!=UserData.client.name) {
        socket.emit('userdata update', {
          'link': UserData.client.cryptlink,
          'password': UserData.password,
          'type': 'name',
          'value': _editableName.text,
        });

        UserData.client.name = _editableName.text;
      }
    }

    if (_newProfilePic!=null) {
      CloudinaryClient cloudinary_client =
        new CloudinaryClient('868422847775537',
          'QZeAt-YmyaViOSNctnmCR0FF61A', 'arrival-kc');

      String image_name = UserData.client.name + Random().nextInt(1000000).toString();
      String img_url = (await cloudinary_client.uploadImage(
        _newProfilePic.path,
        filename: image_name,
        folder: 'profile/' + UserData.client.name,
      )).secure_url.replaceAll('https://res.cloudinary.com/arrival-kc/image/upload/', '');

      if (img_url!=null) {
        socket.emit('userdata update', {
          'link': UserData.client.cryptlink,
          'password': UserData.password,
          'type': 'pic',
          'value': img_url,
        });

        UserData.client.pic = img_url;
      }
    }

    await UserData.save();
  }

  Widget _buildPersonalDetails(BuildContext context, AppState model) {
    final themeData = CupertinoTheme.of(context);
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ArrCloseButton(() {
                  Navigator.of(context).pop();
                }),
                SizedBox(width: 16),
                Text(
                  widget.profile.name,
                  style: Styles.profilePageHeader
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 10,
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: (_editingProfile && _newProfilePic!=null)
                  ? FileImage(_newProfilePic)
                  : NetworkImage(widget.profile.media_href()),
                child: _editingProfile ? GestureDetector(
                  onTap: () async {
                    _newProfilePic = await ImagePicker.pickImage(source: ImageSource.gallery);
                  },
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Styles.ArrivalPalletteLightGrey,
                    child: Icon(
                      Icons.edit,
                      size: 16,
                      color: Styles.ArrivalPalletteRed,
                    ),
                  ),
                ) : Container(),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 6,
              ),
              child: Row(
                children: [
                  _editingProfile ? Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      controller: _editableName,
                      maxLength: 20,
                      decoration: InputDecoration(
                        labelText: 'name',
                      ),
                      onChanged: (String input) {
                        _editableName.text = input;
                      },
                    )
                  ) : Text.rich(
                    TextSpan(
                      style: Styles.profilePageText,
                      children: [
                        TextSpan(
                          text: widget.profile.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '', // job title?
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  _isClientAndEditable() ? GestureDetector(
                    onTap: () {
                      if (_editingProfile) _saveProfileEdits();
                      setState(() => _editingProfile = !_editingProfile);
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Styles.ArrivalPalletteLightGrey,
                      child: Icon(
                        _editingProfile ? Icons.save : Icons.edit,
                        size: 16,
                        color: Styles.ArrivalPalletteRed,
                      ),
                    ),
                  ) : Container(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 6,
              ),
              child: _editingProfile ? TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                maxLength: 500,
                controller: _editableShortBio,
                decoration: InputDecoration(
                  labelText: 'short bio',
                ),
                onChanged: (String input) {
                  _editableShortBio.text = input;
                },
              ) : Text(
                widget.profile.shortBio,
                style: Styles.profilePageText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);

    return Scaffold(
      body: Container(
        color: Styles.ArrivalPalletteLightGreyTransparent,
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
                      0: Icon(Icons.apps),
                      1: Icon(Icons.alternate_email),//alternate_email_rounded
                      2: Icon(Icons.message),
                    },
                    groupValue: _selectedViewIndex,
                    onValueChanged: (value) {
                      setState(() => _selectedViewIndex = value);
                    },
                  ),
                  SizedBox(height: 20),
                  _selectedViewIndex == 0
                  ? UserPosts(userPosts, widget.profile.cryptlink, has_reached_end)
                  : _selectedViewIndex == 1
                  ? Second(widget.profile)
                  : UserContact(widget.profile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
