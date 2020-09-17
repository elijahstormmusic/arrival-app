
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../data/link.dart';
import '../users/data.dart';

class ArrivalLogin {
  static String cryptlink;
  static bool valid;
}

class LoginPage extends StatefulWidget {
  String _query;
  LoginPage() {
    this._query = '';
  }
  LoginPage.login(String username, String password) {
    this._query = '?u:'+username+':'+password;
  }

  @override
  _LoginState createState() => _LoginState(_query);
}

class _LoginState extends State<LoginPage> {
  final String query;
  WebViewController webViewController;
  _LoginState(this.query);

  //** Pull data from message handlers **/
  List<String> _splitMessage(String message)
  {
    int equalsLoc = message.indexOf('=');
    if (equalsLoc==-1) return List<String>();
    if (message.indexOf(';')==-1) return message.split('=');
    List<String> result = List<String>();
    result.add(message.substring(0, equalsLoc));
    return result + message.substring(equalsLoc+1).split(';');
  }


  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://arrival-app.herokuapp.com/login'+query,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: Set.from([
        JavascriptChannel(
            name: 'AppAndPageCommunication',
            onMessageReceived: (JavascriptMessage message) {
              List<String> split = _splitMessage(message.message);
              if (split.length==0) return;
              if (split[0]=='connect') {
                UserData.username = split[1];
                UserData.password = split[2];

                // pop off this login page
                Navigator.pop(context);

                // load up userdata download page
                Navigator.of(context).push<void>(CupertinoPageRoute(
                  builder: (context) => Data.userdata(
                    UserData.username, UserData.password
                  ), fullscreenDialog: false,
                ));
              }
            })
      ]),
      onWebViewCreated: (WebViewController w) {
        webViewController = w;
      },
    );
  }
}
