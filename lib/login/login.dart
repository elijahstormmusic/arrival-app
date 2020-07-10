
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:arrival_kc/data/link.dart';

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

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://arrival-app.herokuapp.com/login'+query,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: Set.from([
        JavascriptChannel(
            name: 'AppAndPageCommunication',
            onMessageReceived: (JavascriptMessage message) {
              if(message.message=='connect') {

                // pop off this login page
                Navigator.pop(context);

                // load up data download page
                Navigator.of(context).push<void>(CupertinoPageRoute(
                  builder: (context) => Data.partners(''),
                  fullscreenDialog: false,
                ));
              }
              else if(message.message=='disconnect') {
                print('inside the DISconnect function');
              }
              else if(message.message=='reconnect') {
                print('inside the REconnect function');
              }
              else print('function could not be found');
            })
      ]),
      onWebViewCreated: (WebViewController w) {
        webViewController = w;
      },
    );
  }
}
