// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:arrival_kc/data/preferences.dart';
import 'package:arrival_kc/data/partners.dart';
import 'package:arrival_kc/styles.dart';
import 'package:arrival_kc/widgets/settings_group.dart';
import 'package:arrival_kc/widgets/settings_item.dart';

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
            if(industry==SourceIndustry.none) continue;
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
                      foregroundColor: snapshot.hasData && snapshot.data == miles
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


// PAYMENT SETTINGS
class PaymentSubBillingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: ListView(
        children: [
          Text('billing'),
        ],
      ),
    );
  }
}
class PaymentSubMembershipScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
}
class PaymentSubTippingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
}

// ACCOUNT SETTINGS
class AccountSubPasswordScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: ListView(
        children: [
          Text('password'),
        ],
      ),
    );
  }
}
class AccountSubEmailScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var brightness = CupertinoTheme.brightnessOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Profile',
      ),
      backgroundColor: Styles.scaffoldBackground(brightness),
      child: ListView(
        children: [
          Text('email'),
        ],
      ),
    );
  }
}
class AccountSubAgreementsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
}
class AccountSubLocationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
}
class AccountSubSecurityScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
              builder: (context) => PaymentSubBillingScreen(),
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
              builder: (context) => PaymentSubMembershipScreen(),
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
              builder: (context) => PaymentSubTippingScreen(),
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
              builder: (context) => AccountSubPasswordScreen(),
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
              builder: (context) => AccountSubEmailScreen(),
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
              builder: (context) => AccountSubAgreementsScreen(),
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
              builder: (context) => AccountSubSecurityScreen(),
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
              builder: (context) => AccountSubSecurityScreen(),
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

class SettingsScreen extends StatelessWidget {
  SettingsItem _buildCaloriesItem(BuildContext context, Preferences prefs) {
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
                        _buildCaloriesItem(context, prefs),
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
