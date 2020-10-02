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
  static int error_report_time = 8;

  static void init() {
    _socket = SocketIOManager().createSocketIO(
      'https://arrival-app.herokuapp.com', '/');
    _socket.init();

    _socket.subscribe('message', (jsonData) async {
      Map<String, dynamic> data = json.decode(jsonData);



        /***  Content downloading
         * this functions allow for seemless use of the app
         */

      if (data['type']==900) { // for you download
        if (foryou==null) return;

        await foryou.responded(data['response']);
      }

      else if (data['type']==801) { // post data
        if (post==null) {
          await Future.delayed(const Duration(seconds: 5));
          if (post==null) {
            foryou.openSnackBar({
              'text': 'Connection error P25',
              'action': () => {
                print('closed')
              },
              'action-label': 'Close',
              'duration': 10,
            });
            return;
          }
        }
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

        var commentList = data['response'];
        var postLink = data['query']['cryptlink'];

        for (int i=0;i<ArrivalData.posts.length;i++) {
          if (ArrivalData.posts[i].cryptlink==postLink) {
            for (int j=0;j<commentList.length;j++) {
              ArrivalData.posts[i].comments.add(commentList[j]);
            }
            break;
          }
        }

        post.responded();
      }

      else if (data['type']==803) { // profile page download
        int index;

        try {
          Profile cur_profile = Profile.json(data['response']);
          for (var i=0;i<ArrivalData.profiles.length;i++) {
            if (ArrivalData.profiles[i].cryptlink==cur_profile.cryptlink) {
              index = i;
              ArrivalData.profiles[i] = cur_profile;
              break;
            }
          }
        }
        catch (e) {
          print('----------- Arrival Error ----------');
          print('connection error 803');
          print('     -> profile decoding issue');
          print('------------------------------------');
          return;
        }

        if (profile==null) return;
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

      else if (data['type']==805) { // profile posts download
        if (profile==null) return;

        List<Post> post_list = List<Post>();
        var json_list = data['response']['list'];

        for (int i=0;i<json_list.length;i++) {
          try {
            post_list.add(Post.json(json_list[i]));
          }
          catch (e) {
            print('----------- Arrival Error ----------');
            print('connection error 805');
            print('     -> post decoding issue');
            print('------------------------------------');
            return;
          }
        }

        profile.loadedPosts(post_list, data['response']['at_end']);
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
              for (var j=0;j<ArrivalData.partners[i].sales.length;j++) {
                try {
                  ArrivalData.innocentAdd(_business.sales, ArrivalData.partners[i].sales[j]);
                }
                catch (e) {
                  print('Arrival Error -- Failure adding Sales E810');
                }
            }
            ArrivalData.partners[i] = _business;
            return;
          }
        }
        ArrivalData.innocentAdd(ArrivalData.partners, _business);
      }



        /***  Userdata and Settings sync with device
         * this makes sure the server's userstate and the
         * device's userstate are always the same
         */

      else if (data['type']==600) { // client userdata download
        UserData.refreshClientData(data['response']);
      }

      else if (data['type']==601) { // updated user password
        foryou.openSnackBar({
          'text': 'Password updated.',
          'duration': socket.error_report_time,
        });
      }

      else if (data['type']==602) { // updated user email
        foryou.openSnackBar({
          'text': 'A verification email was sent to '+ data['response'] + ' and will expire in 24 hours.',
          'duration': socket.error_report_time,
        });
      }

      else if (data['type']==666) { // error with settings update
        String error_msg = '';

        if (data['code']==0) error_msg = 'Network connection error. Check your data or Wifi.';
        else if (data['code']==1) {
          if (data['error']=='password') error_msg = 'The password did not fit formatting standards.';
          if (data['error']=='pic') error_msg = 'Your picture did not fit file size standards.';
          if (data['error']=='email') error_msg = 'Your email might have been entered incorrectly.';
          if (data['error']=='verify email') error_msg = 'Your verification code was entered incorrectly.';
        }
        else if (data['code']==2) error_msg = 'Unknown error.';
        else if (data['code']==5) error_msg = 'Password not correct';
        else if (data['code']==666) {
          home.forceLogin();
          return;
        }

        foryou.openSnackBar({
          'text': error_msg,
          'duration': socket.error_report_time,
        });
      }



        /***  Server feedback
         * this functions allow for seemless use of the app
         */

      else if (data['type']==500) { // error reporting
        foryou.openSnackBar({
          'text': 'Database error ' + data['error_code'].toString(),
          'duration': error_report_time,
        });
      }
      else if (data['type']==530) { // post successfully uploaded
        foryou.openSnackBar({
          'text': 'Comment posted succesful',
          'duration': error_report_time,
        });
        ArrivalData.foryou.insert(0, RowPost(Post.link(data['link'])));
        home.gotoForyou();
        ForYouPage.scrollToTop();
      }
      else if (data['type']==531) { // post failed upload
        foryou.openSnackBar({
          'text': 'Post failed',
          'duration': error_report_time,
        });
      }
      else if (data['type']==532) { // comment made successful
        // goto comment
        foryou.openSnackBar({
          'text': 'Successful upload',
          'duration': error_report_time,
        });
      }
      else if (data['type']==533) { // comment failed upload
        foryou.openSnackBar({
          'text': 'Comment failed',
          'duration': error_report_time,
        });
      }

      // else if (data['type']==520) { // article successfully uploaded
      //   var article = Article.link(data['link']);
      //   ArrivalData.innocentAdd(ArrivalData.articles, article);
      //   ArrivalData.foryou.insert(RowArticle(article));
      //   home.gotoForyouTop();
      // }
      // else if (data['type']==521) { // article failed upload
      //   foryou.openSnackBar({
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
