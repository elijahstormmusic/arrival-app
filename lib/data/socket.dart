/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';
import '../users/data.dart';
import '../data/arrival.dart';
import '../partners/partner.dart';
import '../posts/post.dart';
import '../users/profile.dart';
import '../posts/post.dart';
import '../foryou/cards/post_card.dart';
import '../screens/home.dart';

class socket {
  static SocketIO _socket;
  static var home, post, profile, foryou, articles;
  static int error_report_time = 3;
  static String authenicator;

  static void init() {
    if (_socket!=null) return;
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
          if (post==null) return;
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

        try {
          var commentList = data['response'];
          var postLink = data['query']['cryptlink'];


          for (int i=0;i<ArrivalData.posts.length;i++) {
            if (ArrivalData.posts[i].cryptlink==postLink) {
              if (ArrivalData.posts[i].commentPage==-1) {
                ArrivalData.posts[i].comments = [];
              }

              for (int j=0;j<commentList.length;j++) {
                commentList[j]['user'] = Profile.link(commentList[j]['userlink']);
                ArrivalData.posts[i].comments.add(commentList[j]);
              }

              ArrivalData.posts[i].commentPage++;
              break;
            }
          }
        }
        catch (e)
        {
          print('''
            =======================================
                      Arrival Error #802
                $e
            =======================================
          ''');
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
          print('''
            =======================================
                      Arrival Error #803
                $e
            =======================================
          ''');
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
          foryou.refresh_state();
        }
        catch (e) {
          print('''
            =======================================
                      Arrival Error #804
                $e
            =======================================
          ''');
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
            print('''
              =======================================
                        Arrival Error #805
                  $e
              =======================================
            ''');
            return;
          }
        }

        profile.loadedPosts(post_list, data['response']['at_end']);
      }

      else if (data['type']==810) { //  single partner link downoad
        Partner _Partner;
        try {
          _Partner = Partner.json(data['response']);
        }
        catch (e) {
          print('''
            =======================================
                      Arrival Error #E810
                $e
            =======================================
          ''');
          return;
        }
        for (var i=0;i<ArrivalData.partners.length;i++) {
          if (ArrivalData.partners[i].cryptlink==_Partner.cryptlink) {
              for (var j=0;j<ArrivalData.partners[i].sales.length;j++) {
                try {
                  ArrivalData.innocentAdd(_Partner.sales, ArrivalData.partners[i].sales[j]);
                }
                catch (e) {
                  print('''
                    =======================================
                              Arrival Error #E810
                        $e
                    =======================================
                  ''');
                }
            }
            ArrivalData.partners[i] = _Partner;
            return;
          }
        }
        ArrivalData.innocentAdd(ArrivalData.partners, _Partner);
      }



        /***  Userdata and Settings sync with device
         * this makes sure the server's userstate and the
         * device's userstate are always the same
         */

      else if (data['type']==600) { // client userdata download
        UserData.refreshClientData(data['response']);
      }

      else if (data['type']==601) { // updated user password
        HomeScreen.openSnackBar({
          'text': 'Password updated.',
          'duration': socket.error_report_time,
        });
      }

      else if (data['type']==602) { // updated user email
        HomeScreen.openSnackBar({
          'text': 'A verification email was sent to '+ data['response'] + ' and will expire in 24 hours.',
          'duration': socket.error_report_time,
        });
      }

      else if (data['type']==605) { // updated user email
        switch (data['response']) {
          case 0:
            authenicator = '>' + data['link'];
            break;
          case 1:
            authenicator = 'Incorrect password';
            break;
          case 2:
            authenicator = 'That username was not found';
            break;
          case 3:
            authenicator = 'That email was not found';
            break;
          case 4:
            authenicator = 'No input sent to server';
            break;
          case 5:
            authenicator = 'User link not valid';
            break;
          case 6:
            authenicator = 'Your email was unable to be processed';
            break;

          case 10:
            authenicator = '>' + data['link'];
            break;
          case 11:
            authenicator = 'Empty inputs found';
            break;
          case 12:
            authenicator = 'Your email was unable to be processed';
            break;
          case 13:
            authenicator = 'An account with that email already exists';
            break;

          case 20:
            authenicator = 'A confirmation email was sent to that address';
            break;
          case 21:
            authenicator = 'Your email input was empty when it reached our servers';
            break;
          case 22:
            authenicator = 'Your email was unable to be processed';
            break;
          case 23:
            authenicator = 'Your email does not match any in our records';
            break;

          default:
            authenicator = 'Unknown error';
            break;
        }
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
          await UserData.refresh();
          home.forceLogin();
          return;
        }

        HomeScreen.openSnackBar({
          'text': error_msg,
          'duration': socket.error_report_time,
        });
      }



        /***  Server feedback
         * this functions allow for seemless use of the app
         */

      else if (data['type']==500) { // error reporting
        HomeScreen.openSnackBar({
          'text': 'Database error ' + data['error_code'].toString(),
          'duration': error_report_time,
        });
      }
      else if (data['type']==530) { // post successfully uploaded
        ArrivalData.posts.add(Post.link(data['link']));
        ArrivalData.foryou.insert(0, RowPost(data['link']));
      }
      else if (data['type']==531) { // post failed upload
        HomeScreen.openSnackBar({
          'text': 'Post failed',
          'duration': error_report_time,
        });
      }
      else if (data['type']==532) { // comment made successful
        // goto comment
        HomeScreen.openSnackBar({
          'text': 'Successful upload',
          'duration': error_report_time,
        });
      }
      else if (data['type']==533) { // comment failed upload
        HomeScreen.openSnackBar({
          'text': 'Comment failed',
          'duration': error_report_time,
        });
      }
    });

    _socket.connect();
  }

  static void emit(String _req, var _data) {
    if (_socket==null) return;
    _socket.sendMessage(
      _req, json.encode(_data),
    );
  }

  static void close() {
    if (_socket==null) return;
    _socket.unSubscribesAll();
    _socket.disconnect();
    SocketIOManager().destroySocket(_socket);
  }

  static Future<String> check_vaildation() async {
    authenicator = '';
    for (int i=0;i<5;i++) {
      if (authenicator!='') {
        return authenicator;
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
    return 'Our servers are dealing with high volume, please try again in a few minutes.';
  }
}
