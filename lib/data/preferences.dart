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

/// A model class that mirrors the options in [SettingsScreen] and stores data
/// in shared preferences.
class Preferences extends Model {
  // Keys to use with shared preferences.
  static const _milesRadiusKey = 'mileRadius';
  static const _preferredIndustriesKey = 'preferredIndustries';
  static const _bookmarksKey = 'bookmarks';

  // Indicates whether a call to [_loadFromSharedPrefs] is in progress;
  Future<void> _loading;

  int _nearMeAreaRadius = 30;

  final Set<SourceIndustry> _preferredIndustries = <SourceIndustry>{};

  final Set<BookmarkHolder> _bookmarks = <BookmarkHolder>{};

  Future<int> get nearMeAreaRadius async {
    await _loading;
    return _nearMeAreaRadius;
  }

  Future<Set<SourceIndustry>> get preferredIndustries async {
    await _loading;
    return Set.from(_preferredIndustries);
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

  Future<void> addPreferredIndustry(SourceIndustry industry) async {
    _preferredIndustries.add(industry);
    await _saveToSharedPrefs();
    notifyListeners();
  }

  Future<void> addBookmark(int type, String link) async {
    _bookmarks.add(BookmarkHolder(type, link));
    await _saveToSharedPrefs();
    notifyListeners();
  }

  Future<void> removePreferredIndustry(SourceIndustry industry) async {
    _preferredIndustries.remove(industry);
    await _saveToSharedPrefs();
    notifyListeners();
  }

  Future<void> removeBookmark(int type, String link) async {
    _bookmarks.removeWhere((x) => x.equals(type, link));
    await _saveToSharedPrefs();
    notifyListeners();
  }

  Future<void> setNearMeAreaRadius(int miles) async {
    _nearMeAreaRadius = miles;
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
