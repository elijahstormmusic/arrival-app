/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import 'custom_route.dart';

import '../users/data.dart';
import '../data/link.dart';
import '../data/socket.dart';
import '../styles.dart';


class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  LoginScreen() {

  }
  LoginScreen.login(String username, String password) {

  }
  LoginScreen.forgotUsername(String email) {

  }
  LoginScreen.forgotPassword(String username) {

  }

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {

      socket.emit('check user auth', {
        'name': data.name,
        'pass': data.password,
      });

      String response = await socket.check_vaildation();

      if (response[0]=='>') {
        socket.emit('client set state', {
          'link': response.substring(1, response.length),
          'password': data.password,
        });
        UserData.password = data.password;
        response = null;
      }

      return response;
    });
  }
  Future<String> _signupNewUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      // if (!mockUsers.containsKey(data.name)) {
      //   return 'Username not exists';
      // }
      // if (mockUsers[data.name] != data.password) {
      //   return 'Password does not match';
      // }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      // if (!mockUsers.containsKey(name)) {
      //   return 'Username not exists';
      // }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {

    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );

    return FlutterLogin(
      title: '',
      logo: 'assets/arrival/titleasset.png',
      logoTag: 'ArrivalKC.logo',
      // messages: LoginMessages(
      //   usernameHint: 'Username',
      //   passwordHint: 'Pass',
      //   confirmPasswordHint: 'Confirm',
      //   loginButton: 'LOG IN',
      //   signupButton: 'REGISTER',
      //   forgotPasswordButton: 'Forgot huh?',
      //   recoverPasswordButton: 'HELP ME',
      //   goBackButton: 'GO BACK',
      //   confirmPasswordError: 'Not match!',
      //   recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
      //   recoverPasswordDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
      //   recoverPasswordSuccess: 'Password rescued successfully',
      // ),
      theme: LoginTheme(
        primaryColor: Styles.ArrivalPalletteRed,
        accentColor: Styles.ArrivalPalletteCream,
        errorColor: Styles.ArrivalPalletteBlue,
        pageColorLight: Styles.ArrivalPalletteRed,
        pageColorDark: Styles.ArrivalPalletteRed,
        // beforeHeroFontSize: 50,
        // afterHeroFontSize: 20,
        bodyStyle: TextStyle(
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ),
        textFieldStyle: TextStyle(
          color: Styles.ArrivalPalletteBlue,
          shadows: [Shadow(color: Styles.ArrivalPalletteYellow, blurRadius: 2)],
        ),
        buttonStyle: TextStyle(
          fontWeight: FontWeight.w800,
          color: Styles.ArrivalPalletteYellow,
        ),
        cardTheme: CardTheme(
          color: Styles.ArrivalPalletteCream,
          elevation: 5,
          margin: EdgeInsets.only(top: 15),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Styles.ArrivalPalletteRed.withOpacity(.1),
          contentPadding: EdgeInsets.zero,
          errorStyle: TextStyle(
            backgroundColor: Styles.ArrivalPalletteBlue,
            color: Styles.ArrivalPalletteWhite,
          ),
          labelStyle: TextStyle(fontSize: 12),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
            borderRadius: inputBorder,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
            borderRadius: inputBorder,
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade700, width: 7),
            borderRadius: inputBorder,
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade400, width: 8),
            borderRadius: inputBorder,
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Styles.ArrivalPalletteGrey, width: 5),
            borderRadius: inputBorder,
          ),
        ),
        buttonTheme: LoginButtonTheme(
          splashColor: Colors.purple,
          backgroundColor: Colors.pinkAccent,
          highlightColor: Colors.lightGreen,
          elevation: 9.0,
          highlightElevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          // shape: CircleBorder(side: BorderSide(color: Colors.green)),
          // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
        ),
      ),
      emailValidator: (value) {
        if (!value.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        return _loginUser(loginData);
      },
      onSignup: (loginData) {
        return _signupNewUser(loginData);
      },
      onSubmitAnimationCompleted: () {
        Arrival.navigator.currentState.pop();
      },
      onRecoverPassword: (name) {
        return _recoverPassword(name);
        // Show new password dialog
      },
      showDebugButtons: false,
    );
  }
}
