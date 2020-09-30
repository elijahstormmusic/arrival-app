/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../data/socket.dart';
import '../users/data.dart';
import '../styles.dart';


class ContactUs extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<ContactUs> {

  String _messageSubject = '';
  String _messageBody = '';
  String _errText = '';
  final _subjectInputController = TextEditingController();
  final _bodyInputController = TextEditingController();
  final _focusNode = FocusNode();
  final _fontSize = 16.0;
  bool _allowMessageSend = true;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _setMessages() {
    _messageSubject = _subjectInputController.text;
    _messageBody = _bodyInputController.text;

    if (_messageSubject=='') _messageSubject = 'Feedback: No subject';
  }
  int _checkIfSendable() {
    _setMessages();

    if (_messageSubject.length<10) {
      _errorReport('Message needs to be at least 10 characters long.');
      return 1;
    }
    if (socket==null) {
      _errorReport('Could not send message right now, please retry soon.');
      return 2;
    }

    _errorReport('');
    return 0;
  }
  void _onChanged(String str) {
    _checkIfSendable();
  }

  void _errorReport(String reason) {
    setState(() => _errText = reason);
  }
  void _sendMessage() async {
    if (_checkIfSendable()!=0) return;

    if (!_allowMessageSend) return;
    _allowMessageSend = false;
    socket.emit('contact us', {
      'sender': {
        'name': UserData.client.name,
        'email': UserData.client.email,
        'link': UserData.client.cryptlink,
      },
      'message': {
        'subject': _messageSubject,
        'body': _messageBody,
      },
    });

    await Future.delayed(const Duration(seconds: 20));
    _allowMessageSend = true;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Back',
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(27, 5, 27, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: Text(
                        _errText,
                        style: TextStyle(
                          color: Styles.ArrivalPalletteRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: _sendMessage,
                      child: Icon(
                        Styles.share,
                        size: 50.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: Container(
                height: 65.0,
                child: CupertinoTextField(
                  controller: _subjectInputController,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  placeholder: 'Subject',
                  placeholderStyle: TextStyle(fontSize: _fontSize, color: Colors.black54),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black38,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  onChanged: _onChanged,
                ),
                padding: EdgeInsets.fromLTRB(12.0,12.0,12.0,6.0),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
              child: Container(
                height: MediaQuery.of(context).size.height - 300.0,
                child: CupertinoTextField(
                  controller: _bodyInputController,
                  placeholder: 'You message here will be read by the Arrival team, '
                    + 'and we will do our best to reply to your message in a timely manner.',
                  placeholderStyle: TextStyle(fontSize: _fontSize, color: Colors.black54),
                  textAlignVertical: TextAlignVertical(y: -0.95),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black38,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  maxLines: 300,
                  onChanged: _onChanged,
                ),
                padding: EdgeInsets.fromLTRB(12.0,12.0,12.0,6.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
