/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dash_chat/dash_chat.dart';

import '../../arrival_team/report.dart';
import '../../data/socket.dart';
import '../../data/link.dart';
import '../../data/preferences.dart';
import '../../users/data.dart';
import '../../screens/home.dart';
import '../../widgets/dialog.dart';
import '../../styles.dart';
import '../../const.dart';


class ChatAvatarOptions extends StatelessWidget {
  String userlink;
  Preferences prefs;

  ChatAvatarOptions(@required this.prefs, @required this.userlink);

  @override
  Widget build(BuildContext context) =>
      SimpleDialog(
        // title: Text('Post Actions'),
        children: [
          ArrivalDialogItem(
            icon: Icons.warning,
            color: Styles.ArrivalPalletteGrey,
            text: 'Report',
            onPressed: () {
              Navigator.of(context).pop();

              Arrival.navigator.currentState.push(MaterialPageRoute(
                builder: (context) => ReportItemContactSheet.user(userlink),
                fullscreenDialog: true,
              ));
            },
          ),
          ArrivalDialogItem(
            icon: Icons.warning,
            color: Styles.ArrivalPalletteGrey,
            text: 'Block this User',
            onPressed: () {
              socket.emit('userdata block', {
                'user': UserData.client.cryptlink,
                'block': userlink,
                'action': true,
              });
              Navigator.of(context).pop();
            },
          ),
          ArrivalDialogItem(
            icon: Icons.do_not_disturb,
            color: Styles.ArrivalPalletteGrey,
            text: 'Mute This User',
            onPressed: () {
              socket.emit('userdata mute', {
                'user': UserData.client.cryptlink,
                'mute': userlink,
                'action': true,
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      );
}

class ChatMessageOptions extends StatelessWidget {
  ChatMessage message;
  Preferences prefs;

  ChatMessageOptions(@required this.prefs, @required this.message);

  @override
  Widget build(BuildContext context) =>
    message.user == UserData.client.cryptlink ?
      SimpleDialog(
        children: [
          ArrivalDialogItem(
            icon: Icons.content_copy,
            color: Styles.ArrivalPalletteGrey,
            text: 'Copy',
            onPressed: () {
              FlutterClipboard.copy(message.text)
                .then((_) => HomeScreen.openSnackBar({
                  'text': 'Link Copied',
                  'duration': 3,
                }));
              Navigator.of(context).pop();
            },
          ),
          ArrivalDialogItem(
            icon: Icons.delete,
            color: Styles.ArrivalPalletteGrey,
            text: 'Erase',
            onPressed: () {

            },
          ),
        ],
      )
      : SimpleDialog(
        children: [
          ArrivalDialogItem(
            icon: Icons.warning,
            color: Styles.ArrivalPalletteGrey,
            text: 'Report',
            onPressed: () {
              Navigator.of(context).pop();

              Arrival.navigator.currentState.push(MaterialPageRoute(
                builder: (context) => ReportItemContactSheet.chatMessage('post.cryptlink'),
                fullscreenDialog: true,
              ));
            },
          ),
          ArrivalDialogItem(
            icon: Icons.content_copy,
            color: Styles.ArrivalPalletteGrey,
            text: 'Copy',
            onPressed: () {
              FlutterClipboard.copy(message.text)
                .then((_) => HomeScreen.openSnackBar({
                  'text': 'Link Copied',
                  'duration': 3,
                }));
              Navigator.of(context).pop();
            },
          ),
        ],
      );
}
