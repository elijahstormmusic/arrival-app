/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:meta/meta.dart';

class SettingsConfig {
  bool newsSub;

  String toString() {
    String str = '';
    str += 'newsSubscription:' + newsSub.toString() + ',';
    return str;
  }

  SettingsConfig({
    this.newsSub,
  });
  static final SettingsConfig empty = SettingsConfig(
    newsSub: false,
  );

  static SettingsConfig parse(String input)
  {
    var newsSub;

    var startDataLoc, endDataLoc = 0;

    startDataLoc = input.indexOf('newsSubscription')  + 17;
    endDataLoc = input.indexOf(',', startDataLoc);
    newsSub = input.substring(startDataLoc, endDataLoc).toLowerCase() == 'true';

    return SettingsConfig(
      newsSub: newsSub,
    );
  }
}
