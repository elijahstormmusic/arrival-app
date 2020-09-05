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

class ArrivalSocket {
  SocketIO socket;
  var source, target;

  void init() {
    socket = SocketIOManager().createSocketIO(
      'https://arrival-app.herokuapp.com', '/');
    socket.init();

    socket.subscribe('message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);

      if(data['type']==800) { // icons download
        var list = data['response'];

        for(int i=0;i<list.length;i++) {
          ArrivalData.posts.add(Post.icon(
            cryptlink: list[i]['link'],
            cloudlink: list[i]['cloud'],
          ));
        }

        source.responded();
      }

      if(data['type']==801) { // post data
        Post post = Post.json(data['response'], data['user']);
        for(int i=0;i<ArrivalData.posts.length;i++) {
          if(ArrivalData.posts[i].cryptlink==post.cryptlink) {
            ArrivalData.posts[i] = post;
            break;
          }
        }

        target.responded(post);
      }

      if(data['type']==802) { // comments
        for(int i=0;i<ArrivalData.posts.length;i++) {
          if(ArrivalData.posts[i].cryptlink==data['link']) {
            // ArrivalData.posts[i].comments.add(data['comments']);
            break;
          }
        }

        target.responded();
      }

      if(data['type']==803) { // profile page download
        Profile profile = Profile.json(data['response']);

        source.responded(profile);
      }
    });

    socket.connect();
  }

  void emit(String _req, var _data) {
    socket.sendMessage(
      _req, json.encode(_data),
    );
  }
}
