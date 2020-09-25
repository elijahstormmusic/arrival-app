/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
// import 'package:video_player/video_player.dart';
import '../adobe/pinned.dart';

import '../data/app_state.dart';
import '../styles.dart';
import '../posts/post.dart';
import '../users/profile.dart';
import '../users/page.dart';
import '../users/data.dart';
import '../data/arrival.dart';
import '../data/socket.dart';
import 'dart:async';


// class VideoPlayerApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Player Demo',
//       home: VideoPlayerScreen(),
//     );
//   }
// }
//
// class VideoPlayerScreen extends StatefulWidget {
//   VideoPlayerScreen({Key key}) : super(key: key);
//
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   VideoPlayerController _controller;
//   Future<void> _initializeVideoPlayerFuture;
//
//   @override
//   void initState() {
//     // Create and store the VideoPlayerController. The VideoPlayerController
//     // offers several different constructors to play videos from assets, files,
//     // or the internet.
//     _controller = VideoPlayerController.network(
//       'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
//     );
//
//     // Initialize the controller and store the Future for later use.
//     _initializeVideoPlayerFuture = _controller.initialize();
//
//     // Use the controller to loop the video.
//     _controller.setLooping(true);
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // Ensure disposing of the VideoPlayerController to free up resources.
//     _controller.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Butterfly Video'),
//       ),
//       // Use a FutureBuilder to display a loading spinner while waiting for the
//       // VideoPlayerController to finish initializing.
//       body: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If the VideoPlayerController has finished initialization, use
//             // the data it provides to limit the aspect ratio of the video.
//             return AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               // Use the VideoPlayer widget to display the video.
//               child: VideoPlayer(_controller),
//             );
//           } else {
//             // If the VideoPlayerController is still initializing, show a
//             // loading spinner.
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Wrap the play or pause in a call to `setState`. This ensures the
//           // correct icon is shown.
//           setState(() {
//             // If the video is playing, pause it.
//             if (_controller.value.isPlaying) {
//               _controller.pause();
//             } else {
//               // If the video is paused, play it.
//               _controller.play();
//             }
//           });
//         },
//         // Display the correct icon depending on the state of the player.
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }


class PostDisplayPage extends StatefulWidget {
  int postIndex;

  PostDisplayPage(String _cryptlink) {
    for (int i=0;i<ArrivalData.posts.length;i++) {
      if (ArrivalData.posts[i].cryptlink==_cryptlink) {
        this.postIndex = i;
        break;
      }
    }
  }

  @override
  _PostDisPState createState() => _PostDisPState();
}

class _PostDisPState extends State<PostDisplayPage> {
  bool response = false;
  bool loaded = false;
  bool _commentsPageOpen = false;
  bool _clientHasLikedPost = false;
  final _padding = 7.0;
  final _lineSize = 3.0;
  double _buttonSize = 35.0;
  int _page = 0;
  ScrollController _scrollController;
  final _textInputController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    socket.post = this;
    socket.emit('posts get comments', {
      'link': ArrivalData.posts[widget.postIndex].cryptlink,
      'page': _page,
    });
    _scrollController = ScrollController();
    _textInputController.addListener(_onTextChanged);
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void responded() {
    setState(() => loaded = true);
  }

  TextStyle _usernameTextStyle = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  String _addPluralS(int amount) {
    if (amount>1) return 's';
    return '';
  }
  Widget _buildLikesDisplay() {
    int currentLikes =
      ArrivalData.posts[widget.postIndex].likes + (_clientHasLikedPost ? 1 : 0);
    int commentAmt = ArrivalData.posts[widget.postIndex].comments.length;

    return Text.rich(
      TextSpan(
        style: Styles.postText,
        children: [
            TextSpan(
            text:
              (currentLikes==0) ? '' :
              currentLikes.toString() + ' like' + _addPluralS(currentLikes),
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text:
              commentAmt==0 ? '' :
                ((currentLikes==0 ? '' : ' & ')
                  + commentAmt.toString()
                  + ' comment' + _addPluralS(commentAmt)),
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
  Widget _buildComment(Map<String, dynamic> _comment) {
    if(_comment==null) return Container();
    return Text.rich(
      TextSpan(
        style: Styles.postText,
        children: [
          TextSpan(
            text: _comment['username']
            + '  ',
            style: _usernameTextStyle,
          ),
          TextSpan(text: '  ' + _comment['content']),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
  Widget _buildCaption() {
    return _buildComment({
      'username': ArrivalData.posts[widget.postIndex].user==null
                    ? 'no user'
                    : ArrivalData.posts[widget.postIndex].user.name,
      'content': ArrivalData.posts[widget.postIndex].caption,
    });
  }
  Widget _buildShortCommentList(List<Map<String, dynamic>> commentsList) {
    int maxShortDisplay = 3;

    return Container(
      height: 100,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: commentsList.length<maxShortDisplay ? commentsList.length : maxShortDisplay,
        itemBuilder: (context, index) => _buildComment(commentsList[index]),
      ),
    );
  }

  void _openCommentsPage(BuildContext context) {
    setState(() => _commentsPageOpen = true);
  }
  void _loadMore() {
    socket.emit('posts get comments', {
      'link': ArrivalData.posts[widget.postIndex].cryptlink,
      'page': ++_page,
    });
  }
  void _loadReplies(String reply_index) {
    socket.emit('posts get comments', {
      'link': ArrivalData.posts[widget.postIndex].cryptlink,
      'page': _page,
      'reply': reply_index,
    });
  }

  Widget _drawSupportingElements(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Icon(
                  _clientHasLikedPost
                    ? Styles.heart_full
                    : Styles.heart,
                  color: _clientHasLikedPost
                    ? Colors.red
                    : Colors.black,
                  size: _buttonSize,
                ),
                onTap: () => setState(() =>
                  _clientHasLikedPost = !_clientHasLikedPost),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Icon(
                  Styles.comment,
                  size: _buttonSize,
                  color: Colors.black,
                ),
                onTap: () => setState(() => _focusNode.requestFocus()),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Icon(
                  Styles.share,
                  size: _buttonSize,
                  color: Colors.black,
                ),
                onTap: () => setState(() => _focusNode.requestFocus()),
              ),
            ),
          ],
        ),
        SizedBox(height: _padding),
        (ArrivalData.posts[widget.postIndex].likes==0
          && ArrivalData.posts[widget.postIndex].comments.length==0)
          ? Container()
          : _buildLikesDisplay(),
        SizedBox(height: _padding),
        _buildCaption(),
        SizedBox(height: _padding*2),
        _buildShortCommentList(ArrivalData.posts[widget.postIndex].comments),
        GestureDetector(
          onTap: () => _openCommentsPage(context),
          child: Container(
            height: 50,
            child: Text.rich(
              TextSpan(
                style: Styles.postText,
                children: [
                  TextSpan(
                    text: 'Show all comments...',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        _buildCommentAdder(),
      ],
    );
  }
  Widget _profileDisplay(Profile user) {
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

  String _showTimeSinceDate(DateTime date) {
    Duration timeSince = DateTime.now().difference(date);
    String output = 'just now';

    if (timeSince.inDays==0) {
      if (timeSince.inHours==0) {
          if (timeSince.inMinutes==0) {
            output = timeSince.inSeconds.toString() + ' second';
            if (timeSince.inSeconds>1) output+='s';
            output+=' ago';
          } else {
            output = timeSince.inMinutes.toString() + ' minute';
            if (timeSince.inMinutes>1) output+='s';
            output+=' ago';
          }
      } else {
        output = timeSince.inHours.toString() + ' hour';
        if (timeSince.inHours>1) output+='s';
        output+=' ago';
      }
    }
    else {
      if (timeSince.inDays>=365) {
        int years = timeSince.inDays ~/ 365;
        output = years.toString() + ' year';
        if (years>1) output+='s';
        output+=' ago';
      } else if (timeSince.inDays>=29) {
        int months = timeSince.inDays ~/ 30;
        output = months.toString() + ' month';
        if (months>1) output+='s';
        output+=' ago';
      } else {
        output = timeSince.inDays.toString() + ' day';
        if (timeSince.inDays>1) output+='s';
        output+=' ago';
      }
    }

    return output;
  }
  Widget _buildCommentsList(List<Map<String, dynamic>> commentsList) {
    double _commonCommentPadding = 10;
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      itemCount: commentsList.length + 1,
      itemBuilder: (context, index) {
        return index==0
          ? Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(_commonCommentPadding),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9999.0),
                          child: Profile.empty.iconBySize(35.0),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.all(_commonCommentPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCaption(),
                            Text(
                              _showTimeSinceDate(ArrivalData.posts[widget.postIndex].uploadDate),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              Divider(height: 1.0, thickness: 1.0),
            ],
          )
          : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(_commonCommentPadding),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9999.0),
                      child: Profile.empty.iconBySize(35.0),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.all(_commonCommentPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildComment(commentsList[index - 1]),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                _showTimeSinceDate(DateTime.parse(commentsList[index - 1]['date'])),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                commentsList[index - 1]['votes'].toString() + ' likes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'reply',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(_commonCommentPadding),
                    child: Icon(Styles.heart),
                  ),
                ),
              ],
            ),
          );
      },
      controller: _scrollController,
    );
  }
  Widget _buildCommentsScreen(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Back',
      ),
      child: _buildCommentsList(ArrivalData.posts[widget.postIndex].comments),
    );
  }

  Widget _buildCommentAdder() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Styles.ArrivalPalletteWhite,
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Styles.ArrivalPalletteBlack),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: CupertinoTextField(
                  controller: _textInputController,
                  focusNode: _focusNode,
                  decoration: null,
                  // selectionHeightStyle: BoxHeightStyle.includeLineSpacingTop,
                  style: TextStyle(
                    fontSize: 22,
                    color: Styles.ArrivalPalletteBlack,
                  ),
                  cursorColor: Styles.searchCursorColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: _sendCommentToServer,
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
    );
  }
  bool _allowComment = true;
  void _sendCommentToServer() async {
    if (!_allowComment) return;

    var cleanedComment = _textInputController.text;

    if (cleanedComment=='') return;

    _allowComment = false;
    socket.emit('posts add comment', {
			'cryptlink': UserData.client.cryptlink,
			'username': UserData.client.name,
  		'content': cleanedComment,
      'link': ArrivalData.posts[widget.postIndex].cryptlink,
    });

    await Future.delayed(const Duration(seconds: 5));
    _allowComment = true;
  }
  void _onTextChanged() {
    if (true) return; // check if @ing someone and suggest
    setState(() => 3);
  }

  @override
  Widget build(BuildContext context) {
    final appState = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    final themeData = CupertinoTheme.of(context);

    if (_commentsPageOpen) return _buildCommentsScreen(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Back',
      ),
      child: widget.postIndex!=null
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: [
                  _profileDisplay(
                    (ArrivalData.posts[widget.postIndex].user==null)
                      ? Profile.empty
                      : ArrivalData.posts[widget.postIndex].user
                  ),
                  Divider(height: _lineSize, thickness: _lineSize),
                  ArrivalData.posts[widget.postIndex].image(),
                  loaded
                    ? Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                      child: Container(
                        height: 320.0,
                        child: _drawSupportingElements(context),
                      ),
                    )
                    : Padding(
                      padding: EdgeInsets.fromLTRB(32, 48, 32, 12),
                      child: Loading(
                        indicator: BallPulseIndicator(),
                        size: 16.0,
                        color: Styles.ArrivalPalletteGrey,
                      ),
                    )
                  ,
                ],
              ),
            ),
          ],
        )
        : Styles.ArrivalErrorPage(context, '4PpA'),
    );
  }
}
