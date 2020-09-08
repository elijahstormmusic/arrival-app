/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';
import '../users/data.dart';
import '../data/arrival.dart';
import '../posts/post.dart';
import '../users/profile.dart';

class socket {
  static SocketIO _socket;
  static var search, post, foryou;

  static void init() {
    _socket = SocketIOManager().createSocketIO(
      'https://arrival-app.herokuapp.com', '/');
    _socket.init();

    _socket.subscribe('message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);

      if(data['type']==800) { // icons download
        var list = data['response'];

        for(int i=0;i<list.length;i++) {
          ArrivalData.posts.add(Post.icon(
            cryptlink: list[i]['link'],
            cloudlink: list[i]['cloud'],
          ));
        }

        search.responded();
      }

      if(data['type']==801) { // post data
        Post postData = Post.json(data['response'], data['user']);
        for(int i=0;i<ArrivalData.posts.length;i++) {
          if(ArrivalData.posts[i].cryptlink==postData.cryptlink) {
            ArrivalData.posts[i] = postData;
            break;
          }
        }

        post.responded(postData);
      }

      if(data['type']==802) { // comments
        for(int i=0;i<ArrivalData.posts.length;i++) {
          if(ArrivalData.posts[i].cryptlink==data['link']) {
            // ArrivalData.posts[i].comments.add(data['comments']);
            break;
          }
        }

        post.responded();
      }

      if(data['type']==803) { // profile page download
        Profile profile = Profile.json(data['response']);

        search.responded(profile);
      }

      if(data['type']==900) { // for you download
        foryou.responded(data['response']);
      }
    });

    _socket.connect();
  }

  static void emit(String _req, var _data) {
    _socket.sendMessage(
      _req, json.encode(_data),
    );
  }
}
