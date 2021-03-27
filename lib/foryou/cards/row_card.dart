/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../../data/arrival.dart';
import '../../data/preferences.dart';
import '../../styles.dart';
import '../../widgets/cards.dart';

class RowCard {

  int get datatype => -1;
  String get cryptlink => '';

  Widget generate(Preferences prefs) {
    return Padding(
      child: Styles.ArrivalErrorPage('please input a valid RowCard'),
    );
  }
}

class RowLoading extends RowCard {

  @override
  Widget generate(Preferences prefs) => Padding(
    padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
    child: PressableCard(
      shadowColor: Styles.transparentColor,
      color: Styles.transparentColor,
      onPressed: () {
      },
      child: Semantics(
        label: 'loading card',
        child: Container(
          height: 220,
          child: Center(
            child: Container(
              height: 100,
              child: Image.asset('assets/loading/Bucket-1s-200px.gif'),
            ),
          ),
        ),
      ),
    ),
  );
}
