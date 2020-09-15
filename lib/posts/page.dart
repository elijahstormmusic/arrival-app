/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../adobe/pinned.dart';

import '../data/app_state.dart';
import '../styles.dart';
import '../widgets/close_button.dart';
import '../posts/post.dart';
import '../users/profile.dart';
import '../users/page.dart';
import '../data/socket.dart';
import 'dart:async';


class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Butterfly Video'),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class PostDisplayPage extends StatefulWidget {
  Post post;

  PostDisplayPage(Post _p) {
    this.post = _p;
    socket.post = this;
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
