/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../arrival_team/report.dart';
import '../data/socket.dart';
import '../data/link.dart';
import '../users/data.dart';
import '../widgets/dialog.dart';
import '../styles.dart';
import '../const.dart';
import 'post.dart';


class PostOptions extends StatelessWidget {
  Post post;

  PostOptions(@required this.post);

  @override
  Widget build(BuildContext context) =>
    post.user.cryptlink == UserData.client.cryptlink ?
      SimpleDialog(
        title: Text('Actions for Your Post (* = dosnt work yet)'),
        children: [
          SimpleDialogItem(
            icon: Icons.person,
            color: Styles.ArrivalPalletteGrey,
            text: 'Tag Someone *',
            onPressed: () {
              // socket
            },
          ),
          SimpleDialogItem(
            icon: Icons.content_copy,
            color: Styles.ArrivalPalletteGrey,
            text: 'Copy Link',
            onPressed: () {
              ClipboardManager.copyToClipBoard(Constants.site + 'p?${widget.post.cryptlink}').then((result) {
                HomeScreen.openSnackBar({
                  'text': 'Link Copied',
                  'duration': 3,
                });
              });
            },
          ),
          SimpleDialogItem(
            icon: Icons.folder_open,
            color: Styles.ArrivalPalletteGrey,
            text: 'Archive',
            onPressed: () {
              socket.emit('posts archive', {
                'link': widget.post.cryptlink,
                'archive': true,
              });
            },
          ),
          SimpleDialogItem(
            icon: Icons.edit,
            color: Styles.ArrivalPalletteGrey,
            text: 'Edit *',
            onPressed: () {
              // socket
            },
          ),
          SimpleDialogItem(
            icon: Icons.comment,
            color: Styles.ArrivalPalletteGrey,
            text: 'Stop Comments',
            onPressed: () {
              socket.emit('posts stop comments', {
                'link': widget.post.cryptlink,
                'stop': true,
              });
            },
          ),
          SimpleDialogItem(
            icon: Icons.delete,
            color: Styles.ArrivalPalletteGrey,
            text: 'Delete',
            onPressed: () {
              socket.emit('posts delete', {
                'link': widget.post.cryptlink,
              });
            },
          ),
        ],
      )
      : SimpleDialog(
        title: Text('Post Actions'),
        children: [
          SimpleDialogItem(
            icon: Icons.warning,
            color: Styles.ArrivalPalletteGrey,
            text: 'Report this Post',
            onPressed: () {
              Navigator.of(context).pop();

              Arrival.navigator.currentState.push(MaterialPageRoute(
                builder: (context) => ReportItemContactSheet(post.cryptlink),
                fullscreenDialog: true,
              ));
            },
          ),
          SimpleDialogItem(
            icon: Icons.content_copy,
            color: Styles.ArrivalPalletteGrey,
            text: 'Copy Link',
            onPressed: () {
              ClipboardManager.copyToClipBoard(Constants.site + 'p?${widget.post.cryptlink}').then((result) {
                HomeScreen.openSnackBar({
                  'text': 'Link Copied',
                  'duration': 3,
                });
              });
            },
          ),
          SimpleDialogItem(
            icon: Icons.person_remove,
            color: Styles.ArrivalPalletteGrey,
            text: 'Unfollow User',
            onPressed: () {
              socket.emit('userdata follow', {
                'user': UserData.client.cryptlink,
                'follow': widget.post.user.cryptlink,
                'action': false,
              });
            },
          ),
        ],
      );
}
