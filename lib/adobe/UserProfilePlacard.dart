import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../styles.dart';
import './nextLevelProgressBar.dart';
import '../users/data.dart';

class UserProfilePlacard extends StatelessWidget {
  UserProfilePlacard({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    try {
      var _stk = Stack(
        children: <Widget>[
          Text('love'),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(9.5, 0.0, 357.0, 205.0),
            size: Size(387.0, 205.0),
            pinLeft: true,
            pinRight: true,
            pinTop: true,
            pinBottom: true,
            child:
                // Adobe XD layer: 'userPlacardOutline' (shape)
                SvgPicture.string(
              _svg_h73jy3,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(0.0, 2.0, 199.0, 42.0),
            size: Size(387.0, 205.0),
            pinLeft: true,
            pinTop: true,
            fixedWidth: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'usernameTitle' (text)
                SingleChildScrollView(
                  child: Text(
                    UserData.client.name+'\n',
                    style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      fontSize: 32,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                      height: 1.125,
                    ),
                    textAlign: TextAlign.center,
                  )),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(291.0, 2.0, 67.0, 67.0),
            size: Size(387.0, 205.0),
            pinRight: true,
            pinTop: true,
            fixedWidth: true,
            fixedHeight: true,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
                border: Border.all(width: 1.0, color: const Color(0xff757575)),
              ),
              child: Image(image: AssetImage(
                'assets/icon/default-profile-pic.png',
              )),
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(10.0, 54.0, 185.0, 34.0),
            size: Size(387.0, 205.0),
            pinLeft: true,
            fixedWidth: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'levelProgressTitle' (text)
                Text(
              'Level Progress',
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 22,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
                height: 1.6363636363636365,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(49.0, 91.0, 215.0, 9.0),
            size: Size(387.0, 205.0),
            pinLeft: true,
            fixedWidth: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'nextLevelProgressBar' (component)
                nextLevelProgressBar(),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(20.0, 86.0, 23.0, 18.0),
            size: Size(387.0, 205.0),
            pinLeft: true,
            fixedWidth: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'currentUserLevel' (text)
                SingleChildScrollView(
                    child: Text(
              '14',
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 16,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            )),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(298.0, 86.0, 23.0, 18.0),
            size: Size(387.0, 205.0),
            fixedWidth: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'nextUserLevel' (text)
                SingleChildScrollView(
                    child: Text(
              '15',
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 16,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            )),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(22.0, 110.0, 105.0, 34.0),
            size: Size(387.0, 205.0),
            pinLeft: true,
            fixedWidth: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'userInterestsTitle' (text)
                Text(
              'Interests',
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 22,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(37.0, 137.0, 132.0, 64.0),
            size: Size(387.0, 205.0),
            pinLeft: true,
            pinBottom: true,
            fixedWidth: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'userInterestsRepeat…' (none)
                SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 0,
                children: [
                  {
                    'text': '- Music',
                  },
                  {
                    'text': '- Photography',
                  },
                  {
                    'text': '- Finance',
                  }
                ].map((map) {
                  final text = map['text'];
                  return SizedBox(
                    width: 132.0,
                    height: 22.0,
                    child: Stack(
                      children: <Widget>[
                        // Adobe XD layer: 'exampleUserInterest' (text)
                        SizedBox(
                          width: 132.0,
                          height: 22.0,
                          child: Text(
                            text,
                            style: TextStyle(
                              fontFamily: 'Helvetica Neue',
                              fontSize: 16,
                              color: const Color(0xffffffff),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(188.0, 120.0, 168.0, 30.0),
            size: Size(387.0, 205.0),
            pinRight: true,
            fixedWidth: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'amountSavedTitle' (text)
                Text(
              'You’ve Saved:',
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 24,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(218.0, 150.0, 169.0, 49.0),
            size: Size(387.0, 205.0),
            pinRight: true,
            pinBottom: true,
            fixedWidth: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'amountSaved' (text)
                SingleChildScrollView(
                    child: Text(
              '\$69.42',
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 42,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            )),
          ),
        ],
      );
      // return Text('Nothing');
      return _stk;
    } catch (e) {
      print('Arrival Error: UserProfilePlacecard.dart');
      print(e);
      return Text('ERROR');
    }
  }
}

const String _svg_h73jy3 =
    '<svg viewBox="9.5 0.0 357.0 205.0" ><path transform="translate(9.5, 0.0)" d="M 0 0 L 357.0181579589844 0 L 357.0181579589844 205 L 0 205 L 0 0 Z" fill="#757575" stroke="#757575" stroke-width="25" stroke-linecap="butt" stroke-linejoin="round" /></svg>';
