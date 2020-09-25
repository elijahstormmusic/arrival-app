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
  final Profile user;
  final DateTime uploadDate;
  List<Map<String, dynamic>> comments = [];
  final bool full;

  String toString() {
    String str = '';
    str += 'caption:' + caption + ',';
    str += 'cryptlink:' + cryptlink + ',';
    str += 'cloudlink:' + cloudlink + ',';
    str += 'date:' + uploadDate.toString() + ',';
    str += 'likes:' + likes.toString() + ',';
    str += 'user:{' + user.toString() + '}';
    return str;
  }

  Post({
    @required this.caption,
    @required this.cryptlink,
    @required this.cloudlink,
    @required this.likes,
    @required this.uploadDate,
    @required this.user,
    this.full = true,
  });
  Post.icon({
    @required this.cryptlink,
    @required this.cloudlink,
    this.caption = 'loading...',
    this.likes = 0,
    this.uploadDate = null,
    this.full = false,
    this.user = null,
  });
  static final Post empty = Post(
    caption: '',
    cryptlink: '',
    cloudlink: 'v1599325166/sample.jpg',
    likes: 0,
    uploadDate: ArrivalData.default_time,
    user: Profile.empty,
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
    return Post(
      caption: input['caption'],
      cryptlink: input['cryptlink'],
      cloudlink: input['cloudlink'],
      likes: input['likes'],
      uploadDate: DateTime.parse(input['date']),
      user: Profile.lite(input['user']),
    );
  }
  static Post parse(String input) {
    if (input.substring(0, 1)=='{')
      input = input.substring(1, input.length-1);

    var caption, cryptlink, likes,
        uploadDate, cloudlink, user;

    var startDataLoc, endDataLoc = 0;

    startDataLoc = input.indexOf('caption')            + 8;
    endDataLoc = input.indexOf(',', startDataLoc);
    caption = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('likes')           + 6;
    endDataLoc = input.indexOf(',', startDataLoc);
    likes = int.parse(input.substring(startDataLoc, endDataLoc));

    startDataLoc = input.indexOf('uploadDate')      + 11;
    endDataLoc = input.indexOf(',', startDataLoc);
    uploadDate = DateTime.parse(input.substring(startDataLoc, endDataLoc));

    startDataLoc = input.indexOf('cryptlink')       + 10;
    endDataLoc = input.indexOf(',', startDataLoc);
    cryptlink = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('cloudlink')       + 10;
    endDataLoc = input.indexOf(',', startDataLoc);
    cloudlink = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('user')           + 5;
    endDataLoc = input.indexOf(',', startDataLoc);
    user = Profile.link(input.substring(startDataLoc, endDataLoc));

    return Post(
      caption: caption,
      cryptlink: cryptlink,
      cloudlink: cloudlink,
      uploadDate: uploadDate,
      likes: likes,
      user: user,
    );
  }
  static Post link(String input) {
    for (var i=0;i<ArrivalData.posts.length;i++) {
      if (ArrivalData.posts[i].cryptlink==input) {
        return ArrivalData.posts[i];
      }
    }
    var P = Post(
      caption: '',
      cryptlink: input,
      cloudlink: 'v1599325166/sample.jpg',
      likes: 0,
      uploadDate: ArrivalData.default_time,
      user: Profile.empty,
    );
    socket.emit('posts get', {
      'link': input,
    });
    ArrivalData.innocentAdd(ArrivalData.posts, P);
    return P;
  }
  static int index = 0;
}
