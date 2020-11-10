// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../partners/partner.dart';
import '../../data/link.dart';
import '../../partners/page.dart';
import '../../styles.dart';

class ZoomClipAssetImage extends StatelessWidget {
  const ZoomClipAssetImage(
      {@required this.zoom,
      this.height,
      this.width,
      @required this.imageAsset});

  final double zoom;
  final double height;
  final double width;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: OverflowBox(
          maxHeight: height * zoom,
          maxWidth: width * zoom,
          child: Image.asset(
            imageAsset,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  const StarRating({@required this.rating,});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        for (var i=1;i<6;i++) ...[
          SizedBox(width: 5),
          Icon(
            Styles.ratingIconData[i<rating ? 1 : (i-1<rating && rating%1>0.5 ? 2 : 0)],
            semanticLabel: rating.toString(),
            size: 12,
            color: Styles.ratingColors[i<rating ? 1 : (i-1<rating && rating%1>0.5 ? 2 : 0)],
          ),
        ],
      ],
    );
  }
}

class SearchResult {
  final result;
  const SearchResult(this.result);

  List<Widget> designer(CupertinoThemeData themeData, double width) => [];

  Widget generate(BuildContext context, double width) {
    final themeData = CupertinoTheme.of(context);

    return GestureDetector(
      onTap: () => Arrival.navigator.currentState.push(MaterialPageRoute(
        builder: (context) => result.navigateTo(),
        fullscreenDialog: true,
      )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: designer(themeData, width),
      ),
    );
  }
}

class SearchResultPartner extends SearchResult {
  final result;
  const SearchResultPartner(this.result) : super(result);

  final double _imageWidth = 72;
  final double _imageHeight = 72;

  @override
  List<Widget> designer(CupertinoThemeData themeData, double width) => [
      Image.network(
        result.images.logo,
        fit: BoxFit.fitHeight,
        height: _imageWidth,
        width: _imageHeight,
      ),
      SizedBox(width: 8),
      Container(
        width: width - _imageWidth - 8,
        height: _imageHeight + 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    result.name,
                    style: Styles.headlineName(themeData),
                  ),
                ),
              ],
            ),
            StarRating(rating: result.rating,),
            Expanded(
              child: Text(
                result.shortDescription,
                style: Styles.headlineDescription(themeData),
              ),
            ),
          ],
        ),
      ),
    ];
}
class SearchResultArticle extends SearchResult {
  final result;
  const SearchResultArticle(this.result) : super(result);

  final double _imageWidth = 72;
  final double _imageHeight = 72;

  @override
  List<Widget> designer(CupertinoThemeData themeData, double width) => [
    Image.network(
      result.image_link(0),
      fit: BoxFit.fitHeight,
      height: _imageWidth,
      width: _imageHeight,
    ),
    SizedBox(width: 8),
    Container(
      width: width - _imageWidth - 8,
      height: _imageHeight + 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  result.title,
                  style: Styles.headlineName(themeData),
                ),
              ),
            ],
          ),
          Expanded(
            child: Text(
              result.author,
              style: Styles.headlineDescription(themeData),
            ),
          ),
          Expanded(
            child: Text(
              result.short_intro.substring(0, result.short_intro.length < 50 ? result.short_intro.length : 50) + ' ...',
              style: Styles.headlineDescription(themeData),
            ),
          ),
        ],
      ),
    ),
  ];
}
class SearchResultPost extends SearchResult {
  final result;
  const SearchResultPost(this.result) : super(result);

  final double _imageWidth = 72;
  final double _imageHeight = 72;

  @override
  List<Widget> designer(CupertinoThemeData themeData, double width) => [
      Image.network(
        result.media_href(),
        fit: BoxFit.fitHeight,
        height: _imageWidth,
        width: _imageHeight,
      ),
      SizedBox(width: 8),
      Container(
        width: width - _imageWidth - 8,
        height: _imageHeight + 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    result.user.name,
                    style: Styles.headlineName(themeData),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Text(
                result.caption,
                style: Styles.headlineDescription(themeData),
              ),
            ),
          ],
        ),
      )
    ];
}
class SearchResultSale extends SearchResult {
  final result;
  const SearchResultSale(this.result) : super(result);

  final double _imageWidth = 72;
  final double _imageHeight = 72;

  @override
  List<Widget> designer(CupertinoThemeData themeData, double width) => [
      Image.network(
        result.media_href(),
        fit: BoxFit.fitHeight,
        height: _imageWidth,
        width: _imageHeight,
      ),
      SizedBox(width: 8),
      Container(
        width: width - _imageWidth - 8,
        height: _imageHeight + 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    result.name,
                    style: Styles.headlineName(themeData),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Text(
                result.shortDescription,
                style: Styles.headlineDescription(themeData),
              ),
            ),
          ],
        ),
      )
    ];
}
class SearchResultProfile extends SearchResult {
  final result;
  const SearchResultProfile(this.result) : super(result);

  final double _imageWidth = 72;
  final double _imageHeight = 72;

  @override
  List<Widget> designer(CupertinoThemeData themeData, double width) => [
      CircleAvatar(
        radius: _imageWidth / 2,
        backgroundImage: NetworkImage(
          result.media_href(),
        ),
      ),
      SizedBox(width: 8),
      Container(
        width: width - _imageWidth - 8,
        height: _imageHeight + 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    result.name,
                    style: Styles.headlineName(themeData),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Text(
                result.shortBio,
                style: Styles.headlineDescription(themeData),
              ),
            ),
          ],
        ),
      )
    ];
}
