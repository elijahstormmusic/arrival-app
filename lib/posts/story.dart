/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/link.dart';
import '../data/socket.dart';
import '../users/data.dart';
import '../users/page.dart';
import '../users/profile.dart';
import '../styles.dart';
import '../const.dart';

import 'story_upload.dart';


class Story {
  static final String source =
    Constants.media_source;

  final String cryptlink;
  final String icon;
  final String name;
  final List<StoryContent> content;
  bool seen = false;

  Story({
    @required this.cryptlink,
    @required this.icon,
    @required this.name,
    @required this.content,
  });

  static Story json(Map<String, dynamic> data) {

    List<StoryContent> content = <StoryContent>[];

    for (int i=0;i<data['content'].length;i++) {
      content.add(StoryContent.json(data['content'][i]));
    }

    return Story(
      cryptlink: data['link'],
      icon: source + data['icon'],
      name: data['name'],
      content: content,
    );
  }


  static final Story TestData = Story.json({
    'content': [
      {
        'media': 'v1599325166/sample.jpg',
        'time': 3,
        'user': UserData.client.cryptlink,
      },
      {
        'media': 'v1599325166/sample.jpg',
        'time': 5,
        'user': UserData.client.cryptlink,
      },
      {
        'media': 'v1599325166/sample.jpg',
        'time': 9,
        'user': UserData.client.cryptlink,
      },
    ],
    'link': 'linktest',
    'name': 'storytest',
    'icon': 'v1599325166/sample.jpg',
  });
}

class StoryContent {

  final Profile user;
  final String media;
  final int time;

  StoryContent({
    @required this.user,
    @required this.media,
    @required this.time,
  });

  static StoryContent json(Map<String, dynamic> data) {

    return StoryContent(
      user: Profile.link(data['user']),
      media: Story.source + data['media'],
      time: data['time'],
    );
  }
}


class StoryDisplay extends StatefulWidget {
  Story story;

  StoryDisplay(this.story);

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<StoryDisplay> {
  int index = 0;
  bool closing = false;
  StoryContent _currentContent;

  @override
  void initState() {
    super.initState();

    _exchange(widget.story.content[index]);
  }

  bool _gotoNext = false, _gotoBack = false;
  bool _responsePopup = false;
  void next() {
    play();
    _gotoNext = true;
  }
  void back() {
    play();
    _gotoBack = true;
  }
  void exit() {
    Navigator.of(context).pop();
  }
  void startAction() {
    if (_currentContent.user==UserData.client) return;

    pause();
    if (mounted) setState(() => _responsePopup = true);
  }
  void finishedAction() {
    play();
    if (mounted) setState(() => _responsePopup = false);
  }

  void _onTapUp(var details) {
    if (details.globalPosition.dx / MediaQuery.of(context).size.width > .2) {
      next();
    }
    else {
      back();
    }
  }

  void _callSlideDown() {
    exit();
  }
  void _callSlideUp() {
    startAction();
  }
  void _callSlideRight() {
    next();
  }
  void _callSlideLeft() {
    back();
  }

  double _startDragY, _startDragX, _dragDeadzone = 15;
  bool _doneDragAction = false;
  void _onDragStart(var details) {
    _startDragY = details.globalPosition.dy;
    _startDragX = details.globalPosition.dx;
    _doneDragAction = false;
  }
  void _onVerticalDragUpdate(var details) {
    if (_doneDragAction) return;
    if (details.globalPosition.dy > _startDragY + _dragDeadzone) { // down
      _callSlideDown();
      _doneDragAction = true;
    }
    else if (details.globalPosition.dy < _startDragY - _dragDeadzone) { // up
      _callSlideUp();
      _doneDragAction = true;
    }
  }
  void _onHorizontalDragUpdate(var details) {
    if (_doneDragAction) return;
    if (details.globalPosition.dx > _startDragX + _dragDeadzone) { // right
      _callSlideRight();
      _doneDragAction = true;
    }
    else if (details.globalPosition.dx < _startDragX - _dragDeadzone) { // left
      _callSlideLeft();
      _doneDragAction = true;
    }
  }


  double _progressDestination;
  bool _kill, _paused;
  double _increment;
  final int _redrawTime = 10;

  void _exchange(StoryContent content) {
    _kill = false;
    _paused = false;
    _currentContent = content;
    _increment = 1.0 / (_currentContent.time * 100.0);

    if (!mounted) return;
    setState(() => _progressDestination = 0);

    _loopAndCheckState();
  }

  void _loopAndCheckState() async {
    if (_kill) return;

    await Future.delayed(Duration(milliseconds: _redrawTime));

    if (_gotoNext || _progressDestination >= .99) {
      _gotoNext = false;

      if (index + 1 >= widget.story.content.length) {
        closing = true;
        exit();
        return;
      }

      if (!mounted) return;
      _exchange(widget.story.content[++index]);
      return;
    }
    if (_gotoBack) {
      _gotoBack = false;

      if (index > 0) {
        if (!mounted) return;
        _exchange(widget.story.content[--index]);

        return;
      }
    }

    if (_paused) {
      _loopAndCheckState();
      return;
    }

    if (!mounted) return;
    setState(() => _progressDestination += _increment);

    _loopAndCheckState();
  }

  void pause() {
    _paused = true;
  }
  void play() {
    _paused = false;
  }
  void kill() {
    _kill = true;
  }

  Widget _drawTimeline() {

    return AnimatedContainer(
      duration: Duration(milliseconds: _redrawTime),
      curve: Curves.ease,
      height: 10.0,
      width: _progressDestination * MediaQuery.of(context).size.width,
      color: Styles.ArrivalPalletteRedTransparent,
    );
  }


  String _replyText = '';
  void _changeReply(String value) {
    _replyText = value;
  }
  void _sendReplyToServer() {
    print(_replyText);
    if (_replyText != '') socket.emit('message create if new', {
      'sender': UserData.client.cryptlink,
      'reciever': _currentContent.user,
      'content': _replyText,
    });

    _replyText = '';
    finishedAction();
  }

  Widget _drawPopup() {
    return GestureDetector(
      onTap: () => finishedAction(),
      child: Container(
        width: _responsePopup ? MediaQuery.of(context).size.width : 0,
        height: _responsePopup ? MediaQuery.of(context).size.height : 0,
        color: Styles.ArrivalPalletteGreyTransparent,
        padding: EdgeInsets.all(32.0),
        child: _responsePopup ? Center(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Styles.ArrivalPalletteBlackTransparent,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            padding: EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                      child: TextField(
                        onChanged: (value) => _changeReply(value),
                        minLines: 1,
                        maxLines: 3,
                        onSubmitted: (input) {
                          _changeReply(input);
                          _sendReplyToServer();
                        },
                        maxLength: 500,
                        decoration: InputDecoration(
                          labelText: 'React!',
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          color: Styles.ArrivalPalletteBlack,
                        ),
                        cursorColor: Styles.searchCursorColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendReplyToServer,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Styles.ArrivalPalletteRed,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          'SEND',
                          style: TextStyle(
                            fontSize: 16,
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
        ) : Container(),
      ),
    );
  }


  Widget _drawCurrentContent() {
    if (closing) return Container();

    if (_currentContent == null) return Container();

    return SafeArea(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Styles.ArrivalPalletteBlack,
            child: Image.network(
              _currentContent.media,
              fit: BoxFit.cover,
            ),
          ),

          Container(
            margin: EdgeInsets.all(14.0),
            height: 26,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Arrival.navigator.currentState.push(MaterialPageRoute(
                    builder: (context) => _currentContent.user.navigateTo(),
                    fullscreenDialog: true,
                  )),
                  child: CircleAvatar(
                    radius: 16.0,
                    backgroundImage: NetworkImage(_currentContent.user.media_href()),
                  ),
                ),
                SizedBox(width: 8.0),
                _currentContent.user.clickable_name(
                  color: Styles.ArrivalPalletteWhite,
                  size: 18.0,
                ),
              ],
            ),
          ),

          _drawTimeline(),

          _drawPopup(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapUp: (details) => _onTapUp(details),
        onTapDown: (_) => pause(),
        onLongPressEnd: (_) => play(),
        onVerticalDragStart: (details) => _onDragStart(details),
        onHorizontalDragStart: (details) => _onDragStart(details),
        onVerticalDragUpdate: (details) => _onVerticalDragUpdate(details),
        onHorizontalDragUpdate: (details) => _onHorizontalDragUpdate(details),
        child: _drawCurrentContent(),
      ),
    );
  }
}
