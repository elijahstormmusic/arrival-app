/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../users/data.dart';
import '../data/arrival.dart';
import '../partners/partner.dart';
import '../posts/post.dart';
import '../users/profile.dart';
import '../posts/post.dart';
import '../foryou/foryou.dart';
import '../screens/home.dart';
import '../const.dart';

class socket {
  static IO.Socket _socket;
  static var home, post, profile, chatlist;
  static var delivery, search;
  static int error_report_time = 3;
  static String authenicator;
  static bool active = false;
  static List<Map<String, dynamic>> call_queue = List<Map<String, dynamic>>();
  static bool attempting_to_execute_queue = false;

  static void init() {
    if (_socket!=null) return;

    _socket = IO.io(Constants.site, <dynamic, dynamic>{
      'transports': ['websocket'],
    });

    _socket.on('message', (data) async {

        /***  Content downloading
         * these functions allow for seemless use of the app
         */

      if (data['type']==900) { // for you download
        if (delivery==null) return;

        await delivery.response(data['response']);
      }

      else if (data['type']==310) { // search content
        if (search==null) return;

        await search.response(data['response']);
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

      else if (data['type']==810) { // single partner link downoad
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

      else if (data['type']==840) { // chatlist download
        if (chatlist==null) return;

        chatlist.loadData(data['response']);
      }



        /***  Userdata and Settings sync with device
         * these make sure the server's userstate and the
         * device's userstate are always the same
         */

      else if (data['type']==600) { // client userdata download
        UserData.refreshClientData(data['response']);
      }

      else if (data['type']==601) { // updated user password
        HomeScreen.openSnackBar({
          'text': 'Password updated.',
          'duration': error_report_time,
        });
      }

      else if (data['type']==602) { // updated user email
        HomeScreen.openSnackBar({
          'text': 'A verification email was sent to '+ data['response'] + ' and will expire in 24 hours.',
          'duration': error_report_time,
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
          'duration': error_report_time,
        });
      }



        /***  Server feedback
         * these handle background confirmation from the server
         * of a message's success and the user's actions taken
         */

      else if (data['type']==500) { // error reporting
        HomeScreen.openSnackBar({
          'text': 'Database error ' + data['error_code'].toString(),
          'duration': error_report_time,
        });
      }
      else if (data['type']==530) { // post successfully uploaded
        Post.link(data['link']);
        ForYouPage.scrollToTop();
        ForYouPage.displayUploadingMediaProgress(data['id'], data['link']);
      }
      else if (data['type']==531) { // post failed upload
        HomeScreen.openSnackBar({
          'text': 'Post failed',
          'duration': error_report_time,
        });
      }
      else if (data['type']==532) { // comment made successful
        // goto comment
        // HomeScreen.openSnackBar({
        //   'text': 'Successful upload',
        //   'duration': error_report_time,
        // });
      }
      else if (data['type']==533) { // comment failed upload
        HomeScreen.openSnackBar({
          'text': 'Comment failed',
          'duration': error_report_time,
        });
      }



        /** Socket <-> Server connection confirmation */

      else if (data['type']==1) { // connection test verification
        active = true;
        failed_queue_attempts = 0;
      }
    });
  }

  static void close() {
    if (_socket==null) return;
    _socket.dispose();
  }

  static _StreamSocket stream(String namespace) {
    return _StreamSocket(namespace);
  }

  static int failed_queue_attempts = 0;
  static void execute_queue() async {
    if (call_queue.length==0) return;

    attempting_to_execute_queue = true;

    if (!active) {
      if (++failed_queue_attempts % 10 == 0) {
        _socket.emit(
          call_queue[0]['request'], call_queue[0]['data'],
        );
      }

      if (failed_queue_attempts > 100) return;

      await Future.delayed(const Duration(milliseconds: 100));
      execute_queue();
      return;
    }

    do {
      var request = call_queue.removeAt(0);

      emit(request['request'], request['data']);

      await Future.delayed(const Duration(milliseconds: 100));
    } while (call_queue.length != 0);

    attempting_to_execute_queue = false;
  }

  static void emit(String _req, Map<String, dynamic> _data) {
    if (_socket==null) return;

    if (!active) {
      call_queue.add({
        'request': _req,
        'data': _data,
      });
      if (attempting_to_execute_queue) return;

      execute_queue();
    }

    _socket.emit(
      _req, _data
    );
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

class _StreamSocket {
  IO.Socket _socket;

  _StreamSocket(String namespace) {
    _socket = IO.io(Constants.site + namespace, <dynamic, dynamic>{
      'transports': ['websocket'],
    });

    _socket.on('message', (data) => this.add(data));
  }

  final _socketResponse = StreamController<dynamic>();

  void Function(dynamic) get add => _socketResponse.sink.add;

  Stream<dynamic> get response => _socketResponse.stream;

  void emit(String _req, Map<String, dynamic> _data) {
    _socket.emit(
      _req, _data,
    );
  }

  void dispose() {
    _socketResponse.close();
  }
}
