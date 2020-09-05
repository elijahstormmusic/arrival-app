/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../users/profile.dart';

class Post {
  static final String source =
    'https://res.cloudinary.com/arrival-kc/image/upload/';

  final String caption;
  final String cryptlink;
  final String cloudlink;
  final int likes;
  final int comments;
  final Profile user;
  final bool full;

  String toString() {
    String str = '';
    str += 'caption:' + caption + ',';
    str += 'cryptlink:' + cryptlink + ',';
    str += 'cloudlink:' + cloudlink + ',';
    str += 'likes:' + likes.toString() + ',';
    str += 'comments:' + comments.toString() + ',';
    str += 'user:{' + user.toString() + '}';
    return str;
  }

  Post({
    @required this.caption,
    @required this.cryptlink,
    @required this.cloudlink,
    @required this.likes,
    @required this.comments,
    @required this.user,
    this.full = true,
  });
  Post.icon({
    @required this.cryptlink,
    @required this.cloudlink,
    this.caption = 'loading...',
    this.likes = 0,
    this.comments = 0,
    this.full = false,
    this.user = null,
  }) {}
  static final Post empty = Post(
    caption: '',
    cryptlink: '',
    cloudlink: 'v1599325166/sample.jpg',
    likes: 0,
    comments: 0,
    user: Profile.empty,
  );

  Widget image() {
    return Image.network(Post.source + cloudlink);
  }
  Widget icon() {
    return Image.network(Post.source + 'c_thumb,w_200,g_face/' + cloudlink);
  }

  static Post json(var input, var user) {
    return Post(
      caption: input['caption'],
      cryptlink: input['cryptlink'],
      cloudlink: input['cloudlink'],
      likes: input['likes'],
      comments: input['comments'],
      user: Profile.lite(
        name: user['name'],
        cryptlink: user['cryptlink'],
      ),
    );
  }
  static Post parse(String input) {
    if(input.substring(0, 1)=='{')
      input = input.substring(1, input.length-1);

    var caption, cryptlink, likes,
        cloudlink, comments, user;

    var startDataLoc, endDataLoc = 0;

    startDataLoc = input.indexOf('caption')            + 8;
    endDataLoc = input.indexOf(',', startDataLoc);
    caption = input.substring(startDataLoc, endDataLoc);

    startDataLoc = input.indexOf('likes')           + 6;
    endDataLoc = input.indexOf(',', startDataLoc);
    likes = int.parse(input.substring(startDataLoc, endDataLoc));

    startDataLoc = input.indexOf('comments')           + 9;
    endDataLoc = input.indexOf(',', startDataLoc);
    comments = int.parse(input.substring(startDataLoc, endDataLoc));

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
      likes: likes,
      comments: comments,
      user: user,
    );
  }
  static Post link(String input) {
    return Post.empty;
    // await Data.profile(input);  // still to make
    // String result = UserData.get(input);  // still to make
    // return Post.parse(result);
  }
}
