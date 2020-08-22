// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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
