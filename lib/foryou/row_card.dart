import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../data/preferences.dart';

class RowCard {
  Widget generate(Preferences prefs) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Text('please input a vaild RowCard'),
    );
  }
}
