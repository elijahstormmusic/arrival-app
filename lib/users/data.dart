/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:convert';
import 'package:meta/meta.dart';
import '../users/profile.dart';
import '../data/local.dart';
import '../data/arrival.dart';
import '../data/socket.dart';

class UserData {
  static Profile client;
  static String username;
  static String password;

  static List<Profile> followers = <Profile>[];

  static double DefaultTip = 0.2;
  static int MembershipTier = 0;
  static bool LocationOn = true;
  static bool NewsLetterSubscription = true;
  static bool UGC_Agreement = false;
  static bool GeneralUse = false;

  static void refreshClientData(var input_data) {
    // UserData.MembershipTier = input_data['settings']['membership']['tier'];
    UserData.DefaultTip = input_data['settings']['membership']['default_tip'];
    UserData.LocationOn = input_data['settings']['legal']['location'];
    UserData.NewsLetterSubscription = input_data['settings']['membership']['newsletter'];
    UserData.UGC_Agreement = input_data['settings']['legal']['UGC_agreement'];
    UserData.GeneralUse = input_data['settings']['legal']['general_use'];

    UserData.client = Profile.json(input_data);
    ArrivalData.innocentAdd(ArrivalData.profiles, UserData.client);

    UserData.save();
    socket.home.refresh();
  }

  static void save() async {
    ArrivalFiles file = ArrivalFiles('client.json');

    Map<String, dynamic> data = Map<String, dynamic>();

    data['username'] = UserData.username;
    data['password'] = UserData.password;
    data['info'] = jsonEncode(UserData.client.toJson());

    await file.write(data);
  }
  static void load() async {
    ArrivalFiles file = ArrivalFiles('client.json');

    try {
      UserData.username = await file.read('username');
      UserData.password = await file.read('password');
      UserData.client = Profile.json(jsonDecode(await file.read('info')));
    } catch (e) {
      print('-------');
      print('Arrival Error: issue loading user data file');
      print(e);
      print('-------');
      UserData.client = Profile.empty;
    }
  }
  static void refresh() async {
    ArrivalFiles file = ArrivalFiles('client.json');

    try {
      file.delete();
    } catch (e) {
      print('-------');
      print('Arrival Error:');
      print('Could not delete file in data.dart @ 48');
      print(e);
      print('-------');
    }
  }
}
