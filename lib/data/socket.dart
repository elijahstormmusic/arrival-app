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
  static var search, post, profile, foryou;

  static void init() {
    _socket = SocketIOManager().createSocketIO(
      'https://arrival-app.herokuapp.com', '/');
    _socket.init();

    _socket.subscribe('message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);

      if (data['type']==800) { // icons download
        if (search==null) return;
        var list = data['response'];

        try {
          for (int i=0;i<list.length;i++) {
            ArrivalData.posts.add(Post.icon(
              cryptlink: list[i]['link'],
              cloudlink: list[i]['cloud'],
            ));
          }
        }
        catch (e) {
          print('arrival connection error 800');
          search.responded([]);
          return;
        }

        search.responded(data['response']);
      }

      else if (data['type']==801) { // post data
        if (post==null) return;

        Post postData = Post.json(data['response']);
        for (int i=0;i<ArrivalData.posts.length;i++) {
          if (ArrivalData.posts[i].cryptlink==postData.cryptlink) {
            ArrivalData.posts[i] = postData;
            break;
          }
        }

        post.responded();
      }

      else if (data['type']==802) { // comments
        if (post==null) return;

        for (int i=0;i<ArrivalData.posts.length;i++) {
          if (ArrivalData.posts[i].cryptlink==data['link']) {
            // ArrivalData.posts[i].comments.add(data['comments']);
            break;
          }
        }

        post.responded();
      }

      else if (data['type']==803) { // profile page download
        if (profile==null) return;

        try {
          Profile profile = Profile.json(data['response']);
          for (var i=0;i<ArrivalData.profiles.length;i++) {
            if (ArrivalData.profiles[i].cryptlink==profile.cryptlink) {
              ArrivalData.profiles[i] = profile;
              break;
            }
          }
        }
        catch (e) {
          print('arrival connection error 803');
          profile.responded(null);
          return;
        }

        profile.responded(profile);
      }

      else if (data['type']==804) { // lite profile
        try {
          Profile profile = Profile.litejson(data['response']);
          for (var i=0;i<ArrivalData.profiles.length;i++) {
            if (ArrivalData.profiles[i].cryptlink==profile.cryptlink) {
              if (ArrivalData.profiles[i].name=='') {
                ArrivalData.profiles[i] = profile;
              }
              break;
            }
          }
        }
        catch (e) {
          print('arrival connection error 804');
          return;
        }
      }

      else if (data['type']==900) { // for you download
        if (foryou==null) return;

        foryou.responded(data['response']);
      }

      else if (data['type']==500) { // error reporting
        print('Arrival Socket error: ' + data['error_code'].toString());
        // make popup here
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
