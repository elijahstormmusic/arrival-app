/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';
import '../users/data.dart';
import '../data/arrival.dart';
import '../data/cards/partners.dart';
import '../posts/post.dart';
import '../users/profile.dart';
import '../posts/post.dart';
import '../foryou/post_card.dart';
import '../foryou/list.dart';

class socket {
  static SocketIO _socket;
  static var home, post, profile, foryou;

  static void init() {
    _socket = SocketIOManager().createSocketIO(
      'https://arrival-app.herokuapp.com', '/');
    _socket.init();

    _socket.subscribe('message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);


        /***  Content downloading
         * this functions allow for seemless use of the app
         */

      if (data['type']==900) { // for you download
        if (foryou==null) return;

        foryou.responded(data['response']);
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

        int index;

        try {
          Profile profile = Profile.json(data['response']);
          for (var i=0;i<ArrivalData.profiles.length;i++) {
            if (ArrivalData.profiles[i].cryptlink==profile.cryptlink) {
              index = i;
              ArrivalData.profiles[i] = profile;
              break;
            }
          }
        }
        catch (e) {
          print('arrival connection error 803');
          profile.responded(index);
          return;
        }

        profile.responded(index);
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

      else if (data['type']==810) { //  single partner link downoad
        Business _business;
        try {
          _business = Business.json(data['response']);
        }
        catch (e) {
          print('Arrival Error -- Failure parsing Business E810');
          return;
        }
        for (var i=0;i<ArrivalData.partners.length;i++) {
          if (ArrivalData.partners[i].cryptlink==_business.cryptlink) {
            try {
              for (var j=0;j<ArrivalData.partners[i].sales.length;j++) {
                _business.sales.add(ArrivalData.partners[i].sales[j]);
              }
            }
            catch (e) {
              print('Arrival Error -- Failure adding Sales E810');
            }
            ArrivalData.partners[i] = _business;
            return;
          }
        }
        ArrivalData.partners.add(_business);
      }



        /***  Server feedback
         * this functions allow for seemless use of the app
         */

      else if (data['type']==500) { // error reporting
        home.openSnackBar({
          'text': 'Arrival Socket error: ' + data['error_code'].toString(),
        });
      }
      else if (data['type']==530) { // post successfully uploaded
        foryou.insert(RowPost(Post.link(data['link'])));
        home.gotoForyou();
        ForYouPage.scrollToTop();
      }
      else if (data['type']==531) { // post failed upload
        home.openSnackBar({
          'text': 'Post failed to upload',
          'action': 'RETRY',
          'function': () => 3,
        });
      }
      // else if (data['type']==520) { // article successfully uploaded
      //   var article = Article.link(data['link']);
      //   ArrivalData.articles.add(article);
      //   ArrivalData.foryou.insert(RowArticle(article));
      //   home.gotoForyouTop();
      // }
      // else if (data['type']==521) { // article failed upload
      //   home.openSnackBar({
      //     'text': 'Your article failed to upload',
      //     'action': 'RETRY',
      //     'function': () => 3,
      //   });
      // }
    });

    _socket.connect();
  }

  static void emit(String _req, var _data) {
    _socket.sendMessage(
      _req, json.encode(_data),
    );
  }
}
