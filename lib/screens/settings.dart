// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import '../data/preferences.dart';
import '../data/partners.dart';
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

    int _cardNumber = 0;

    ArrivalTextInput arrival = ArrivalTextInput();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
            .onDrag, // Make this behave such that touching outside of text field dismisses keyboard
        children: [
          Container(
            height: 120,
            width: 400,
            child: Text(
              'Add Card Details',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            padding: EdgeInsets.fromLTRB(30, 40, 50, 30),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 20.0,
                  width: 400,
                  child: Text(
                    'Card Number',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 200,
                  child: CupertinoTextField(
                    controller: arrival.controller,
                    placeholder: '1234 5678 1234 5678',
                    placeholderStyle: TextStyle(fontSize: 14.0),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: rowH / 2,
                          width: rowW,
                          child: Text(
                            'Exp Date',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.all(vInset),
                        ),
                        Container(
                          height: rowH / 2,
                          width: rowW,
                          child: CupertinoTextField(
                            placeholder: 'MM/YY',
                            placeholderStyle: TextStyle(fontSize: 14.0),
                            keyboardType: TextInputType.datetime,
                          ),
                          padding: EdgeInsets.all(vInset),
                        ),
                      ]
                    ),
                  ),
                  Container(
                    child: Column(children: [
                      Container(
                        height: rowH / 2,
                        width: rowW,
                        child: Text(
                          'CVV',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        padding: EdgeInsets.all(vInset),
                      ),
                      Container(
                        height: rowH / 2,
                        width: rowW,
                        child: CupertinoTextField(
                          placeholder: '000',
                          placeholderStyle: TextStyle(fontSize: 14.0),
                          keyboardType: TextInputType.number,
                        ),
                        padding: EdgeInsets.all(vInset),
                      ),
                    ]),
                  ),
                  Container(
                    child: Column(children: [
                      Container(
                        height: rowH / 2,
                        width: rowW,
                        child: Text(
                          'ZIP Code',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        padding: EdgeInsets.all(vInset),
                      ),
                      Container(
                        height: rowH / 2,
                        width: rowW,
                        child: CupertinoTextField(
                          placeholder: '11111',
                          placeholderStyle: TextStyle(fontSize: 14.0),
                          keyboardType: TextInputType.number,
                        ),
                        padding: EdgeInsets.all(vInset),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  static Widget Membership(BuildContext context) {
    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: ListView(
        children: [
          Text('membership tier'),
        ],
      ),
    );
  }
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

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: CupertinoTextField(
              controller: arrival.controller,
              placeholder: 'Current Password',
              placeholderStyle: TextStyle(fontSize: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Styles.mainColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15.0),
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
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: CupertinoTextField(
              controller: arrival.controller,
              placeholder: 'New Password',
              placeholderStyle: TextStyle(fontSize: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Styles.mainColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15.0),
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
          ),
          //Add a transition for re-enter password once fields are filled out and
          Container(
            padding: EdgeInsets.all(12),
            child: CupertinoTextField(
              controller: arrival.controller,
              placeholder: 'Confirm New Password',
              placeholderStyle: TextStyle(fontSize: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Styles.mainColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15.0),
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
          ),
        ],
      ),
    );
  }
  static Widget Email(BuildContext context) {
    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: ListView(
        children: [
          Container(
            child: Material(
              borderRadius: BorderRadius.circular(15.0),
              child: Text(
                'Existing Email:',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            padding: EdgeInsets.all(12),
          ),
          Container(
            child: Material(
              borderRadius: BorderRadius.circular(15.0),
              child: Text(
                "User's Existing Email",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            padding: EdgeInsets.all(12),
          ),
          Container(
            child: Material(
              borderRadius: BorderRadius.circular(15.0),
              child: CupertinoTextField(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Styles.mainColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                placeholder: 'New Email',
                placeholderStyle: TextStyle(fontSize: 14),
              ),
            ),
            padding: EdgeInsets.all(12),
          ),
          Container(
            child: Material(
              borderRadius: BorderRadius.circular(15.0),
              child: CupertinoTextField(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Styles.mainColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                placeholder: 'Confirm New Email',
                placeholderStyle: TextStyle(fontSize: 14),
              ),
            ),
            padding: EdgeInsets.all(12),
          ),
        ],
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
