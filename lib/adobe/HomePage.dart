import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './UserProfilePlacard.dart';
import './examplePost.dart';
import './exampleNewsArticle.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd33731),
      body: Stack(
        children: <Widget>[
          Pinned.fromSize(
            bounds: Rect.fromLTWH(18.0, 26.0, 387.0, 205.0),
            size: Size(412.0, 1600.0),
            pinLeft: true,
            pinRight: true,
            pinTop: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'UserProfilePlacard' (component)
                UserProfilePlacard(),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(18.0, 255.0, 376.0, 30.0),
            size: Size(412.0, 1600.0),
            pinLeft: true,
            pinRight: true,
            pinTop: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'newsForYouTitle' (text)
                Text(
              'News For You:',
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 22,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(19.0, 504.0, 375.0, 1077.0),
            size: Size(412.0, 1600.0),
            pinLeft: true,
            pinRight: true,
            pinBottom: true,
            fixedHeight: true,
            child:
                // Adobe XD layer: 'newsScrollGroupBack…' (shape)
                Container(
              decoration: BoxDecoration(),
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(18.0, 604.0, 376.0, 30.0),
            size: Size(412.0, 1600.0),
            pinLeft: true,
            pinRight: true,
            fixedHeight: true,
            child:
            // Adobe XD layer: 'postsForYouTitle' (text)
            Text(
              'Posts For You:',
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 22,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          // Pinned.fromSize(
          //   bounds: Rect.fromLTWH(17.0, 504.5, 378.0, 1087.0),
          //   size: Size(412.0, 1600.0),
          //   pinLeft: true,
          //   pinRight: true,
          //   pinBottom: true,
          //   fixedHeight: true,
          //   child:
          //       // Adobe XD layer: 'postsGroupRepeater' (none)
          //       GridView.count(
          //     mainAxisSpacing: 20,
          //     crossAxisSpacing: 20,
          //     crossAxisCount: 1,
          //     childAspectRatio: 1.75,
          //     children: [{}, {}, {}, {}, {}].map((map) {
          //       return
          //           // Adobe XD layer: 'examplePost' (component)
          //           SizedBox(
          //         width: 363.0,
          //         height: 201.0,
          //         child: Stack(
          //           children: <Widget>[
          //             Pinned.fromSize(
          //               bounds: Rect.fromLTWH(0.0, 0.0, 363.0, 201.0),
          //               size: Size(363.0, 201.0),
          //               pinLeft: true,
          //               pinRight: true,
          //               pinTop: true,
          //               pinBottom: true,
          //               child:
          //                   // Adobe XD layer: 'examplePostBackgrou…' (shape)
          //                   Container(
          //                 decoration: BoxDecoration(
          //                   color: const Color(0xffe8e8e8),
          //                   border: Border.all(
          //                       width: 15.0, color: const Color(0xffe8e8e8)),
          //                 ),
          //               ),
          //             ),
          //             Pinned.fromSize(
          //               bounds: Rect.fromLTWH(1.5, 0.0, 255.0, 29.0),
          //               size: Size(363.0, 201.0),
          //               pinLeft: true,
          //               pinRight: true,
          //               pinTop: true,
          //               fixedHeight: true,
          //               child:
          //                   // Adobe XD layer: 'examplePostTitle' (text)
          //                   Text(
          //                 'Example Post',
          //                 style: TextStyle(
          //                   fontFamily: 'Helvetica Neue',
          //                   fontSize: 22,
          //                   color: const Color(0xff5f5f5f),
          //                   fontWeight: FontWeight.w700,
          //                 ),
          //                 textAlign: TextAlign.left,
          //               ),
          //             ),
          //             Pinned.fromSize(
          //               bounds: Rect.fromLTWH(10.5, 34.0, 342.0, 45.0),
          //               size: Size(363.0, 201.0),
          //               pinLeft: true,
          //               pinRight: true,
          //               fixedHeight: true,
          //               child:
          //                   // Adobe XD layer: 'examplePostBulletpo…' (text)
          //                   SingleChildScrollView(
          //                       child: Text(
          //                 '- This business fits your interest in Music\n- Get discounts on this business’ Beats\n',
          //                 style: TextStyle(
          //                   fontFamily: 'Helvetica Neue',
          //                   fontSize: 16,
          //                   color: const Color(0xff5f5f5f),
          //                   height: 1.5,
          //                 ),
          //                 textAlign: TextAlign.left,
          //               )),
          //             ),
          //             Pinned.fromSize(
          //               bounds: Rect.fromLTWH(10.5, 97.0, 342.0, 104.0),
          //               size: Size(363.0, 201.0),
          //               pinLeft: true,
          //               pinRight: true,
          //               pinBottom: true,
          //               fixedHeight: true,
          //               child:
          //                   // Adobe XD layer: 'examplePostBody' (text)
          //                   Text.rich(
          //                 TextSpan(
          //                   style: TextStyle(
          //                     fontFamily: 'Helvetica Neue',
          //                     fontSize: 16,
          //                     color: const Color(0xff5f5f5f),
          //                     height: 1.5,
          //                   ),
          //                   children: [
          //                     TextSpan(
          //                       text: 'From Post:',
          //                       style: TextStyle(
          //                         fontStyle: FontStyle.italic,
          //                         fontWeight: FontWeight.w700,
          //                       ),
          //                     ),
          //                     TextSpan(
          //                       text:
          //                           ' Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi aliquet dui est, nec vulputate justo hendrerit id. Sed eu ex aliquet, porta eros sit amet, condimentum orci.',
          //                     ),
          //                   ],
          //                 ),
          //                 textAlign: TextAlign.left,
          //               ),
          //             ),
          //           ],
          //         ),
          //       );
          //     }).toList(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
