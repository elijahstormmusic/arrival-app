import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

class examplePost extends StatelessWidget {
  examplePost({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 363.0, 201.0),
          size: Size(363.0, 201.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child:
              // Adobe XD layer: 'examplePostBackgrou…' (shape)
              Container(
            decoration: BoxDecoration(
              color: const Color(0xffe8e8e8),
              border: Border.all(width: 15.0, color: const Color(0xffe8e8e8)),
            ),
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(1.5, 0.0, 255.0, 29.0),
          size: Size(363.0, 201.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          fixedHeight: true,
          child:
              // Adobe XD layer: 'examplePostTitle' (text)
              Text(
            'Example Post',
            style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: 22,
              color: const Color(0xff5f5f5f),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(10.5, 34.0, 342.0, 45.0),
          size: Size(363.0, 201.0),
          pinLeft: true,
          pinRight: true,
          fixedHeight: true,
          child:
              // Adobe XD layer: 'examplePostBulletpo…' (text)
              SingleChildScrollView(
                  child: Text(
            '- This business fits your interest in Music\n- Get discounts on this business’ Beats\n',
            style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: 16,
              color: const Color(0xff5f5f5f),
              height: 1.5,
            ),
            textAlign: TextAlign.left,
          )),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(10.5, 97.0, 342.0, 104.0),
          size: Size(363.0, 201.0),
          pinLeft: true,
          pinRight: true,
          pinBottom: true,
          fixedHeight: true,
          child:
              // Adobe XD layer: 'examplePostBody' (text)
              Text.rich(
            TextSpan(
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 16,
                color: const Color(0xff5f5f5f),
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: 'From Post:',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text:
                      ' Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi aliquet dui est, nec vulputate justo hendrerit id. Sed eu ex aliquet, porta eros sit amet, condimentum orci.',
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
