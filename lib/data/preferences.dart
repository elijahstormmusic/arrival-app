// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
  final int _icon;

  String get label {
    return _label;
  }
  int get value {
    return _value;
  }
  IconData get icon {
    return IconData(_icon,
          fontFamily: CupertinoIcons.iconFont,
          fontPackage: CupertinoIcons.iconFontPackage);
  }

  NotificationHolder(this._label, this._value, this._icon);

  String toString() {
    return '${_label}:${_value}:${_icon}';
  }

  static NotificationHolder fromString(String input) {
    var array = input.split(':');
    String label = array[0];
    int value = int.parse(array[1]);
    var icon = int.parse(array[2]);
    return NotificationHolder(label, value, icon);
  }

  static NotificationHolder fromJson(var data) {
    String icon = data['icon'].toString();
    return NotificationHolder(data['label'], data['value'],
          int.parse('0x' + icon.substring(icon.indexOf('(') + 4, icon.indexOf(')'))));
  }
}

class Preferences extends Model {
  static const _milesRadiusKey = 'mileRadius';
  static const _preferredIndustriesKey = 'preferredIndustries';
  static const _notificationHistoryKey = 'notificationHistory';
  static const _bookmarksKey = 'bookmarks';
  static const _likedContentKey = 'bookmarks';


  Future<void> _loading;

  int _nearMeAreaRadius = 30;

  final Set<SourceIndustry> _preferredIndustries = <SourceIndustry>{};
  final Set<NotificationHolder> _notificationHistory = <NotificationHolder>{};
  final Set<BookmarkHolder> _bookmarks = <BookmarkHolder>{};
  final Set<BookmarkHolder> _likedContent = <BookmarkHolder>{};


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


  Future<Set<NotificationHolder>> get notificationHistory async {
    await _loading;
    return Set.from(_notificationHistory);
  }
  Future<void> addNotificationHistory(var data) async {
    _notificationHistory.add(NotificationHolder.fromJson(data));

    if (_notificationHistory.length > 15) {
      _notificationHistory.remove(_notificationHistory.elementAt(0));
    }

    await _saveToSharedPrefs();
    notifyListeners();
  }
  Future<void> removeNotificationHistory(int type, String link) async {
    // _notificationHistory.removeWhere((x) => x.equals(type, link));
    // await _saveToSharedPrefs();
    // notifyListeners();
  }


  Future<bool> isLikedContent(int type, String link) async {
    await _loading;
    return _likedContent.where((x) => x.equals(type, link)).length > 0;
  }
  void toggleLikedContent(int type, String link) async {
    await _loading;
    if (await isLikedContent(type, link)) {
      removeLikedContent(type, link);
    }
    else {
      addLikedContent(type, link);
    }
    await _saveToSharedPrefs();
    notifyListeners();
  }
  Future<void> addLikedContent(int type, String link) async {
    _likedContent.add(BookmarkHolder(type, link));
    await _saveToSharedPrefs();
    notifyListeners();
  }
  Future<void> removeLikedContent(int type, String link) async {
    _likedContent.removeWhere((x) => x.equals(type, link));
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
    await _saveToSharedPrefs();
    notifyListeners();
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

    await prefs.setString(_likedContentKey,
        _likedContent.map((c) => c.toString()).join(','));
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

    _likedContent.clear();
    final liked = prefs.getString(_likedContentKey);

    if (liked != null && liked.isNotEmpty) {
      for (final saved in liked.split(',')) {
        if (saved.indexOf(':')==-1) continue;
        _likedContent.add(BookmarkHolder.fromString(saved));
      }
    }

    notifyListeners();
  }
}
