
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:arrival_kc/screens/home.dart';

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
              print(message.message);
              if(message.message=='connect') {
                print('inside the connect function');
                Navigator.pop(context);
                Navigator.of(context).push<void>(CupertinoPageRoute(
                  builder: (context) => HomeScreen(),
                  fullscreenDialog: true,
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
