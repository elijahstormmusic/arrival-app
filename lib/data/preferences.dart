// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import '../data/partners.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A model class that mirrors the options in [SettingsScreen] and stores data
/// in shared preferences.
class Preferences extends Model {
  // Keys to use with shared preferences.
  static const _caloriesKey = 'calories';
  static const _preferredIndustriesKey = 'preferredIndustries';

  // Indicates whether a call to [_loadFromSharedPrefs] is in progress;
  Future<void> _loading;

  int _nearMeAreaRadius = 30;

  final Set<SourceIndustry> _preferredIndustries = <SourceIndustry>{};

  Future<int> get nearMeAreaRadius async {
    await _loading;
    return _nearMeAreaRadius;
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

  Future<void> setNearMeAreaRadius(int calories) async {
    _nearMeAreaRadius = calories;
    await _saveToSharedPrefs();
    notifyListeners();
  }

  void load() {
    _loading = _loadFromSharedPrefs();
  }

  Future<void> _saveToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_caloriesKey, _nearMeAreaRadius);

    // Store preferred categories as a comma-separated string containing their
    // indices.
    await prefs.setString(_preferredIndustriesKey,
        _preferredIndustries.map((c) => c.index.toString()).join(','));
  }

  Future<void> _loadFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _nearMeAreaRadius = prefs.getInt(_caloriesKey) ?? 30;
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

    notifyListeners();
  }
}
