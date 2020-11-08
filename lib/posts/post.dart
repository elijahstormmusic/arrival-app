/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../users/profile.dart';
import '../data/arrival.dart';
import '../data/socket.dart';

import 'page.dart';


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
  List<Map<String, dynamic>> comments;
  List<Map<String, dynamic>> client_comments = List<Map<String, dynamic>>();
  final bool full;
  final int type;
  final double height;

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
    @required this.type,
    this.height = 400,
    this.comments = const <Map<String, dynamic>>[],
    this.full = true,
  });
  Post.icon({
    @required this.cryptlink,
    @required this.cloudlink,
    @required this.userlink,
    @required this.type,
    this.height = 400,
    this.caption = 'loading...',
    this.likes = 0,
    this.views = 0,
    this.location = const {'name': '', 'lat': 0, 'lng': 0},
    this.uploadDate = null,
    this.comments = const <Map<String, dynamic>>[],
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
    type: -1,
  );

  NetworkImage card_image() {
    if (cloudlink==null)
      return NetworkImage(Post.source + 'v1599325166/sample.jpg');
    return NetworkImage(Post.source + cloudlink);
  }
  String media_href() {
    return Post.source + cloudlink;
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

    var commentList = input['short_comments'];
    var _comment_data = List<Map<String, dynamic>>();

    if (commentList!=null) {
      for (int j=0;j<commentList.length;j++) {
        commentList[j]['user'] = Profile.link(commentList[j]['userlink']);
        _comment_data.add(commentList[j]);
      }
    }

    return Post(
      caption: input['caption'],
      cryptlink: input['cryptlink'],
      cloudlink: input['cloudlink'],
      likes: input['likes'],
      views: input['views'],
      location: input['location'],
      uploadDate: DateTime.parse(input['date']),
      userlink: input['user'],
      type: input['type'],
      height: input['height'],
      comments: _comment_data,
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
      type: -1,
    );
    socket.emit('posts get', {
      'link': input,
    });
    ArrivalData.innocentAdd(ArrivalData.posts, P);
    return P;
  }
  static PostDisplayPage navigateTo(String link) {
    return PostDisplayPage(link);
  }
  static int index = 0;
}
