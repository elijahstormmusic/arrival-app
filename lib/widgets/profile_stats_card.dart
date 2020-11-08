/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles.dart';
import './level_progress_bar.dart';
import './cards.dart';
import '../users/data.dart';
import '../users/page.dart';
import '../data/link.dart';

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
    return Container(
      height: 250.0,
      child: PressableCard(
        onPressed: () {
          Arrival.navigator.currentState.push(MaterialPageRoute(
            builder: (context) => ProfilePage(),
            fullscreenDialog: true,
          ));
        },
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: FrostyBackground(
          color: Styles.ArrivalPalletteYellowFrosted,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            UserData.client.name,
                            style: TextStyle(
                              fontFamily: 'Helvetica Neue',
                              fontSize: UserData.client.name.length>15 ? 18
                                  : (UserData.client.name.length>10 ? 24 : 32),
                              color: Styles.ArrivalPalletteBlack,
                              fontWeight: FontWeight.bold,
                              height: 1.125,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 40),
                          Text(
                            'Level Progress',
                            style: TextStyle(
                              fontFamily: 'Helvetica Neue',
                              fontSize: 22,
                              color: Styles.ArrivalPalletteBlack,
                              fontWeight: FontWeight.w700,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width - 373,
                        0, 0, 0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                          color: Styles.ArrivalPalletteBlack,
                          border: Border.all(width: 1.0, color: const Color(0xff757575)),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(UserData.client.media_href()),
                        ),
                      ),
                    ),
                  ],
                ),

                LevelProgress(
                  UserData.client.level,
                  UserData.client.points,
                  maxSize: MediaQuery.of(context).size.width - 168,
                  onCycle: visualizeLevelUp,
                ),

                // Padding(
                //   padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
                //   child: Text(
                //     'Interests',
                //     style: TextStyle(
                //       fontFamily: 'Helvetica Neue',
                //       fontSize: 22,
                //       color: Styles.ArrivalPalletteBlack,
                //       fontWeight: FontWeight.w700,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
                //   child: Wrap(
                //     alignment: WrapAlignment.center,
                //     spacing: 20,
                //     runSpacing: 0,
                //     children: [
                //       {
                //         'text': '- Music',
                //       },
                //       {
                //         'text': '- Photography',
                //       },
                //       {
                //         'text': '- Finance',
                //       }
                //     ].map((map) {
                //       final text = map['text'];
                //       return SizedBox(
                //         width: 132.0,
                //         height: 22.0,
                //         child: Stack(
                //           children: <Widget>[
                //             // Adobe XD layer: 'exampleUserInterest' (text)
                //             SizedBox(
                //               width: 132.0,
                //               height: 22.0,
                //               child: Text(
                //                 text,
                //                 style: TextStyle(
                //                   fontFamily: 'Helvetica Neue',
                //                   fontSize: 16,
                //                   color: Styles.ArrivalPalletteBlack,
                //                 ),
                //                 textAlign: TextAlign.left,
                //               ),
                //             ),
                //           ],
                //         ),
                //       );
                //     }).toList(),
                //   ),
                // ),
                SizedBox(height: 3),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            'You’ve Saved',
                            style: TextStyle(
                              fontFamily: 'Helvetica Neue',
                              fontSize: 20,
                              color: Styles.ArrivalPalletteBlack,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            '\$420.69',
                            style: TextStyle(
                              fontFamily: 'Helvetica Neue',
                              fontSize: 42,
                              color: Styles.ArrivalPalletteBlack,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
