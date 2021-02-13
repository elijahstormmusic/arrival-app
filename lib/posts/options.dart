/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

import '../arrival_team/report.dart';
import '../data/socket.dart';
import '../data/link.dart';
import '../data/preferences.dart';
import '../users/data.dart';
import '../screens/home.dart';
import '../widgets/dialog.dart';
import '../styles.dart';
import '../const.dart';
import 'post.dart';


class PostOptions extends StatelessWidget {
  Post post;
  Preferences prefs;

  PostOptions(@required this.prefs, @required this.post);

  @override
  Widget build(BuildContext context) =>
    post.user.cryptlink == UserData.client.cryptlink ?
      SimpleDialog(
        title: Text('Actions for Your Post (* = doesnt work yet)'),
        children: [
          ArrivalDialogItem(
            icon: Icons.person,
            color: Styles.ArrivalPalletteGrey,
            text: 'Tag Someone * (WIP)',
            onPressed: () {
              // socket
            },
          ),
          ArrivalDialogItem(
            icon: Icons.content_copy,
            color: Styles.ArrivalPalletteGrey,
            text: 'Copy Link',
            onPressed: () {
              FlutterClipboard.copy(Constants.site + 'p?${post.cryptlink}')
                .then((_) => HomeScreen.openSnackBar({
                  'text': 'Link Copied',
                  'duration': 3,
                }));
              Navigator.of(context).pop();
            },
          ),
          ArrivalDialogItem(
            icon: Icons.folder_open,
            color: Styles.ArrivalPalletteGrey,
            text: 'Archive',
            onPressed: () {
              socket.emit('posts archive', {
                'link': post.cryptlink,
                'archive': true,
              });
              Navigator.of(context).pop();
            },
          ),
          ArrivalDialogItem(
            icon: Icons.edit,
            color: Styles.ArrivalPalletteGrey,
            text: 'Edit * (WIP)',
            onPressed: () {
              // socket
            },
          ),
          ArrivalDialogItem(
            icon: Icons.comment,
            color: Styles.ArrivalPalletteGrey,
            text: 'Stop Comments',
            onPressed: () {
              socket.emit('posts stop comments', {
                'link': post.cryptlink,
                'stop': true,
              });
              Navigator.of(context).pop();
            },
          ),
          ArrivalDialogItem(
            icon: Icons.delete,
            color: Styles.ArrivalPalletteGrey,
            text: 'Delete',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Post'),
                    content: Text('''This action cannot be undone. Your likes,
                      shares, and comments for this post will also be deleted.
                      Consider Archiving the post instead, to hide it from the
                      public but keep it for the future.'''),
                    actions: [
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed:  () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Delete'),
                        onPressed:  () {
                          Navigator.of(context).pop();
                          socket.emit('posts delete', {
                            'link': post.cryptlink,
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      )
      : SimpleDialog(
        title: Text('Post Actions (* = doesnt work yet)'),
        children: [
          ArrivalDialogItem(
            icon: Icons.warning,
            color: Styles.ArrivalPalletteGrey,
            text: 'Report this Post',
            onPressed: () {
              Navigator.of(context).pop();

              Arrival.navigator.currentState.push(MaterialPageRoute(
                builder: (context) => ReportItemContactSheet.post(post.cryptlink),
                fullscreenDialog: true,
              ));
            },
          ),
          ArrivalDialogItem(
            icon: Icons.content_copy,
            color: Styles.ArrivalPalletteGrey,
            text: 'Copy Link',
            onPressed: () {
              FlutterClipboard.copy(Constants.site + 'p?${post.cryptlink}')
                .then((_) => HomeScreen.openSnackBar({
                  'text': 'Link Copied',
                  'duration': 3,
                }));
              Navigator.of(context).pop();
            },
          ),
          ArrivalDialogItem(
            icon: Icons.warning,
            color: Styles.ArrivalPalletteGrey,
            text: 'Block this User',
            onPressed: () {
              socket.emit('userdata block', {
                'user': UserData.client.cryptlink,
                'block': post.user.cryptlink,
                'action': true,
              });
              Navigator.of(context).pop();
            },
          ),
          // ArrivalDialogItem(
          //   icon: Icons.person_remove,
          //   color: Styles.ArrivalPalletteGrey,
          //   text: 'Unfollow User',
          //   onPressed: () {
          //     socket.emit('userdata follow', {
          //       'user': UserData.client.cryptlink,
          //       'follow': post.user.cryptlink,
          //       'action': false,
          //     });
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      );
}
