/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles.dart';
import '../users/data.dart';
import '../users/page.dart';
import '../data/link.dart';
import 'chat/chat_list.dart';
import 'level_progress_bar.dart';
import 'cards.dart';

class UserProfilePlacecard extends StatefulWidget {
  @override
  _StateProfileCard createState() => _StateProfileCard();
}
class _StateProfileCard extends State<UserProfilePlacecard> {

  void visualizeLevelUp() {
    UserData.client.levelUp();
  }

  @override
  Widget build(BuildContext context) {
    return PressableCard(
      onPressed: () {
        Arrival.navigator.currentState.push(MaterialPageRoute(
          builder: (context) => ProfilePage(),
          fullscreenDialog: true,
        ));
      },
      borderRadius: const BorderRadius.all(Radius.circular(18)),
      child: Container(
        color: Styles.ArrivalPalletteCream,
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width / 2.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                    color: Styles.ArrivalPalletteBlack,
                    border: Border.all(width: 1.0, color: Styles.ArrivalPalletteBlack),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(UserData.client.media_href()),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                    color: Styles.ArrivalPalletteWhite,
                    border: Border.all(width: 1.0, color: Styles.ArrivalPalletteCream),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Arrival.navigator.currentState.push(MaterialPageRoute(
                        builder: (context) => ChatList(),
                        fullscreenDialog: true,
                      ));
                    },
                    child: CircleAvatar(
                      radius: 24,
                      child: Styles.messagesIcon,
                    ),
                  ),
                ),
              ],
            ),

            Container(
              padding: EdgeInsets.only(
                top: 8,
              ),
              child: Text(
                'Your Level',
                style: TextStyle(
                  fontFamily: 'Helvetica Neue',
                  fontSize: 19,
                  color: Styles.ArrivalPalletteBlack,
                  fontWeight: FontWeight.w700,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            LevelProgress(
              UserData.client.level,
              UserData.client.points,
              maxSize: 128,
              onCycle: visualizeLevelUp,
            ),
          ],
        ),
      ),
    );
  }
}
