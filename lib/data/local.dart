/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class ArrivalFiles {
  String name;
  bool _valid = true;
  Map<String, dynamic> _contents;

  ArrivalFiles(String _file) {
    if (_file=='') return;

    name = _file;

    _setup();
  }
  void _setup() async {
    try {
      final file = await _localFile;
      file.create();
      _valid = true;
    } catch(e) {
      _valid = false;
      print('Arrival Error: Cannot create file');
      print(e);
      throw e;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$name');
  }
  Future<File> write(Map<String, dynamic> data) async {
    final file = await _localFile;

    try {
      _contents = json.decode(await file.readAsString());
    } catch(e) {
      _contents = Map<String, dynamic>();
    }
    _contents.addAll(data);

    await file.writeAsStringSync(json.encode(_contents));
    return file;
  }
  Future<dynamic> read(String key) async {
    if (!_valid) return -1;

    if (_contents==null) {
      try {
        final file = await _localFile;

        _contents = json.decode(await file.readAsString());
      } catch (e) {
        print('Arrival Error: Unreadable @ read()');
        print(e);
        throw e;
      }
    }

    return _contents[key];
  }
  Future<Map<String, dynamic>> readAll() async {
    if (!_valid) return null;

    if (_contents==null) {
      try {
        final file = await _localFile;

        _contents = json.decode(await file.readAsString());
      } catch (e) {
        print('Arrival Error: Unreadable @ readAll()');
        print(e);
        throw e;
      }
    }

    return _contents;
  }
  bool delete() {
    return false;
  }
}
