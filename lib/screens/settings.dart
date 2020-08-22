// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import '../data/preferences.dart';
import '../data/partners.dart';
import '../login/login.dart';
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

class SubSettings extends StatefulWidget {
  final Widget Function(BuildContext) buildPage;

  const SubSettings({
    @required
    this.buildPage,
  })  : assert(buildPage != null);

    /***
     * ------ Payment Settings ------
     *
     * All sub classes that deal with payment and verification
     *
     */

   static Widget Billing(BuildContext context) {
     var brightness = CupertinoTheme.brightnessOf(context);
     final _screenSize = MediaQuery.of(context).size;

     double rowH = 80;
     double rowW = 100;
     double vInset = 10.0;

     double billingFontSize = 18.0;

     int _cardNumber = 0;

     ArrivalTextInput arrival = ArrivalTextInput();

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
               child: Material(
                 child: Container(
                   child: Text(
                     'Card Number:',
                     textAlign: TextAlign.left,
                     style: TextStyle(
                         fontSize: billingFontSize, fontWeight: FontWeight.bold),
                   ),
                   padding: EdgeInsets.fromLTRB(32.0, 18.0, 25.0, 5.0),
                 ),
               ),
             ),
             Container(
               //padding: EdgeInsets.all(12),
               child: Material(
                 child: Container(
                   height: 70,
                   child: CupertinoTextField(
                     selectionHeightStyle: BoxHeightStyle.max,
                     controller: arrival.controller,
                     placeholder: '1234 5678 1234 5678',
                     placeholderStyle: TextStyle(fontSize: 16.0, color: Colors.black54),
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
             ),
             Container(
               child: Material(
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
                                   fontWeight: FontWeight.bold),
                             ),
                             padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                           ),
                           Container(
                             height: rowH / 2 + 20,
                             width: rowW,
                             child: CupertinoTextField(
                               placeholder: 'MM/YY',
                               placeholderStyle: TextStyle(fontSize: 14.0, color: Colors.black54),
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
                                   fontSize: 18.0, fontWeight: FontWeight.bold),
                             ),
                             padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                           ),
                           Container(
                             height: rowH / 2 + 20,
                             width: rowW,
                             child: CupertinoTextField(
                               placeholder: '000',
                               placeholderStyle: TextStyle(fontSize: 14.0, color: Colors.black54),
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
                                   fontSize: 18.0, fontWeight: FontWeight.bold),
                             ),
                             padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                           ),
                           Container(
                             height: rowH / 2 + 20,
                             width: rowW,
                             child: CupertinoTextField(
                               placeholder: '11111',
                               placeholderStyle: TextStyle(fontSize: 14.0, color: Colors.black54),
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
             ),
           ],
         ),
       ),
     );
   }

   static Widget Membership(BuildContext context) {
     var brightness = CupertinoTheme.brightnessOf(context);

     int currentMemberTier = 0;

     return CupertinoPageScaffold(
       navigationBar: CupertinoNavigationBar(
         previousPageTitle: 'Profile',
       ),
       backgroundColor: Styles.scaffoldBackground(brightness),
       //child: Material(
       child: ListView(
         children: [
           Container(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Container(
                   height: 120,
                     child: Container(
                       height: 80,
                       width: 350, // TODO: Use method to make this a function of screen width
                       decoration: BoxDecoration(
                         color: Colors.amber,
                         border: Border.all(
                           color: Colors.black12,
                           width: 5,
                         ),
                         borderRadius: BorderRadius.circular(15.0),
                       ),
                         child: Center(
                           child: Text(
                           'Free',
                           textAlign: TextAlign.center,
                           style: TextStyle(
                               fontSize: 18.0, fontWeight: FontWeight.bold),
                           ),
                         ),
                       //padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
                     ),
                 ),
                 Container(
                   height: 80,
                   width: 350,
                   decoration: BoxDecoration(
                     color: Colors.amber,    // TODO: Add logic to change color if this is current tier
                     border: Border.all(
                       color: Colors.black12,
                       width: 5,
                     ),
                     borderRadius: BorderRadius.circular(15.0),
                   ),
                   child: Center(
                     child: Text(
                       'Lite',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                           fontSize: 18.0, fontWeight: FontWeight.bold),
                     ),
                   ),
                   //padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                 ),
                 Container(
                   height: 80,
                   width: 350,
                   decoration: BoxDecoration(
                     color: Colors.amber,    // TODO: Add logic to change color if this is current tier
                     border: Border.all(
                       color: Colors.black12,
                       width: 5,
                     ),
                     borderRadius: BorderRadius.circular(15.0),
                   ),
                   child: Center(
                     child: Text(
                       'Max',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                           fontSize: 18.0, fontWeight: FontWeight.bold),
                     ),
                   ),
                   //padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                 ),
               ],
             ),
           ),
         ],
       ),
     );
   }
   /*
   static Widget Membership(BuildContext context) {
     var brightness = CupertinoTheme.brightnessOf(context);
     return CupertinoPageScaffold(
       navigationBar: CupertinoNavigationBar(
         previousPageTitle: 'Profile',
       ),
       backgroundColor: Styles.scaffoldBackground(brightness),
         //child: Material(
           child: ListView(
             children: [
               Container(
                 height: 80,
                 width: 150,
                 decoration: BoxDecoration(
                   border: Border.all(
                     color: Colors.blue,
                   ),
                   borderRadius: BorderRadius.circular(10.0),
                 ),
                 child: Material(
                   child: Text(
                     'ZIP Code:',
                     textAlign: TextAlign.left,
                     style: TextStyle(
                       fontSize: 18.0, fontWeight: FontWeight.bold),
                   ),
                 ),
               padding: EdgeInsets.all(20),
             ),
           ],
         ),
     );
   }
   */

   static Widget Tipping(BuildContext context) {
     var brightness = CupertinoTheme.brightnessOf(context);
     return CupertinoPageScaffold(
       navigationBar: CupertinoNavigationBar(
         previousPageTitle: 'Profile',
       ),
       backgroundColor: Styles.scaffoldBackground(brightness),
       child: ListView(
         children: [
           Text('tipping'),
         ],
       ),
     );
   }

     /***
      * ------ Account Settings ------
      *
      * All sub classes that handle your account information
      *
      */

   static Widget Password(BuildContext context) {
     var brightness = CupertinoTheme.brightnessOf(context);
     ArrivalTextInput arrival = ArrivalTextInput();

     double passwordFontSize = 16.0;

     return CupertinoPageScaffold(
       navigationBar: CupertinoNavigationBar(
         previousPageTitle: 'Profile',
       ),
       backgroundColor: Styles.scaffoldBackground(brightness),
       child: Material(
         child: ListView(
           keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
           children: [
             Container(
               //padding: EdgeInsets.all(12),
               child: Material(
                 child: Container(
                   height: 65.0,
                   child: CupertinoTextField(
                     controller: arrival.controller,
                     placeholder: 'Current Password',
                     placeholderStyle: TextStyle(fontSize: passwordFontSize, color: Colors.black54),
                     decoration: BoxDecoration(
                       border: Border.all(
                         color: Colors.black38,
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
                   padding: EdgeInsets.fromLTRB(12.0,12.0,12.0,6.0),
                 ),
               ),
             ),
             Container(
               //padding: EdgeInsets.all(12),
               child: Material(
                 child: Container(
                   height: 65.0,
                   child: CupertinoTextField(
                     controller: arrival.controller,
                     placeholder: 'New Password',
                     placeholderStyle: TextStyle(fontSize: passwordFontSize, color: Colors.black54),
                     decoration: BoxDecoration(
                       border: Border.all(
                         color: Colors.black38,
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
                   padding: EdgeInsets.fromLTRB(12.0,12.0,12.0,6.0),
                 ),
               ),
             ),
             Container(
               //padding: EdgeInsets.all(12),
               child: Material(
                 child: Container(
                   height: 65.0,
                   child: CupertinoTextField(
                     controller: arrival.controller,
                     placeholder: 'Confirm New Password',
                     placeholderStyle: TextStyle(fontSize: passwordFontSize, color: Colors.black54),
                     decoration: BoxDecoration(
                       border: Border.all(
                         color: Colors.black38,
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
                   padding: EdgeInsets.fromLTRB(12.0,12.0,12.0,6.0),
                 ),
               ),
             ),
             Container(
               //padding: EdgeInsets.all(12),
               child: Material(
                 child: Container(
                   child: Text(
                     'Forgot your password?',
                     textAlign: TextAlign.left,
                     style: TextStyle(
                         fontSize: passwordFontSize, fontWeight: FontWeight.bold, color: Colors.indigo),
                 ),
                   padding: EdgeInsets.fromLTRB(15.0,8.0,15.0,8.0),
                 ),
               ),
             ),
           ],
         ),
       ),
     );
   }
   static Widget Email(BuildContext context) {
     var brightness = CupertinoTheme.brightnessOf(context);
     ArrivalTextInput arrival = ArrivalTextInput();

     double emailFontSize = 16.0;

     return CupertinoPageScaffold(
       navigationBar: CupertinoNavigationBar(
         previousPageTitle: 'Profile',
       ),
       backgroundColor: Styles.scaffoldBackground(brightness),
       child: Material(
         child: ListView(
           keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
           children: [
             Container(
               //padding: EdgeInsets.all(12),
               child: Material(
                 child: Container(
                   child: Text(
                     'Current Email: ' +  "User's Existing Email",
                     textAlign: TextAlign.left,
                     style: TextStyle(
                         fontSize: emailFontSize),
                   ),
                   padding: EdgeInsets.fromLTRB(15.0,15.0,15.0,6.0),
                 ),
               ),
             ),
             Container(
               //padding: EdgeInsets.all(12),
               child: Material(
                 child: Container(
                   height: 65.0,
                   child: CupertinoTextField(
                     controller: arrival.controller,
                     placeholder: 'New Password',
                     placeholderStyle: TextStyle(fontSize: emailFontSize, color: Colors.black54),
                     decoration: BoxDecoration(
                       border: Border.all(
                         color: Colors.black38,
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
                   padding: EdgeInsets.fromLTRB(12.0,12.0,12.0,6.0),
                 ),
               ),
             ),
             Container(
               //padding: EdgeInsets.all(12),
               child: Material(
                 child: Container(
                   height: 65.0,
                   child: CupertinoTextField(
                     controller: arrival.controller,
                     placeholder: 'Confirm New Password',
                     placeholderStyle: TextStyle(fontSize: emailFontSize, color: Colors.black54),
                     decoration: BoxDecoration(
                       border: Border.all(
                         color: Colors.black38,
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
                   padding: EdgeInsets.fromLTRB(12.0,12.0,12.0,6.0),
                 ),
               ),
             ),
           ],
         ),
       ),
     );
   }

   static Widget Agreements(BuildContext context) {
     var brightness = CupertinoTheme.brightnessOf(context);
     return CupertinoPageScaffold(
       navigationBar: CupertinoNavigationBar(
         previousPageTitle: 'Profile',
       ),
       backgroundColor: Styles.scaffoldBackground(brightness),
       child: ListView(
         children: [
           Text('agreements'),
         ],
       ),
     );
   }
   static Widget Location(BuildContext context) {
     var brightness = CupertinoTheme.brightnessOf(context);
     return CupertinoPageScaffold(
       navigationBar: CupertinoNavigationBar(
         previousPageTitle: 'Profile',
       ),
       backgroundColor: Styles.scaffoldBackground(brightness),
       child: ListView(
         children: [
           Text('location'),
         ],
       ),
     );
   }
   static Widget Security(BuildContext context) {
     var brightness = CupertinoTheme.brightnessOf(context);
     return CupertinoPageScaffold(
       navigationBar: CupertinoNavigationBar(
         previousPageTitle: 'Profile',
       ),
       backgroundColor: Styles.scaffoldBackground(brightness),
       child: ListView(
         children: [
           Text('security'),
         ],
       ),
     );
   }
   static Widget Logout(BuildContext context) {
     var brightness = CupertinoTheme.brightnessOf(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).popUntil((route) => route.isFirst);

          Navigator.of(context).push<void>(CupertinoPageRoute(
            builder: (context) => LoginPage(),
            fullscreenDialog: true,
          ));
        },
        child: Material(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Container(
                //padding: EdgeInsets.all(12),
                child: Material(
                  child: Container(
                    child: Text(
                      'Are you sure you want to log out?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0,8.0,15.0,8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
   }

  @override
  _SubSettingsParent createState() => _SubSettingsParent();
}
class _SubSettingsParent extends State<SubSettings> {
  @override
  Widget build(BuildContext context) {
    return widget.buildPage(context);
  }
}
class ArrivalTextInput {
  TextEditingController controller;
  void initState() {
    controller = TextEditingController();
  }
  void dispose() {
    controller.dispose();
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
    var _payment = <SettingsItem>[
      SettingsItem(
        label: 'Billing Info',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Navigator.of(context).push<void>(
            CupertinoPageRoute(
              builder: (context) => SubSettings(buildPage: SubSettings.Billing),
              title: 'Billing Settings',
            ),
          );
        },
      ),
      SettingsItem(
        label: 'Membership Tier',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Navigator.of(context).push<void>(
            CupertinoPageRoute(
              builder: (context) => SubSettings(buildPage: SubSettings.Membership),
              title: 'Membership Settings',
            ),
          );
        },
      ),
      SettingsItem(
        label: 'Order Tipping',
        subtitle: 'Can be changed at order checkout',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Navigator.of(context).push<void>(
            CupertinoPageRoute(
              builder: (context) => SubSettings(buildPage: SubSettings.Tipping),
              title: 'Tipping Settings',
            ),
          );
        },
      ),
    ];

    var _account = <SettingsItem>[
      SettingsItem(
        label: 'Password',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Navigator.of(context).push<void>(
            CupertinoPageRoute(
              builder: (context) => SubSettings(buildPage: SubSettings.Password),
              title: 'Password Settings',
            ),
          );
        },
      ),
      SettingsItem(
        label: 'Email',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Navigator.of(context).push<void>(
            CupertinoPageRoute(
              builder: (context) => SubSettings(buildPage: SubSettings.Email),
              title: 'Email Settings',
            ),
          );
        },
      ),
      SettingsItem(
        label: 'Agreements',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Navigator.of(context).push<void>(
            CupertinoPageRoute(
              builder: (context) => SubSettings(buildPage: SubSettings.Agreements),
              title: 'Agreements Settings',
            ),
          );
        },
      ),
      SettingsItem(
        label: 'Location',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Navigator.of(context).push<void>(
            CupertinoPageRoute(
              builder: (context) => SubSettings(buildPage: SubSettings.Location),
              title: 'Security Settings',
            ),
          );
        },
      ),
      SettingsItem(
        label: 'Security',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Navigator.of(context).push<void>(
            CupertinoPageRoute(
              builder: (context) => SubSettings(buildPage: SubSettings.Security),
              title: 'Security Settings',
            ),
          );
        },
      ),
      SettingsItem(
        label: 'Log out',
        content: SettingsNavigationIndicator(),
        onPress: () {
          Navigator.of(context).push<void>(
            CupertinoPageRoute(
              builder: (context) => SubSettings(buildPage: SubSettings.Logout),
              title: 'Account logins',
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
            header: SettingsGroupHeader('Membership'),
          ),
          SettingsGroup(
            items: _account,
            header: SettingsGroupHeader('Account'),
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
                snapshot.data?.toString() + ' miles' ?? '',
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
              SizedBox(width: 8),
              SettingsNavigationIndicator(),
            ],
          );
        },
      ),
      onPress: () {
        Navigator.of(context).push<void>(
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
      subtitle: 'Only see industries you want!',
      icon: SettingsIcon(
        backgroundColor: Styles.iconGold,
        icon: Styles.preferenceIcon,
      ),
      content: SettingsNavigationIndicator(),
      onPress: () {
        Navigator.of(context).push<void>(
          CupertinoPageRoute(
            builder: (context) => SourceIndustrySettingsScreen(),
            title: 'Preferred Industries',
          ),
        );
      },
    );
  }

  SettingsItem _buildProfileItem(BuildContext context, Preferences prefs) {
    return SettingsItem(
      label: 'Profile',
      icon: SettingsIcon(
        backgroundColor: Styles.iconMain,
        icon: Styles.profileIcon,
      ),
      content: SettingsNavigationIndicator(),
      onPress: () {
        Navigator.of(context).push<void>(
          CupertinoPageRoute(
            builder: (context) => ProfileScreen(),
            title: 'Edit Profile',
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
                        _buildNearMeItem(context, prefs),
                        _buildIndustriesItem(context, prefs),
                        _buildProfileItem(context, prefs),
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
