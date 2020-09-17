import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import '../data/preferences.dart';
import '../styles.dart';
import '../widgets/cards.dart';

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
                child: Loading(
                  indicator: BallPulseIndicator(),
                  size: 100.0,
                  color: Styles.ArrivalPalletteCream,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
