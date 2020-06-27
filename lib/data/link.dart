
import 'package:arrival_kc/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ArrivalData {
  static String result;
}

class Data extends StatefulWidget {
  String _query;
  Data.userinfo(String username, String password) {
    this._query = "?u:"+username+":"+password;
  }
  Data.partners(String _q) {
    this._query = "?p:"+_q;
  }
  Data.radius(int lat, int lng) {
    this._query = "?r:"+lat.toString()+":"+lng.toString();
  }

  @override
  _DataState createState() => _DataState(_query);
}

class _DataState extends State<Data> {
  final String query;
  _DataState(this.query);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: ArrivalTitle(),
      ),
      url: 'https://arrival-app.herokuapp.com/applink?'+query,
    );
  }
}
