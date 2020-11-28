// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import '../partners/partner.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BookmarkHolder {
  final int _type;
  final String _link;

  BookmarkHolder(this._type, this._link);

  String toString() {
    return '${_type}:${_link}';
  }

  bool equals(int type, String link) {
    return _type==type && _link==link;
  }

  static BookmarkHolder fromString(String input) {
    var array = input.split(':');
    int type = int.parse(array[0]);
    String link = array[1];
    return BookmarkHolder(type, link);
  }
}

class NotificationHolder {
  final String _label;
  final int _value;
  final dynamic _icon;

  String get label {
    return _label;
  }
  int get value {
    return _value;
  }
  dynamic get icon {
    return _icon;
  }

  NotificationHolder(this._label, this._value, this._icon);

  String toString() {
    return '${_label}~${_value}~${_icon}';
  }

  static NotificationHolder fromString(String input) {
    var array = input.split(':');
    String label = array[0];
    int value = int.parse(array[1]); // 'var(U+${codePoint.toRadixString(16).toUpperCase().padLeft(5, '0')})';
    var icon = int.parse(array[2].substring(array[2].indexOf('(') + 1, array[2].indexOf(')')));

    print(array[2].substring(array[2].indexOf('(') + 1, array[2].indexOf(')')));


    return NotificationHolder(label, value, icon);
  }

  static NotificationHolder fromJson(var data) {
    return NotificationHolder(data['label'], data['value'], data['icon']);
  }
}

class Preferences extends Model {
  static const _milesRadiusKey = 'mileRadius';
  static const _preferredIndustriesKey = 'preferredIndustries';
  static const _notificationHistoryKey = 'notificationHistory';
  static const _bookmarksKey = 'bookmarks';


  Future<void> _loading;

  int _nearMeAreaRadius = 30;

  final Set<SourceIndustry> _preferredIndustries = <SourceIndustry>{};
  final Set<NotificationHolder> _notificationHistory = <NotificationHolder>{};
  final Set<BookmarkHolder> _bookmarks = <BookmarkHolder>{};


  Future<int> get nearMeAreaRadius async {
    await _loading;
    return _nearMeAreaRadius;
  }
  Future<void> setNearMeAreaRadius(int miles) async {
    _nearMeAreaRadius = miles;
    await _saveToSharedPrefs();
    notifyListeners();
  }


  Future<Set<SourceIndustry>> get preferredIndustries async {
    await _loading;
    return Set.from(_preferredIndustries);
  }
  Future<void> addPreferredIndustry(SourceIndustry industry) async {
    _preferredIndustries.add(industry);
    await _saveToSharedPrefs();
    notifyListeners();
  }
  Future<void> removePreferredIndustry(SourceIndustry industry) async {
    _preferredIndustries.remove(industry);
    await _saveToSharedPrefs();
    notifyListeners();
  }


  Future<Set<NotificationHolder> > get notificationHistory async {
    await _loading;
    return Set.from(_preferredIndustries);
  }
  Future<void> addNotificationHistory(var data) async {
    _notificationHistory.add(NotificationHolder.fromJson(data));
    await _saveToSharedPrefs();
    notifyListeners();
  }


  Future<bool> isBookmarked(int type, String link) async {
    await _loading;
    return _bookmarks.where((x) => x.equals(type, link)).length > 0;
  }
  void toggleBookmarked(int type, String link) async {
    await _loading;
    if (await isBookmarked(type, link)) {
      removeBookmark(type, link);
    }
    else {
      addBookmark(type, link);
    }
  }
  Future<void> addBookmark(int type, String link) async {
    _bookmarks.add(BookmarkHolder(type, link));
    await _saveToSharedPrefs();
    notifyListeners();
  }
  Future<void> removeBookmark(int type, String link) async {
    _bookmarks.removeWhere((x) => x.equals(type, link));
    await _saveToSharedPrefs();
    notifyListeners();
  }


  void load() {
    _loading = _loadFromSharedPrefs();
  }
  Future<void> _saveToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_milesRadiusKey, _nearMeAreaRadius);

    await prefs.setString(_preferredIndustriesKey,
        _preferredIndustries.map((c) => c.index.toString()).join(','));

    await prefs.setString(_notificationHistoryKey,
        _notificationHistory.map((c) => c.toString()).join(','));

    await prefs.setString(_bookmarksKey,
        _bookmarks.map((c) => c.toString()).join(','));
  }
  Future<void> _loadFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _nearMeAreaRadius = prefs.getInt(_milesRadiusKey) ?? 30;

    _preferredIndustries.clear();
    final names = prefs.getString(_preferredIndustriesKey);

    if (names != null && names.isNotEmpty) {
      for (final name in names.split(',')) {
        final index = int.tryParse(name) ?? -1;
        if (SourceIndustry.values[index] != null) {
          _preferredIndustries.add(SourceIndustry.values[index]);
        }
      }
    }

    _notificationHistory.clear();
    final history = prefs.getString(_notificationHistoryKey);

    if (history != null && history.isNotEmpty) {
      for (final instance in history.split(',')) {
        if (instance.indexOf(':')==-1) continue;
        _notificationHistory.add(NotificationHolder.fromString(instance));
      }
    }

    _bookmarks.clear();
    final favorites = prefs.getString(_bookmarksKey);

    if (favorites != null && favorites.isNotEmpty) {
      for (final saved in favorites.split(',')) {
        if (saved.indexOf(':')==-1) continue;
        _bookmarks.add(BookmarkHolder.fromString(saved));
      }
    }

    notifyListeners();
  }
}
