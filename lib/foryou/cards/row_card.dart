/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/preferences.dart';
import '../../styles.dart';
import '../../widgets/cards.dart';

class RowCard {
  Widget generate(Preferences prefs) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Text('please input a vaild RowCard'),
    );
  }
}

class RowLoading extends RowCard {

  @override
  Widget generate(Preferences prefs) => Padding(
    padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
    child: PressableCard(
      onPressed: () {

      },
      child: Stack(
        children: [
          Semantics(
            label: 'loading card',
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Styles.ArrivalPalletteGrey,
              ),
              child: Center(
                child: Center(
                  // child: SvgPicture.asset('assets/loading/Bucket-1s-200px.svg'),
                  child: Image.asset('assets/loading/Bucket-1s-200px.gif'),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
