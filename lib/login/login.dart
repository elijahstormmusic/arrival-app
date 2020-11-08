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
  LoginScreen.forgotPassword() {
    socket.emit('forgot password', {
      'email': UserData.client.email,
    });
  }

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      if (data.name.contains('\\/#\$\'\"'))
        return 'Some of those characters in the email are invaild';
      if (data.name=='')
        return 'Make sure to enter an email';
      if (data.password=='')
        return 'Make sure to enter a password';

      socket.emit('check user auth', {
        'email': data.name,
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
    return Future.delayed(loginTime).then((_) async {
      if (data.name.contains('\\/#\$\'\"'))
        return 'Some of those characters in the email are invaild';
      if (data.name=='')
        return 'Make sure to enter an email';
      if (data.password=='')
        return 'Make sure to enter a password';

      socket.emit('new app user', {
        'email': data.name,
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

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) async {
      if (name.contains('\\/#\$\'\"'))
        return 'Some of those characters in the email are invaild';
      if (name=='')
        return 'Make sure to enter an email';

      socket.emit('forgot password', {
        'email': name,
      });

      return await socket.check_vaildation();
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
      messages: LoginMessages(
        usernameHint: 'Email',
        passwordHint: 'Password',
        confirmPasswordHint: 'Confirm Password',
        loginButton: 'LOGIN',
        signupButton: 'REGISTER',
        forgotPasswordButton: 'Forgot Password?',
        recoverPasswordButton: 'SEND EMAIL',
        goBackButton: 'BACK',
        confirmPasswordError: 'Your password do not match',
        recoverPasswordIntro: 'Tell us your email',
        recoverPasswordDescription: 'Then we can help you set a new, secure password',
        recoverPasswordSuccess: 'Email Sent',
      ),
      theme: LoginTheme(
        primaryColor: Styles.ArrivalPalletteBlue,
        accentColor: Styles.ArrivalPalletteCream,
        errorColor: Styles.ArrivalPalletteBlue,
        pageColorLight: Styles.ArrivalPalletteRed,
        pageColorDark: Styles.ArrivalPalletteRed,
        // beforeHeroFontSize: 50,
        // afterHeroFontSize: 20,
        bodyStyle: TextStyle(
          fontStyle: FontStyle.italic,
        ),
        textFieldStyle: TextStyle(
          color: Styles.ArrivalPalletteBlue,
          // shadows: [Shadow(color: Styles.ArrivalPalletteYellow, blurRadius: 2)],
        ),
        buttonStyle: TextStyle(
          fontWeight: FontWeight.w800,
          color: Styles.ArrivalPalletteCream,
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
            backgroundColor: Styles.ArrivalPalletteCream,
            color: Styles.ArrivalPalletteRed,
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
          splashColor: Styles.ArrivalPalletteBlue,
          backgroundColor: Styles.ArrivalPalletteRed,
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
        if (value=='')
          return 'Email cannot be blank';
        if (!value.contains('@') || (!value.endsWith('.com') && !value.endsWith('.edu') && !value.endsWith('.gov') && !value.endsWith('.net') && !value.endsWith('.org'))) {
          return "Email must contain '@' and end with '.[***]'";
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
      },
      showDebugButtons: false,
    );
  }
}
