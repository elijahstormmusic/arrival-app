import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

class exampleStore extends StatelessWidget {
  exampleStore({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 175.0, 175.0),
          size: Size(175.0, 177.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child:
              // Adobe XD layer: 'storeBackground' (shape)
              Container(
            decoration: BoxDecoration(
              color: const Color(0xffececec),
              border: Border.all(width: 8.0, color: const Color(0xffececec)),
            ),
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 174.3, 175.3),
          size: Size(175.0, 177.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child:
              // Adobe XD layer: 'storeImage' (shape)
              Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(''),
                fit: BoxFit.fill,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.58), BlendMode.dstIn),
              ),
            ),
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(5.0, 97.0, 159.0, 80.0),
          size: Size(175.0, 177.0),
          pinLeft: true,
          pinRight: true,
          pinBottom: true,
          fixedHeight: true,
          child:
              // Adobe XD layer: 'storeName' (text)
              SingleChildScrollView(
                  child: Text(
            'Mass St. Music\n',
            style: TextStyle(
              fontFamily: 'Helvetica Neue',
              fontSize: 32,
              color: const Color(0xff000000),
              fontWeight: FontWeight.w700,
              height: 1,
            ),
            textAlign: TextAlign.right,
          )),
        ),
      ],
    );
  }
}
