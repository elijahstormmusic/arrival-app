/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:meta/meta.dart';
import '../users/profile.dart';
import '../data/local.dart';

class UserData {
  static Profile client;
  static String client_string;
  static String username;
  static String password;
  static double DefaultTip = 0.2;
  static int MembershipTier = 0;
  static bool LocationOn = true;
  static bool NewsLetterSubscription = true;

  static void refreshClientDate(var input_data) {
    UserData.MembershipTier = input_data['settings']['membership']['tier'];
    UserData.DefaultTip = input_data['settings']['membership']['default_tip'];
    UserData.LocationOn = input_data['settings']['legal']['location'];
    UserData.NewsLetterSubscription = input_data['settings']['membership']['newsletter'];

    UserData.client = Profile(
      name: input_data['name'],
      pic: input_data['pic'],
      email: input_data['email'],
      shortBio: input_data['bio'],
      level: input_data['level'],
      points: input_data['points'],
      cryptlink: input_data['cryptlink']
    );

    UserData.save();
  }

  static void save() async {
    ArrivalFiles file = ArrivalFiles('client.json');

    Map<String, dynamic> data = Map<String, dynamic>();

    data['username'] = UserData.username;
    data['password'] = UserData.password;
    data['info'] = UserData.client_string;

    await file.write(data);
  }
  static void load() async {
    ArrivalFiles file = ArrivalFiles('client.json');

    try {
      UserData.username = await file.read('username');
      UserData.password = await file.read('password');
      UserData.client_string = await file.read('info');
      UserData.client = Profile.parse(UserData.client_string);
    } catch (e) {
      print('-------');
      print('Arrival Error:');
      print('Some error happened in data.dart @ 36');
      print(e);
      print('-------');
    }
  }
  static void refresh() async {
    ArrivalFiles file = ArrivalFiles('client.json');

    try {
      file.delete();
    } catch(e) {
      print('-------');
      print('Arrival Error:');
      print('Could not delete file in data.dart @ 48');
      print(e);
      print('-------');
    }
  }
}
