// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:share/share.dart';

import '../data/app_state.dart';
import '../data/preferences.dart';
import '../data/socket.dart';
import '../data/arrival.dart';
import '../data/link.dart';
import '../styles.dart';
import '../posts/post.dart';
import '../posts/page.dart';
import '../widgets/close_button.dart';
import '../widgets/cards.dart';
import '../widgets/chat/messager.dart';
import '../const.dart';
import 'data.dart';
import 'profile.dart';
import 'stories.dart';


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
    return Container(
      margin: EdgeInsets.all(30),
      child: Text(
        'Video Uploads availible next update!',
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}
class UserContact extends StatelessWidget {
  Profile profile;
  UserContact(this.profile);

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<AppState>(context, rebuildOnChange: true);

    return Container(
      margin: EdgeInsets.all(30),
      child: Text(
        'Audio Uploads availible next update!',
        style: TextStyle(
          fontSize: 30,
        ),
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

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {

  int _selectedViewIndex = 0;
  bool loaded = false;
  List<Post> userPosts;
  bool has_reached_end = false;
  final int _pageAnimationTime = 350;

  File _newProfilePic;
  bool _editingProfile = false;
  TextEditingController _editableShortBio, _editableName;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: _pageAnimationTime),
      upperBound: .25,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _editableShortBio = new TextEditingController(text: widget.profile.shortBio);
    _editableName = new TextEditingController(text: widget.profile.name);
    userPosts = List<Post>();
    socket.profile = this;
    if (widget.profile.email=='') {
      socket.emit('profile get', {
        'link': widget.profile.cryptlink,
      });
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      )).secure_url.replaceAll(Constants.media_source, '');

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

  String _followersNumberDisplay(int input) {
    String addition = '';
    double dblNumber = input.toDouble();
    if (dblNumber > 999999999) {
      dblNumber /= 100000000;
      dblNumber = dblNumber.floor() / 10.0;
      if (dblNumber % 1.0 == 0.0) return dblNumber.toInt().toString() + 'b';
      return dblNumber.toString() + 'b';
    }
    if (dblNumber > 999999) {
      dblNumber /= 100000;
      dblNumber = dblNumber.floor() / 10.0;
      if (dblNumber % 1.0 == 0.0) return dblNumber.toInt().toString() + 'm';
      return dblNumber.toString() + 'm';
    }
    if (dblNumber > 9999) {
      dblNumber /= 1000;
      dblNumber = dblNumber.floor() / 10.0;
      if (dblNumber % 1.0 == 0.0) return dblNumber.toInt().toString() + 'k';
      return dblNumber.toString() + 'k';
    }
    return input.toString();
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
            Container(
              width: MediaQuery.of(context).size.width - 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 74,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ArrCloseButton(() {
                          Navigator.of(context).pop();
                        }),
                        SizedBox(width: 16),
                        widget.profile.clickable_name(),
                      ],
                    ),
                  ),
                  Container(),

                  _isClientAndEditable() ? Container() :
                  GestureDetector(
                    onTap: () {
                      Arrival.navigator.currentState.push(MaterialPageRoute(
                        builder: (context) => Messager.create({
                            'group': [widget.profile.cryptlink],
                          }),
                        fullscreenDialog: true,
                      ));
                    },
                    child: Icon(
                      Icons.message,
                      color: Styles.ArrivalPalletteRed,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              width: MediaQuery.of(context).size.width - 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
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
                  Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100.0,
                        height: 100.0,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _followersNumberDisplay(1900),
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'followers',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 100.0,
                        height: 100.0,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _followersNumberDisplay(20000),
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'following',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                  ) : widget.profile.clickable_name(),
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
                maxLength: _pageAnimationTime,
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

  Widget _buildFollowButton(BuildContext context, AppState model) {
    if (widget.profile == UserData.client) return Container();
    final prefs = ScopedModel.of<Preferences>(context);
    double size_segment = MediaQuery.of(context).size.width / 3.0;
    double margin = 12.0;

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 24.0, top: 6.0),
          height: 44.0,
          width: MediaQuery.of(context).size.width - 48.0,
          decoration: Styles.backgroundRadiusGradient(10),
        ),

        Container(
          margin: EdgeInsets.symmetric(
            vertical: 6,
          ),
          child: GestureDetector(
            onTap: () async {
              await prefs.toggleBookmarked(DataType.profile, widget.profile.cryptlink);

              var toggle = await prefs.isBookmarked(DataType.profile, widget.profile.cryptlink);

              if (toggle) {
                _controller.forward(from: 0.0);
              }
              else {
                _controller.reverse(from: .25);
              }

              socket.emit('userdata follow', {
                'user': UserData.client.cryptlink,
                'follow': widget.profile.cryptlink,
                'action': toggle,
              });

              setState(() => 0);
            },
            child: FutureBuilder<bool>(
              future: prefs.isBookmarked(DataType.profile, widget.profile.cryptlink),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
              Row(
                children: [
                  AnimatedOpacity(
                    opacity: snapshot.hasData ?
                      (snapshot.data ? 0.0 : 1.0)
                      : 1.0,
                    duration: Duration(milliseconds: _pageAnimationTime),
                    curve: Curves.easeOut,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: _pageAnimationTime),
                      curve: Curves.easeOut,
                      margin: EdgeInsets.only(
                        left: snapshot.hasData ?
                          (snapshot.data ? margin : margin * 2.0)
                          : margin * 2.0,
                        right: snapshot.hasData ?
                          (snapshot.data ? margin + 5.0 : margin * 2.0 - 5.0)
                          : margin * 2.0 - 5.0,
                      ),
                      height: 44.0,
                      width: snapshot.hasData ?
                        (snapshot.data ? 0 : size_segment * 2 - (margin * 3))
                        : size_segment * 2 - (margin * 3),
                      color: Styles.transparentColor,
                      child: Center(
                        child: Text(
                          'Follow',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Styles.ArrivalPalletteWhite,
                          ),
                        ),
                      ),
                    ),
                  ),

                  AnimatedContainer(
                    duration: Duration(milliseconds: _pageAnimationTime),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.only(
                      right: margin * 2.0,
                    ),
                    // padding: EdgeInsets.all(6.0),
                    height: 34.0,
                    width: size_segment - (margin * 3),
                    decoration: BoxDecoration(
                      color: Styles.ArrivalPalletteWhite,
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(
                      //   color: Styles.transparentColor,
                      //   width: 3.0,
                      // ),
                      // borderColor: Styles.ArrivalPalletteRed,
                    ),
                    child: Center(
                      child: RotationTransition(
                        turns: _animation,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: _pageAnimationTime),
                          child: Icon(
                            Icons.add,
                            size: 35,
                            color: snapshot.hasData ?
                              (snapshot.data ? Styles.ArrivalPalletteRed : Styles.ArrivalPalletteDarkBlue)
                              : Styles.ArrivalPalletteDarkBlue,
                            // color: Styles.transparentColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  AnimatedOpacity(
                    opacity: snapshot.hasData ?
                      (snapshot.data ? 1.0 : 0.0)
                      : 0.0,
                    duration: Duration(milliseconds: _pageAnimationTime),
                    curve: Curves.easeOut,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: _pageAnimationTime),
                      curve: Curves.easeOut,
                      margin: EdgeInsets.only(
                        // left: snapshot.hasData ?
                        //   (snapshot.data ? margin : margin * 2.0)
                        //   : margin * 2.0,
                        // right: margin * 2.0 - 4.0,
                      ),
                      height: 44.0,
                      width: snapshot.hasData ?
                        (snapshot.data ? size_segment * 2 - (margin * 3) : 0)
                        : 0,
                      color: Styles.transparentColor,
                      child: Center(
                        child: Text(
                          'Unfollow',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Styles.ArrivalPalletteWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoryHighlights(BuildContext context, AppState model) {
    return StoriesHighlights(widget.profile);
  }

  Widget _buildContentDisplayOptions(BuildContext context, AppState model) {
    var size_third = MediaQuery.of(context).size.width / 3.0;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 18,
      ),
      child: Stack(
        children: [
          Container(
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  const Color(0xffF15D5D),
                  const Color(0xffF25E92),
                  const Color(0xffA35ADB),
                  const Color(0xff7e5ef2),
                  const Color(0xff4974D9),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedViewIndex = 0),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: size_third - 2.0,
                    height: 34.0,
                    color: _selectedViewIndex == 0 ? null : Styles.ArrivalPalletteWhite,
                    child: Icon(
                      Icons.apps,
                      size: 30.0,
                      color: _selectedViewIndex == 0 ? Styles.ArrivalPalletteWhite : Styles.ArrivalPalletteRed,
                    ),
                  ),
                ),

                Container(
                  width: 3.0,
                  height: 34.0,
                  color: Styles.transparentColor,
                ),

                GestureDetector(
                  onTap: () => setState(() => _selectedViewIndex = 1),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: size_third - 2.0,
                    height: 34.0,
                    color: _selectedViewIndex == 1 ? Styles.transparentColor : Styles.ArrivalPalletteWhite,
                    child: Icon(
                      Icons.play_arrow,
                      size: 30.0,
                      color: _selectedViewIndex == 1 ? Styles.ArrivalPalletteWhite : Styles.ArrivalPallettePurple,
                    ),
                  ),
                ),

                Container(
                  width: 3.0,
                  height: 34.0,
                  color: Styles.transparentColor,
                ),

                GestureDetector(
                  onTap: () => setState(() => _selectedViewIndex = 2),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    width: size_third - 2.0,
                    height: 34.0,
                    color: _selectedViewIndex == 2 ? Styles.transparentColor : Styles.ArrivalPalletteWhite,
                    child: Icon(
                      Icons.audiotrack,
                      size: 30.0,
                      color: _selectedViewIndex == 2 ? Styles.ArrivalPalletteWhite : Styles.ArrivalPalletteDarkBlue,
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

  Widget _buildContent(BuildContext context, AppState model) {
    if (_selectedViewIndex == 0) return UserPosts(
      userPosts,
      widget.profile.cryptlink,
      has_reached_end,
    );

    if (_selectedViewIndex == 1) return Second(widget.profile);

    return UserContact(widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    final appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);

    return Scaffold(
      body: Container(
        color: Styles.ArrivalPalletteLightGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: [
                  _buildPersonalDetails(context, appState),

                  _buildFollowButton(context, appState),

                  _buildStoryHighlights(context, appState),

                  _buildContentDisplayOptions(context, appState),

                  _buildContent(context, appState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
