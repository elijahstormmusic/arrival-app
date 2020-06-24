import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'partners.dart';

class ReadArrivalData {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/biz_list.txt');
  }

  Future<Business> readStorage(int index) async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return blankBusiness;
    } catch (e) {
      return blankBusiness;
    }
  }

  Future<File> writeStorage(String biz) async {
    final file = await _localFile;
    return file.writeAsString('$biz.toString()');
  }
}

// TODO: read from file and get information


class FlutterDemo extends StatefulWidget {
  final ReadArrivalData storage;

  FlutterDemo({Key key, @required this.storage}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  Business _counter;

  @override
  void initState() {
    super.initState();
    widget.storage.readStorage(0).then((Business value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      // _counter++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeStorage(_counter.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading and Writing Files')),
      body: Center(
        child: Text(
          'Button tapped $_counter time${_counter == '.' ? '' : 's'}.',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
