/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../users/profile.dart';
import '../data/arrival.dart';
import '../data/socket.dart';


class Post {
  static final String source =
    'https://res.cloudinary.com/arrival-kc/image/upload/';

  final String caption;
  final String cryptlink;
  final String cloudlink;
  final int likes;
  final int views;
  final Map<String, dynamic> location;
  String userlink;
  final DateTime uploadDate;
  int commentPage = -1;
  List<Map<String, dynamic>> comments = [];
  final bool full;

  Profile get user {
    if (userlink=='') {
      int _newPostIndex =
        ArrivalData.posts.indexWhere((v) => v.cryptlink==cryptlink);
      userlink = ArrivalData.posts[_newPostIndex].userlink;
    }
    int _index = ArrivalData.profiles.indexWhere((v) => v.cryptlink==userlink);
    if (_index==-1) return ArrivalData.profiles[0];
    return ArrivalData.profiles[_index];
  }

  Post({
    @required this.caption,
    @required this.cryptlink,
    @required this.cloudlink,
    @required this.likes,
    @required this.views,
    @required this.location,
    @required this.uploadDate,
    @required this.userlink,
    this.full = true,
  });
  Post.icon({
    @required this.cryptlink,
    @required this.cloudlink,
    @required this.userlink,
    this.caption = 'loading...',
    this.likes = 0,
    this.views = 0,
    this.location = const {'name': '', 'lat': 0, 'lng': 0},
    this.uploadDate = null,
    this.full = false,
  });
  static final Post empty = Post(
    caption: '',
    cryptlink: '',
    cloudlink: 'v1599325166/sample.jpg',
    likes: 0,
    views: 0,
    location: {'name': '', 'lat': 0, 'lng': 0},
    uploadDate: ArrivalData.default_time,
  );

  NetworkImage card_image() {
    if (cloudlink==null)
      return NetworkImage(Post.source + 'v1599325166/sample.jpg');
    return NetworkImage(Post.source + cloudlink);
  }
  Widget image() {
    return Image.network(
      Post.source + cloudlink,
      fit: BoxFit.fitWidth,
    );
  }
  Widget icon() {
    return Image.network(
      Post.source + 'c_thumb,w_200,g_face/' + cloudlink,
      fit: BoxFit.fitWidth,
    );
  }

  static Post json(var input) {
    Profile.lite(input['user']);
    return Post(
      caption: input['caption'],
      cryptlink: input['cryptlink'],
      cloudlink: input['cloudlink'],
      likes: input['likes'],
      views: input['views'],
      location: input['location'],
      uploadDate: DateTime.parse(input['date']),
      userlink: input['user'],
    );
  }
  static Post link(String input) {
    for (int i=0;i<ArrivalData.posts.length;i++) {
      if (ArrivalData.posts[i].cryptlink==input) {
        return ArrivalData.posts[i];
      }
    }
    Post P = Post(
      caption: '',
      cryptlink: input,
      cloudlink: 'v1599325166/sample.jpg',
      likes: 0,
      views: 0,
      location: {'name': '', 'lat': 0, 'lng': 0},
      uploadDate: ArrivalData.default_time,
      userlink: '',
    );
    socket.emit('posts get', {
      'link': input,
    });
    ArrivalData.innocentAdd(ArrivalData.posts, P);
    return P;
  }
  static int index = 0;
}
