/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../styles.dart';


class ArrivalVideoPlayer extends StatefulWidget {
  String href;
  double height;

  ArrivalVideoPlayer(@required this.href, @required this.height);

  @override
  _VideoPState createState() => _VideoPState();
}
class _VideoPState extends State<ArrivalVideoPlayer> {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.href)
      ..initialize().then((_) {
        setState(() => _showPaused());
      });

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      looping: true,
      allowFullScreen: false,
      showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Styles.ArrivalPalletteWhite,
      ),
      autoInitialize: true,
    );

    _playPauseIconFadeTime = _maxFadeTime;
  }
  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  bool _isPlaying = false;
  int _maxFadeTime = 500, _minFadeTime = 25;
  int _playPauseIconFadeTime;
  var _playPauseIcon = Icons.pause;
  bool _visible = false;
  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showPaused();
      } else {
        _controller.play();
        _showPlaying();
      }
    });
  }
  void _showPlaying() async {
    _playPauseIconFadeTime = _minFadeTime;
    _playPauseIcon = Icons.play_circle_filled;
    setState(() => _visible = true);

    await Future.delayed(const Duration(milliseconds: 500));

    _playPauseIconFadeTime = _maxFadeTime;
    setState(() => _visible = false);
  }
  void _showPaused() async {
    _playPauseIconFadeTime = _minFadeTime;
    _playPauseIcon = Icons.pause_circle_filled;
    setState(() => _visible = true);

    await Future.delayed(const Duration(milliseconds: 500));

    _playPauseIconFadeTime = _maxFadeTime;
    setState(() => _visible = false);
  }

  void scrollIntoView() {
    setState(() {
      _controller.play();
      // _showPlaying();
    });
  }
  void scrollOutOfView() {
    setState(() {
      _controller.pause();
      // _showPaused();
    });
  }

  @override
  Widget build(BuildContext context) => Container(
    child: _controller.value.initialized
              ? GestureDetector(
                onTap: _togglePlayPause,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: widget.height,
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Chewie(
                            controller: _chewieController,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: AnimatedOpacity(
                        opacity: _visible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: _playPauseIconFadeTime),
                        child: Container(
                          child: Icon(
                            _playPauseIcon,
                            color: Styles.ArrivalPalletteRed,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : Container(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: Image.asset('assets/loading/Bucket-1s-200px.gif'),
                    ),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
  );
}
