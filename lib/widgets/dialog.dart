/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


Widget SimpleDialogItem({IconData icon, Color color, String text, VoidCallback onPressed}) {
  return SimpleDialogOption(
    onPressed: onPressed,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 36.0, color: color),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16.0),
          child: Text(text),
        ),
      ],
    ),
  );
}
