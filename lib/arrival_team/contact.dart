/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../data/socket.dart';
import '../users/data.dart';


class ContactUs extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<ContactUs> {

  String HTML = '';

  void _sendMessage() {
    if (HTML.length<10) return;
    socket.emit('contact us', {
      'name': UserData.client.name,
      'email': UserData.client.email,
      'message': HTML,
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Back',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                  child: SizedBox(
                    height: 300,
                    child: ListView(
                      children: [
                        Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
