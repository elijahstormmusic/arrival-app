/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../../posts/post.dart';
import '../../posts/page.dart';
import '../../posts/display.dart';
import '../../partners/page.dart';
import '../../styles.dart';
import '../../widgets/cards.dart';
import '../../data/arrival.dart';
import '../../data/preferences.dart';
import '../../data/socket.dart';
import '../../data/link.dart';
import 'row_card.dart';

class PostCard extends StatelessWidget {
  PostCard(this.post);

  final Post post;

  Widget _buildDetails() {
    return FrostyBackground(
      color: Styles.ArrivalPalletteBlueFrosted,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text.rich(
              TextSpan(
                style: Styles.postCardText,
                children: [
                  TextSpan(
                    text: post.user.name
                    + '  ',
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: '  ' + post.caption),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PostDisplay(post);
  }
}

class RowPost extends RowCard {
  final String cryptlink;

  RowPost(
    @required this.cryptlink,
  );

  @override
  Widget generate(Preferences prefs) {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0, bottom: 24),
      child: PostCard(ArrivalData.getPost(cryptlink)),
    );
  }
}