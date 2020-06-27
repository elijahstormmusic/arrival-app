
import 'package:arrival_kc/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArrivalLogin {
  static String cryptlink;
  static bool valid;
}

class LoginPage extends StatefulWidget {
  String _query;
  LoginPage() {
    this._query = "";
  }
  LoginPage.login(String username, String password) {
    this._query = "?u:"+username+":"+password;
  }

  @override
  _LoginState createState() => _LoginState(_query);
}

class _LoginState extends State<LoginPage> {
  final String query;
  _LoginState(this.query);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: ArrivalTitle(),
      ),
      url: 'https://arrival-app.herokuapp.com/login'+query,
    );
  }
}
