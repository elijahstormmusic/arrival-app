/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project


import 'dart:ui';
import 'dart:math';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_client/cloudinary_client.dart';

import '../data/preferences.dart';
import '../partners/partner.dart';
import '../data/socket.dart';
import '../data/link.dart';
import '../login/login.dart';
import '../foryou/foryou.dart';
import '../users/data.dart';
import '../users/profile.dart';
import '../arrival_team/contact.dart';
import '../styles.dart';
import '../widgets/settings_group.dart';
import '../widgets/settings_item.dart';


/***
 * ------ Inhereitable Parent ------
 *
 * This is the parent settings page, have all settings that need to be
 * edited  (such as one with a TextField) an extension of this parent class
 *
 */


//TODO: Make styling consistent with other Settings pages and rest of app. Lean towards square/flat/modern.
//TODO: Character check on variable input, ie. check that expiration input matches MM/YY format etc.
//TODO: Card info verification - third party integration/APIs involved?
//TODO: Show Existing payment methods/cards and add button to ADD new payment method
class SubSettings extends StatefulWidget {
  final Widget Function(BuildContext, dynamic) buildPage;
  final initalState;
  static _SubSettingsParent state;

  const SubSettings({
    @required
    this.buildPage,
    this.initalState,
  })  : assert(buildPage != null);

  static Widget SaveButton(var saveNsend) {
    return GestureDetector(
      onTap: saveNsend,
      child: Text(
        'Save',
        style: TextStyle(
          color: Styles.ArrivalPalletteRed,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  static Widget ChangesNeedSavingWarning() {
    return Container(
      height: 100.0,
      padding: EdgeInsets.all(16),
      child: Text(
        'Changes will not take affect until you confirm by pressing save.',
        style: TextStyle(
          color: Styles.ArrivalPalletteBlack,
          fontSize: 18.0,
        ),
      ),
    );
  }

  /***
   * ------ Payment Settings ------
   *
   * All sub classes that deal with payment and verification
   *
   */

  static Widget Billing(BuildContext context, var variableState) {
    var brightness = CupertinoTheme.brightnessOf(context);
    final _screenSize = MediaQuery.of(context).size;

    double rowH = 80;
    double rowW = 100;
    double vInset = 10.0;

    double billingFontSize = 18.0;

    int _cardNumber = 0;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: Material(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
              .onDrag, // Make this behave such that touching outside of text field dismisses keyboard
          children: [
            Container(
              //padding: EdgeInsets.all(12),
              child: Container(
                child: Text(
                  'Card Number:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: billingFontSize, fontWeight: FontWeight.bold, fontFamily: 'HelveticaRegular'),
                ),
                padding: EdgeInsets.fromLTRB(32.0, 18.0, 25.0, 5.0),
              ),
            ),
            Container(
              //padding: EdgeInsets.all(12),
              child: Container(
                height: 70,
                child: CupertinoTextField(
                  selectionHeightStyle: BoxHeightStyle.max,
                  placeholder: '1234 5678 1234 5678',
                  placeholderStyle: TextStyle(fontSize: 16.0, color: Colors.black54, fontFamily: 'HelveticaHeavy'),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onChanged: (String str) {
                    // here you write code that activates when the user types in
                    print(str);
                  },
                  onSubmitted: (String str) {
                    // here you write code that activates when the presses enter
                    print(str);
                  },
                ),
                padding: EdgeInsets.fromLTRB(30, 10, 30, 15),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: rowH / 2,
                            width: rowW,
                            child: Text(
                              'Exp Date:',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold, fontFamily: 'HelveticaRegular'),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          ),
                          Container(
                            height: rowH / 2 + 20,
                            width: rowW,
                            child: CupertinoTextField(
                              placeholder: 'MM/YY',
                              placeholderStyle: TextStyle(fontSize: 15.0, color: Colors.black54, fontFamily: 'HelveticaHeavy'),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              keyboardType: TextInputType.datetime,
                            ),
                            padding: EdgeInsets.fromLTRB(2,2,2,18),
                          ),
                        ]
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: rowH / 2,
                          width: rowW,
                          child: Text(
                            'CVV:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: 'HelveticaRegular'),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        ),
                        Container(
                          height: rowH / 2 + 20,
                          width: rowW,
                          child: CupertinoTextField(
                            placeholder: '000',
                            placeholderStyle: TextStyle(fontSize: 15.0, color: Colors.black54, fontFamily: 'HelveticaHeavy'),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          padding: EdgeInsets.fromLTRB(2,2,2,18),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: rowH / 2,
                          width: rowW,
                          child: Text(
                            'ZIP Code:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: 'HelveticaRegular'),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        ),
                        Container(
                          height: rowH / 2 + 20,
                          width: rowW,
                          child: CupertinoTextField(
                            placeholder: '11111',
                            placeholderStyle: TextStyle(fontSize: 15.0, color: Colors.black54, fontFamily: 'HelveticaHeavy'),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          padding: EdgeInsets.fromLTRB(2,2,2,18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget ProfilePicture(BuildContext context, var variableState) {
    var brightness = CupertinoTheme.brightnessOf(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
        trailing: SaveButton(() async {
          if (variableState==null) return;
          try {
            CloudinaryClient cloudinary_client =
              new CloudinaryClient('868422847775537',
              'QZeAt-YmyaViOSNctnmCR0FF61A', 'arrival-kc');

            String image_name = UserData.client.name + Random().nextInt(1000000).toString();
            String img_url = (await cloudinary_client.uploadImage(
              variableState.path,
              filename: image_name,
              folder: 'profile/' + UserData.client.name,
            )).secure_url.replaceAll('https://res.cloudinary.com/arrival-kc/image/upload/', '');

            if (img_url!=null) {
              socket.emit('userdata update', {
                'link': UserData.client.cryptlink,
                'password': UserData.password,
                'type': 'pic',
                'value': img_url,
              });
            }

            UserData.client = Profile(
              pic: img_url,
              name: UserData.client.name,
              email: UserData.client.email,
              shortBio: UserData.client.shortBio,
              cryptlink: UserData.client.cryptlink,
              level: UserData.client.level,
              points: UserData.client.points,
            );
            ForYouPage.refresh_state();
            SubSettings.state.reload(null);
          } catch (e) {
            print('------------- Arrival Error ------------');
            print(e);
          }
        }),
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: Material(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
          child: ListView(
            children: [
              Container(
                height: 150.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Styles.ArrivalPalletteBlack),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: variableState==null
                    ? (UserData.client.pic==null
                      ? Text('No image selected')
                      : UserData.client.icon())
                    : Image(
                      image: FileImage(variableState),
                      fit: BoxFit.cover,
                    ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.fromLTRB(10,20,10,0),
                child: MaterialButton(
                  child: Text('Pick Image'),
                  textColor: Styles.ArrivalPalletteWhite,
                  color: Styles.ArrivalPalletteBlue,
                  onPressed: () async {
                    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                    SubSettings.state.reload(image);
                  },
                ),
              ),
              SubSettings.ChangesNeedSavingWarning(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget Membership(BuildContext context, var variableState) {
    var brightness = CupertinoTheme.brightnessOf(context);

    double membershipTierSpacing = 12.0;
    double tierFontSize = 20.0;
    Color notCurrentTierColor = Colors.white70;
    const currentTierColor = const Color(0xFFD33731);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
        trailing: SaveButton(() {
          if (variableState!=0 && variableState!=1 && variableState!=2) return;
          if (variableState==UserData.MembershipTier) return;
          UserData.MembershipTier = variableState;
          socket.emit('userdata update', {
            'link': UserData.client.cryptlink,
            'password': UserData.password,
            'type': 'membership tier',
            'value': UserData.MembershipTier,
          });
        }),
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: Material(
        child: ListView(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: membershipTierSpacing,
                  ),
                  GestureDetector(
                    onTap: () {
                      SubSettings.state.reload(0);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                      child: Container(
                        height: 60,
                        width: 400,
                        decoration: BoxDecoration(
                          color: (variableState==0)
                            ? currentTierColor : notCurrentTierColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          alignment: Alignment(0,0),
                          child: Text(
                            'Free    0.00/mo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: tierFontSize,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'HelveticaHeavy',
                              color: (variableState==0)
                                ? Colors.white70 : Styles.ArrivalPalletteBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: membershipTierSpacing,
                  ),
                  GestureDetector(
                    onTap: () {
                      SubSettings.state.reload(1);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                      child: Container(
                        height: 60,
                        width: 400,
                        decoration: BoxDecoration(
                          color: (variableState==1)
                            ? currentTierColor : notCurrentTierColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          alignment: Alignment(0,0),
                          child: Text(
                            'Lite    2.99/mo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: tierFontSize,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'HelveticaHeavy',
                              color: (variableState==1)
                              ? Colors.white70 : Styles.ArrivalPalletteBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: membershipTierSpacing,
                  ),
                  GestureDetector(
                    onTap: () {
                      SubSettings.state.reload(2);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                      child: Container(
                        height: 60,
                        width: 400,
                        decoration: BoxDecoration(
                          color: (variableState==2)
                            ? currentTierColor : notCurrentTierColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          alignment: Alignment(0,0),
                          child: Text(
                            'Max    9.99/mo',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: tierFontSize,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'HelveticaHeavy',
                              color: (variableState==2)
                              ? Colors.white70 : Styles.ArrivalPalletteBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: membershipTierSpacing,
                  ),
                  SubSettings.ChangesNeedSavingWarning(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget Tipping(BuildContext context, var variableState) {
    var brightness = CupertinoTheme.brightnessOf(context);

    double tippingTierHeight = 60;
    double tippingTierSpacing = 12.0;
    double tierFontSize = 20.0;
    Color notCurrentTierColor = Colors.white70;

    const currentTierColor = const Color(0xFFD33731);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
        trailing: SaveButton(() {
          if (!(variableState[1] is double)) return;
          if (variableState[1]<0) return;
          if (variableState[1]==UserData.DefaultTip) return;
          UserData.DefaultTip = variableState[1];
          socket.emit('userdata update', {
            'link': UserData.client.cryptlink,
            'password': UserData.password,
            'type': 'default tip',
            'value': UserData.DefaultTip,
          });
        }),
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: Material(
        child: ListView(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: tippingTierSpacing,
                  ),
                  GestureDetector(
                    onTap: () {
                      SubSettings.state.reload([0, .15]);
                    },
                    child: Container(
                      height: tippingTierHeight,
                      width: 400,
                      decoration: BoxDecoration(
                        color: (variableState[0]==0)
                          ? currentTierColor : notCurrentTierColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        alignment: Alignment(-0.90,0),
                        child: Text(
                          '15%',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: tierFontSize,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'HelveticaHeavy',
                              color: (variableState[0]==0)
                                ? Colors.white70 : Styles.ArrivalPalletteBlack,
                            ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                    ),
                  ),
                  Container(
                    height: tippingTierSpacing,
                  ),
                  GestureDetector(
                    onTap: () {
                      SubSettings.state.reload([1, .2]);
                    },
                    child: Container(
                      height: tippingTierHeight,
                      width: 400,
                      decoration: BoxDecoration(
                        color: (variableState[0]==1)
                          ? currentTierColor : notCurrentTierColor,
                        border: Border.all(
                          color: Colors.black12,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        alignment: Alignment(-0.9,0),
                        child: Text(
                          '20%',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: tierFontSize,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'HelveticaHeavy',
                            color: (variableState[0]==1)
                              ? Colors.white70 : Styles.ArrivalPalletteBlack,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                    ),
                  ),
                  Container(
                    height: tippingTierSpacing,
                  ),
                  GestureDetector(
                    onTap: () {
                      SubSettings.state.reload([2, .25]);
                    },
                    child: Container(
                      height: tippingTierHeight,
                      width: 400,
                      decoration: BoxDecoration(
                        color: (variableState[0]==2)
                          ? currentTierColor : notCurrentTierColor,
                        border: Border.all(
                          color: Colors.black12,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        alignment: Alignment(-0.9,0),
                        child: Text(
                          '25%',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: tierFontSize,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'HelveticaHeavy',
                            color: (variableState[0]==2)
                              ? Colors.white70 : Styles.ArrivalPalletteBlack,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                    ),
                  ),
                  Container(
                    height: tippingTierSpacing,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                    child: Container(
                      height: tippingTierHeight,
                      child: CupertinoTextField(
                        selectionHeightStyle: BoxHeightStyle.max,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          // FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                          BlacklistingTextInputFormatter.singleLineFormatter,
                        ],
                        style: TextStyle(
                          color: (variableState[0]==3)
                            ? Colors.white70 : Styles.ArrivalPalletteBlack,
                        ),
                        placeholder: 'Custom Amount',
                        placeholderStyle: TextStyle(
                          fontSize: tierFontSize,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'HelveticaHeavy',
                        ),
                        decoration: BoxDecoration(
                          color: (variableState[0]==3)
                          ? currentTierColor : notCurrentTierColor,
                          border: Border.all(
                            color: Colors.black12,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onChanged: (String data_input) {
                          double _validNumber;
                          try {
                            _validNumber = double.parse(data_input);
                          } catch (e) {
                            return;
                          }
                          if (_validNumber<0) return;
                          if (_validNumber>1) return; // should up have an upper limit?
                          SubSettings.state.reload([3, _validNumber]);
                        },
                      ),
                    ),
                  ),
                  SubSettings.ChangesNeedSavingWarning(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /***
   * ------ Account Settings ------
   *
   * All sub classes that handle your account information
   *
   */

  static Widget Password(BuildContext context, var variableState) {
    var brightness = CupertinoTheme.brightnessOf(context);
    String valid_chars = 'qQwWeErRtTyYuUiIoOpPaAsSdDfFgGhHjJkKlLzZxXcCvVbBnNmM1234567890!@#_{}\$%^&*()~.,';

    double passwordFontSize = 16.0;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
        trailing: SaveButton(() {
          for (int j=0;j<variableState.length;j++) {
            for (int i=0;i<variableState[j].length;i++) {
              if (valid_chars.indexOf(variableState[j][i])==-1) return;
            }
          }
          if (variableState[0]==null) return;
          if (variableState[1]==null) return;
          if (variableState[2]==null) return;
          if (variableState[1]!=variableState[2]) return;

          socket.emit('userdata update', {
            'link': UserData.client.cryptlink,
            'password': variableState[0],
            'type': 'password',
            'value': variableState[1],
          });
        }),
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: Material(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              child: Container(
                height: 65.0,
                child: CupertinoTextField(
                  placeholder: 'Current Password',
                  placeholderStyle: TextStyle(fontSize: passwordFontSize, color: Colors.black54),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black38,
                      width: 1,
                    ),
                    color: variableState[0]=='.' ? Styles.ArrivalPalletteRed : null,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onChanged: (String str) {
                    for (int i=0;i<str.length;i++) {
                      if (valid_chars.indexOf(str[i])==-1) {
                        variableState[0] = '.';
                        SubSettings.state.reload(variableState);
                        return;
                      }
                    }
                    variableState[0] = str;
                    SubSettings.state.reload(variableState);
                  },
                ),
                padding: EdgeInsets.fromLTRB(12.0,12.0,12.0,6.0),
              ),
            ),
            Container(
              child: Container(
                height: 65.0,
                child: CupertinoTextField(
                  placeholder: 'New Password',
                  placeholderStyle: TextStyle(fontSize: passwordFontSize, color: Colors.black54),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black38,
                      width: 1,
                    ),
                    color: variableState[1]=='.' ? Styles.ArrivalPalletteRed : null,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onChanged: (String str) {
                    for (int i=0;i<str.length;i++) {
                      if (valid_chars.indexOf(str[i])==-1) {
                        variableState[1] = '.';
                        SubSettings.state.reload(variableState);
                        return;
                      }
                    }
                    variableState[1] = str;
                    SubSettings.state.reload(variableState);
                  },
                ),
                padding: EdgeInsets.fromLTRB(12.0,12.0,12.0,6.0),
              ),
            ),
            Container(
              child: Container(
                height: 65.0,
                child: CupertinoTextField(
                  placeholder: 'Confirm New Password',
                  placeholderStyle: TextStyle(fontSize: passwordFontSize, color: Colors.black54),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black38,
                      width: 1,
                    ),
                    color: variableState[2]=='.' ? Styles.ArrivalPalletteRed : null,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onChanged: (String str) {
                    for (int i=0;i<str.length;i++) {
                      if (valid_chars.indexOf(str[i])==-1) {
                        variableState[2] = '.';
                        SubSettings.state.reload(variableState);
                        return;
                      }
                    }
                    variableState[2] = str;
                    SubSettings.state.reload(variableState);
                  },
                ),
                padding: EdgeInsets.fromLTRB(12.0,12.0,12.0,6.0),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () => LoginScreen.forgotPassword(),
                child: Container(
                  child: Text(
                    'Forgot your password?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: passwordFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0,8.0,15.0,8.0),
                ),
              ),
            ),
            SubSettings.ChangesNeedSavingWarning(),
          ],
        ),
      ),
    );
  }
  static Widget Email(BuildContext context, var variableState) {
    var brightness = CupertinoTheme.brightnessOf(context);
    String valid_chars = 'qQwWeErRtTyYuUiIoOpPaAsSdDfFgGhHjJkKlLzZxXcCvVbBnNmM1234567890!-=_|{}@#\$%^&*()~.,';

    double emailFontSize = 16.0;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
        trailing: SaveButton(() {
          for (int j=0;j<variableState.length;j++) {
            for (int i=0;i<variableState[j].length;i++) {
              if (valid_chars.indexOf(variableState[j][i])==-1) return;
            }
          }
          if (variableState[0]==null) return;
          if (variableState[1]==null) return;
          if (variableState[0]!=variableState[1]) return;

          socket.emit('userdata update', {
            'link': UserData.client.cryptlink,
            'password': UserData.password,
            'type': 'email',
            'value': variableState[0],
          });
          UserData.client = Profile(
            email: variableState[0],
            pic: UserData.client.pic,
            name: UserData.client.name,
            shortBio: UserData.client.shortBio,
            cryptlink: UserData.client.cryptlink,
            level: UserData.client.level,
            points: UserData.client.points,
          );
        }),
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: Material(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Container(
              //padding: EdgeInsets.all(12),
              child: Container(
                child: Text(
                  'Current Email: ' + UserData.client.email,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: emailFontSize,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(15.0,15.0,15.0,6.0),
              ),
            ),
            Container(
              child: Container(
                height: 65.0,
                child: CupertinoTextField(
                  placeholder: 'New Email',
                  placeholderStyle: TextStyle(fontSize: emailFontSize, color: Colors.black54),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black38,
                      width: 1,
                    ),
                    color: variableState[0]=='.' ? Styles.ArrivalPalletteRed : null,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onChanged: (String str) {
                    for (int i=0;i<str.length;i++) {
                      if (valid_chars.indexOf(str[i])==-1) {
                        variableState[0] = '.';
                        SubSettings.state.reload(variableState);
                        return;
                      }
                    }
                    variableState[0] = str;
                    SubSettings.state.reload(variableState);
                  },
                ),
                padding: EdgeInsets.fromLTRB(12.0,12.0,12.0,6.0),
              ),
            ),
            Container(
              child: Container(
                height: 65.0,
                child: CupertinoTextField(
                  placeholder: 'Confirm New Email',
                  placeholderStyle: TextStyle(fontSize: emailFontSize, color: Colors.black54),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black38,
                      width: 1,
                    ),
                    color: variableState[1]=='.' ? Styles.ArrivalPalletteRed : null,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onChanged: (String str) {
                    for (int i=0;i<str.length;i++) {
                      if (valid_chars.indexOf(str[i])==-1) {
                        variableState[1] = '.';
                        SubSettings.state.reload(variableState);
                        return;
                      }
                    }
                    variableState[1] = str;
                    SubSettings.state.reload(variableState);
                  },
                ),
                padding: EdgeInsets.fromLTRB(12.0,12.0,12.0,6.0),
              ),
            ),
            SubSettings.ChangesNeedSavingWarning(),
          ],
        ),
      ),
    );
  }

  static Widget Agreements(BuildContext context, var variableState) {
    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: Material(
        child: ListView(
          children: [
            Text('agreements'),
          ],
        ),
      ),
    );
  }
  static Widget Location(BuildContext context, var variableState) {
    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: Material(
        child: ListView(
          children: [
            Text('location'),
          ],
        ),
      ),
    );
  }
  static Widget Security(BuildContext context, var variableState) {
    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: Material(
        child: ListView(
          children: [
            Text('security'),
          ],
        ),
      ),
    );
  }

  static Widget Legal(BuildContext context, var variableState) {
    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Settings',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: Material(
        child: ListView(
          children: [
            Text('legal'),
          ],
        ),
      ),
    );
  }

  @override
  _SubSettingsParent createState() => _SubSettingsParent();
}
class _SubSettingsParent extends State<SubSettings> {

  @override
  void initState() {
    _currentVariableState = widget.initalState;
    SubSettings.state = this;
    super.initState();
  }

  var _currentVariableState;
  void reload(var variableState) {
    setState(() => _currentVariableState = variableState);
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildPage(context, _currentVariableState);
  }
}




// PAYMENT SETTINGS
/*TODO:
  - Clean up design, make consistent w other screens
  - String check each user input for validity
  - Verify correct card # & other info
  - Store user input & route to backend

*/

// ACCOUNT SETTINGS -> PASSWORD
/*TODO:
  - assign user input to accessable variable - need text field constructors for this and other text field user data acquisition?
  - confirm "new pass": and "confirrm new pass" are equivalent strings
  - route new pass to back end
  - Forgot password pathway
*/

// ADD/EDIT EMAIL ADDRESS
/*TODO:
  - Display current email address if it's already been set
  - Dependent upon existing email: Add OR edit email address
  - Get user input, add logic to verify valid email address, route email address to back end
*/

// AGREEMENTS
/*TODO:
  - Display current email address if it's already been set
  - Dependent upon existing email: Add OR edit email address
  - Get user input, add logic to verify valid email address, route email address to back end
*/

// LOCATION
/*TODO:
  - What do we want to display here?
  - Anything that user would want to edit?
*/

// SECURITY
/*TODO:
  - What do we want to show user for security?
  - Anything that user would want to edit?
*/



/***
 * ------ Main Sub Classes ------
 *
 * All the second layer settings, this is usually important stuff
 * that you need to get to quickly
 *
 */

class SourceIndustrySettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
    final currentPrefs = model.preferredIndustries;
    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Preferred Industries'),
        previousPageTitle: 'Settings',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: FutureBuilder<Set<SourceIndustry>>(
        future: currentPrefs,
        builder: (context, snapshot) {
          final items = <SettingsItem>[];

          for (final industry in SourceIndustry.values) {
            if (industry == SourceIndustry.none) continue;
            CupertinoSwitch toggle;
            if (snapshot.hasData) {
              toggle = CupertinoSwitch(
                value: snapshot.data.contains(industry),
                onChanged: (value) {
                  if (value) {
                    model.addPreferredIndustry(industry);
                  } else {
                    model.removePreferredIndustry(industry);
                  }
                },
              );
            } else {
              toggle = CupertinoSwitch(
                value: false,
                onChanged: null,
              );
            }

            items.add(SettingsItem(
              label: LocalIndustries.industryGrabber(industry).name,
              content: toggle,
            ));
          }

          return ListView(
            children: [
              SettingsGroup(
                items: items,
              ),
            ],
          );
        },
      ),
    );
  }
}

class DistanceSettingsScreen extends StatelessWidget {
  static const max = 50;
  static const min = 5;
  static const step = 5;

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<Preferences>(context, rebuildOnChange: true);
    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Settings',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: ListView(
        children: [
          FutureBuilder<int>(
            future: model.nearMeAreaRadius,
            builder: (context, snapshot) {
              final steps = <SettingsItem>[];

              for (var miles = min; miles <= max; miles += step) {
                steps.add(
                  SettingsItem(
                    label: miles.toString() + ' miles',
                    icon: SettingsIcon(
                      icon: Styles.checkIcon,
                      foregroundColor:
                      snapshot.hasData && snapshot.data == miles
                          ? CupertinoColors.activeBlue
                          : Styles.transparentColor,
                      backgroundColor: Styles.transparentColor,
                    ),
                    onPress: snapshot.hasData
                        ? () => model.setNearMeAreaRadius(miles)
                        : null,
                  ),
                );
              }

              return SettingsGroup(
                items: steps,
                header: SettingsGroupHeader('Available choices'),
                footer: SettingsGroupFooter('This is how we sort places '
                    'near you.'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var _account = <SettingsItem>[
      SettingsItem(
        label: 'Profile Picture',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Arrival.navigator.currentState.push(
            CupertinoPageRoute(
              builder: (context) => SubSettings(
                buildPage: SubSettings.ProfilePicture,
                initalState: null,
              ),
              title: 'Email Settings',
            ),
          );
        },
      ),

      SettingsItem(
        label: 'Email',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Arrival.navigator.currentState.push(
            CupertinoPageRoute(
              builder: (context) => SubSettings(
                buildPage: SubSettings.Email,
                initalState: ['', ''],
              ),
              title: 'Email Settings',
            ),
          );
        },
      ),

      SettingsItem(
        label: 'Password',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Arrival.navigator.currentState.push(
            CupertinoPageRoute(
              builder: (context) => SubSettings(
                buildPage: SubSettings.Password,
                initalState: [
                  '','','',
                ],
              ),
              title: 'Password Settings',
            ),
          );
        },
      ),

      SettingsItem(
        label: 'Membership Tier',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Arrival.navigator.currentState.push(
            CupertinoPageRoute(
              builder: (context) => SubSettings(
                buildPage: SubSettings.Membership,
                initalState: UserData.MembershipTier,
              ),
              title: 'Membership Settings',
            ),
          );
        },
      ),
    ];

    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Settings',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: ListView(
        children: [
          SettingsGroup(
            items: _account,
          ),
        ],
      ),
    );
  }
}

class PaymentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var _payment = <SettingsItem>[
      SettingsItem(
        label: 'Billing Info',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Arrival.navigator.currentState.push(
            CupertinoPageRoute(
              builder: (context) => SubSettings(
                buildPage: SubSettings.Billing,
                initalState: null,
              ),
              title: 'Billing Settings',
            ),
          );
        },
      ),
      SettingsItem(
        label: 'Tipping Settings',
        //subtitle: 'Can be changed at order checkout',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Arrival.navigator.currentState.push(
            CupertinoPageRoute(
              builder: (context) => SubSettings(
                buildPage: SubSettings.Tipping,
                initalState: [
                  UserData.DefaultTip==.15 ? 0 : (
                      UserData.DefaultTip==.2 ? 1 : (
                        UserData.DefaultTip==.25 ? 2 : 3
                      )
                    ),
                  UserData.DefaultTip,
                ],
              ),
              title: 'Tipping Settings',
            ),
          );
        },
      ),
    ];

    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Settings',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: ListView(
        children: [
          SettingsGroup(
            items: _payment,
            //header: SettingsGroupHeader('Membership'),
          ),
        ],
      ),
    );
  }
}

class ContactUsSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _contactus = <SettingsItem>[
      SettingsItem(
        label: 'Contact Us',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Arrival.navigator.currentState.push(
            CupertinoPageRoute(
              builder: (context) => ContactUs(),
              title: 'Contact Us',
            ),
          );
        },
      ),

      SettingsItem(
        label: 'Legal',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Arrival.navigator.currentState.push(
            CupertinoPageRoute(
              builder: (context) => SubSettings(
                buildPage: SubSettings.Legal,
                initalState: null,
              ),
              title: 'Legal',
            ),
          );
        },
      ),
    ];

    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Settings',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: ListView(
        children: [
          SettingsGroup(
            items: _contactus,
          ),
        ],
      ),
    );
  }
}

/***
 * ------ Top Settings Page ------
 *
 * This is the first settings page that leads to the rest
 *
 */

class SettingsScreen extends StatelessWidget {

  SettingsItem _buildProfileItem(BuildContext context, Preferences prefs) {
    return SettingsItem(
      label: 'Profile',
      icon: SettingsIcon(
        backgroundColor: Styles.iconMain,
        icon: Styles.profileIcon,
      ),
      content: SettingsNavigationIndicator(),
      onPress: () {
        Arrival.navigator.currentState.push(
          CupertinoPageRoute(
            builder: (context) => ProfileScreen(),
            title: 'Edit Profile',
          ),
        );
      },
    );
  }

  SettingsItem _buildNearMeItem(BuildContext context, Preferences prefs) {
    return SettingsItem(
      label: 'Near Me Range',
      icon: SettingsIcon(
        backgroundColor: Styles.iconBlue,
        icon: Styles.calorieIcon,
      ),
      content: FutureBuilder<int>(
        future: prefs.nearMeAreaRadius,
        builder: (context, snapshot) {
          return Row(
            children: [
              Text(
                snapshot.data.toString() + ' miles' ?? '',
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
              SizedBox(width: 8),
              SettingsNavigationIndicator(),
            ],
          );
        },
      ),
      onPress: () {
        Arrival.navigator.currentState.push(
          CupertinoPageRoute(
            builder: (context) => DistanceSettingsScreen(),
            title: 'Near Me Range',
          ),
        );
      },
    );
  }

  SettingsItem _buildIndustriesItem(BuildContext context, Preferences prefs) {
    return SettingsItem(
      label: 'Preferred Industries',
      //subtitle: 'Only see industries you want!',
      icon: SettingsIcon(
        backgroundColor: Styles.iconGold,
        icon: Styles.preferenceIcon,
      ),
      content: SettingsNavigationIndicator(),
      onPress: () {
        Arrival.navigator.currentState.push(
          CupertinoPageRoute(
            builder: (context) => SourceIndustrySettingsScreen(),
            title: 'Preferred Industries',
          ),
        );
      },
    );
  }

  SettingsItem _buildPaymentsItem(BuildContext context, Preferences prefs) {
    return SettingsItem(
      label: 'Payments',
      //subtitle: 'Only see industries you want!',
      icon: SettingsIcon(
        backgroundColor: Styles.iconMain,
        icon: Styles.checkIcon,
      ),
      content: SettingsNavigationIndicator(),
      onPress: () {
        Arrival.navigator.currentState.push(
          CupertinoPageRoute(
            builder: (context) => PaymentsScreen(),
            title: 'Payments',
          ),
        );
      },
    );
  }

  SettingsItem _buildContactUsItem(BuildContext context, Preferences prefs) {
    return SettingsItem(
      label: 'Contact Us',
      icon: SettingsIcon(
        backgroundColor: Styles.iconGold,
        icon: Styles.uncheckedIcon,
      ),
      content: SettingsNavigationIndicator(),
      onPress: () {
        Arrival.navigator.currentState.push(
          CupertinoPageRoute(
            builder: (context) => ContactUsSettings(),
            title: 'Contact Us',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ScopedModel.of<Preferences>(context, rebuildOnChange: true);

    return CupertinoPageScaffold(
      child: Container(
        color: Styles.scaffoldBackground(CupertinoTheme.brightnessOf(context)),
        child: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text('Settings'),
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    SettingsGroup(
                      items: [
                        _buildProfileItem(context, prefs),
                        _buildIndustriesItem(context, prefs),
                        _buildPaymentsItem(context, prefs),
                        _buildNearMeItem(context, prefs),
                        _buildContactUsItem(context, prefs),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
