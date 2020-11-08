/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:video_player/video_player.dart';

class ArrivalVideoPlayer extends StatefulWidget {
  String href;

  ArrivalVideoPlayer(@required this.href);

  @override
  _VideoPState createState() => _VideoPState();
}
class _VideoPState extends State<ArrivalVideoPlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.href)
      ..initialize().then((_) {
        setState(() {});
      });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(
                height: 100,
                child: Image.asset('assets/loading/Bucket-1s-200px.gif'),
              ),
  );
}
