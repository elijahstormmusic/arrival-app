// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'data/cards/partners.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/close_button.dart';

class ArrivalTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 4),
      child: Text(
        'ARRIVAL',
        style: Styles.arrTitleText,
      ),
    );
  }
}

abstract class Styles {

  static const ArrivalPalletteRed = Color(0xffF15D5D);
  static const ArrivalPalletteCream = Color(0xffF9EDD3);
  static const ArrivalPalletteWhite = Color(0xffF8F8F9);
  static const ArrivalPalletteBlack = Color(0xff231F20);
  static const ArrivalPalletteGrey = Color(0xffD9D5D3);
  static const ArrivalPalletteBlue = Color(0xff5AA6DC);
  static const ArrivalPalletteYellow = Color(0xffFFCF01);
  static const _oldArrivalPalletteRed = Color.fromRGBO(243, 72, 62, 1);
  static const _oldArrivalPalletteYellow = Color.fromRGBO(255, 196, 60, 1);
  static const _oldArrivalPalletteCream = Color.fromRGBO(250, 250, 250, 1);
  static const ArrivalPalletteRedTransparent = Color(0xccF15D5D);
  static const ArrivalPalletteWhiteTransparent = Color(0xccF8F8F9);
  static const ArrivalPalletteCreamTransparent = Color(0xccF9EDD3);
  static const ArrivalPalletteGreyTransparent = Color(0xccD9D5D3);
  static const ArrivalPalletteBlackTransparent = Color(0xcc231F20);
  static const ArrivalPalletteBlueTransparent = Color(0x595AA6DC);
  static const ArrivalPalletteYellowTransparent = Color(0xccFFCF01);
  static const ArrivalPalletteRedFrosted = Color(0x50F58E8E);
  static const ArrivalPalletteWhiteFrosted = Color(0x80F9F4E9);
  static const ArrivalPalletteCreamFrosted = Color(0x80F3DAA5);
  static const ArrivalPalletteGreyFrosted = Color(0x80E8E7E6);
  static const ArrivalPalletteBlackFrosted = Color(0x80837979);
  static const ArrivalPalletteBlueFrosted = Color(0x8078B6E2);
  static const ArrivalPalletteYellowFrosted = Color(0x80FFE570);
  static const ArrivalPalletteClearFrosted = Color(0x80F9EDD3);

  static const Color mainColor = Styles.ArrivalPalletteRed;
  static const Color activeColor = Styles.ArrivalPalletteYellow;
  static const Color inactiveColor = Styles.ArrivalPalletteWhite;

  static const TextStyle arrTitleText = TextStyle(
        color: Color.fromRGBO(255, 255, 255, 1),
        fontFamily: 'UraeNium',
        fontSize: 42,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        letterSpacing: 3,
  );

  static Widget ArrivalErrorPage(BuildContext context, String err) => Padding(
    padding: EdgeInsets.all(42),
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Styles.ArrivalPalletteRed,
      ),
      child: Container(
        height: 300,
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: ArrCloseButton(() {
                  Navigator.of(context).pop();
                }),
              ),
            ),
            Center(
              child: Text(
                'error: ' + err,
                style: TextStyle(
                  color: Styles.ArrivalPalletteWhite,
                  fontFamily: 'BebasNeue',
                  fontSize: 42,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  static Widget ArrivalBlobRed = SvgPicture.asset('assets/design/blobs/red.svg');
  static Widget ArrivalBlobCream = SvgPicture.asset('assets/design/blobs/cream.svg');
  static Widget ArrivalBlobBlack = SvgPicture.asset('assets/design/blobs/black.svg');
  static Widget ArrivalBlobYellow = SvgPicture.asset('assets/design/blobs/yellow.svg');
  static Widget ArrivalBlobBlue = SvgPicture.asset('assets/design/blobs/blue.svg');


    /** Article Styling
     *
     */

  static const Color articleColorsDark = Styles.ArrivalPalletteBlack;
  static const Color articleColorsPrimary = Styles.ArrivalPalletteRed;
  static const Color articleColorsSecondary = Color(0xffF1EADA);

  static const TextStyle articleContent = TextStyle(
        color: Styles.articleColorsDark,
        // height: 1.6,
        // fontFamily: 'times',
        fontFamily: 'Helvetica',
        fontSize: 18,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
  );
  static const TextStyle articleQuote = TextStyle(
        color: Styles.articleColorsSecondary,
        // fontFamily: 'times',
        fontFamily: 'Helvetica',
        fontSize: 22,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
  );
  static const TextStyle articleQuoteStart = TextStyle(
        color: Styles.articleColorsSecondary,
        // fontFamily: 'times',
        fontFamily: 'Helvetica',
        fontSize: 50,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
  );
  static const TextStyle articleHeadline = TextStyle(
        color: Styles.articleColorsDark,
        // fontFamily: 'times',
        fontFamily: 'Helvetica',
        fontSize: 30,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
  );
  static const TextStyle smallerArticleHeadline = TextStyle(
        color: Styles.articleColorsDark,
        // fontFamily: 'times',
        fontFamily: 'Helvetica',
        fontSize: 24,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
  );
  static const TextStyle articleAuthor = TextStyle(
        color: Styles.articleColorsDark,
        // fontFamily: 'times',
        fontFamily: 'Helvetica',
        fontSize: 18,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
  );
  static const TextStyle articleDate = TextStyle(
        color: Styles.articleColorsDark,
        // fontF/amily: 'times',
        fontFamily: 'Helvetica',
        fontSize: 18,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.normal,
  );


      /** Sales Styling
       *
       */

  static const saleTitle = TextStyle(
      color: Styles.ArrivalPalletteBlack,
      fontFamily: 'Helvetica',
      fontSize: 24,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.bold,
  );



  static TextStyle headlineText(CupertinoThemeData themeData) => TextStyle(
        color: Styles.ArrivalPalletteBlack,
        fontFamily: 'UraeNium',
        fontSize: 32,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      );
  static TextStyle profileName = TextStyle(
        color: Color.fromRGBO(55, 55, 55, 1),
        fontFamily: 'Helvetica Neue',
        fontSize: 18,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      );
  static TextStyle postText = TextStyle(
        fontFamily: 'Helvetica Neue',
        fontSize: 18,
        color: const Color(0xff5f5f5f),
        height: 1.5,
      );

  static const minorText = TextStyle(
    color: Color.fromRGBO(128, 128, 128, 1),
    fontFamily: 'BebasNeue',
    fontSize: 32,
  );

  static TextStyle activeTabButton = TextStyle(
        color: Styles.ArrivalPalletteBlue,
        fontFamily: 'Helvetica',
        fontSize: 18,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      );

  static TextStyle headlineName(CupertinoThemeData themeData) => TextStyle(
        color: themeData.textTheme.textStyle.color,
        fontFamily: 'Helvetica',
        fontSize: 24,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      );

  static TextStyle headlineDescription(CupertinoThemeData themeData) =>
      TextStyle(
        color: themeData.textTheme.textStyle.color,
        fontFamily: 'BebasNeue',
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
      );

  static const cardTitleText = TextStyle(
    color: Styles.ArrivalPalletteBlack,
    fontFamily: 'Helvetica',
    fontSize: 32,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const postCardText = TextStyle(
    color: Styles.ArrivalPalletteBlack,
    fontFamily: 'Helvetica',
    fontSize: 20,
    fontStyle: FontStyle.normal,
  );

  static const cardCategoryText = TextStyle(
    color: Color.fromRGBO(255, 255, 255, 0.9),
    fontFamily: 'Helvetica',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const cardDescriptionText = TextStyle(
    color: Styles.ArrivalPalletteBlack,
    fontFamily: 'BebasNeue',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static TextStyle businessNameText = TextStyle(
        color: Styles.ArrivalPalletteBlack,
        fontFamily: 'Helvetica',
        fontSize: 30,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      );
  static TextStyle detailsTitleText(CupertinoThemeData themeData) => TextStyle(
        color: themeData.textTheme.textStyle.color,
        fontFamily: 'Helvetica',
        fontSize: 30,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      );

  static TextStyle detailsPreferredCategoryText(CupertinoThemeData themeData) =>
      TextStyle(
        color: themeData.textTheme.textStyle.color,
        fontFamily: 'Helvetica',
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      );

  static TextStyle detailsCategoryText(CupertinoThemeData themeData) =>
      TextStyle(
        color: themeData.textTheme.textStyle.color,
        fontFamily: 'Helvetica',
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
      );

  static TextStyle detailsDescriptionText(CupertinoThemeData themeData) =>
      TextStyle(
        color: themeData.textTheme.textStyle.color,
        fontFamily: 'BebasNeue',
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
      );

  static const detailsBoldDescriptionText = TextStyle(
    color: Styles.ArrivalPalletteBlack,
    fontFamily: 'BebasNeue',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const detailsAddressText = TextStyle(
    color: Color.fromRGBO(127, 127, 127, 0.9),
    fontFamily: 'BebasNeue',
    fontSize: 16,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
  );
  static const detailsLinkText = TextStyle(
    color: Styles.mainColor,
    fontFamily: 'BebasNeue',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );
  static const detailsBigLinkText = TextStyle(
    color: Styles.mainColor,
    fontFamily: 'BebasNeue',
    fontSize: 24,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );

  static const detailsServingHeaderText = TextStyle(
    color: Color.fromRGBO(176, 176, 176, 1),
    fontFamily: 'BebasNeue',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const noTextInput = TextStyle(
    color: Color.fromRGBO(106, 106, 106, 1),
    fontFamily: 'BebasNeue',
    fontSize: 20,
    fontStyle: FontStyle.italic,
  );
  static const shortBio = TextStyle(
    color: Styles.ArrivalPalletteBlack,
    fontFamily: 'BebasNeue',
    fontSize: 20,
    fontStyle: FontStyle.normal,
  );

  static TextStyle detailsServingLabelText(CupertinoThemeData themeData) =>
      TextStyle(
        color: themeData.textTheme.textStyle.color,
        fontFamily: 'BebasNeue',
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      );

  static TextStyle detailsServingValueText(CupertinoThemeData themeData) =>
      TextStyle(
        color: themeData.textTheme.textStyle.color,
        fontFamily: 'BebasNeue',
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
      );

  static TextStyle detailsServingNoteText(CupertinoThemeData themeData) =>
      TextStyle(
        color: themeData.textTheme.textStyle.color,
        fontFamily: 'BebasNeue',
        fontSize: 16,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.normal,
      );

  static TextStyle triviaFinishedTitleText(CupertinoThemeData themeData) =>
      TextStyle(
        color: themeData.textTheme.textStyle.color,
        fontFamily: 'Helvetica',
        fontSize: 32,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
      );

  static TextStyle triviaFinishedText(CupertinoThemeData themeData) =>
      TextStyle(
        color: themeData.textTheme.textStyle.color,
        fontFamily: 'BebasNeue',
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
      );

  static TextStyle triviaFinishedBigText(CupertinoThemeData themeData) =>
      TextStyle(
        color: themeData.textTheme.textStyle.color,
        fontFamily: 'Helvetica',
        fontSize: 48,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
      );

  static const appBackground = Styles.ArrivalPalletteCream;

  static Color scaffoldBackground(Brightness brightness) =>
      brightness == Brightness.light
          ? CupertinoColors.lightBackgroundGray
          : null;

  static Color searchBackground(CupertinoThemeData themeData) =>
      themeData.barBackgroundColor;

  static const frostedBackground = Color(0xccf8f8a3);

  static const closeButtonUnpressed = Color(0xff101010);

  static const closeButtonPressed = Color(0xff808080);

  static TextStyle searchText(CupertinoThemeData themeData) => TextStyle(
        color: Styles.ArrivalPalletteBlue,
        fontFamily: 'BebasNeue',
        fontSize: 24,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
      );

  static TextStyle settingsItemText(CupertinoThemeData themeData) =>
      themeData.textTheme.textStyle;

  static TextStyle settingsItemSubtitleText(CupertinoThemeData themeData) =>
      TextStyle(
        fontSize: 12,
        letterSpacing: -0.2,
        color: themeData.textTheme.textStyle.color,
      );

  static const Color searchCursorColor = Styles.ArrivalPalletteBlue;

  static const Color searchIconColor = Styles.ArrivalPalletteBlue;

  static const seasonColors = <Season, Color>{
    Season.winter: Color(0xff336dcc),
    Season.spring: Color(0xff2fa02b),
    Season.summer: Color(0xff287213),
    Season.autumn: Color(0xff724913),
  };

  // While handy, some of the Font Awesome icons sometimes bleed over their
  // allotted bounds. This padding is used to adjust for that.
  static const seasonIconPadding = {
    Season.winter: EdgeInsets.only(right: 0),
    Season.spring: EdgeInsets.only(right: 4),
    Season.summer: EdgeInsets.only(right: 6),
    Season.autumn: EdgeInsets.only(right: 0),
  };
  static const seasonIconData = {
    Season.winter: FontAwesomeIcons.snowflake,
    Season.spring: FontAwesomeIcons.leaf,
    Season.summer: FontAwesomeIcons.umbrellaBeach,
    Season.autumn: FontAwesomeIcons.canadianMapleLeaf,
  };
  static const seasonBorder = Border(
    top: BorderSide(color: Color(0xff606060)),
    left: BorderSide(color: Color(0xff606060)),
    bottom: BorderSide(color: Color(0xff606060)),
    right: BorderSide(color: Color(0xff606060)),
  );

  static const ratingIconPadding = {
    0: EdgeInsets.only(right: 0),
    1: EdgeInsets.only(right: 0),
  };
  static const ratingIconData = {
    0: FontAwesomeIcons.star,
    1: FontAwesomeIcons.solidStar,
    2: FontAwesomeIcons.starHalfAlt,
  };
  static const ratingBorder = Border(
    top: BorderSide(color: Color(0xff606060)),
    left: BorderSide(color: Color(0xff606060)),
    bottom: BorderSide(color: Color(0xff606060)),
    right: BorderSide(color: Color(0xff606060)),
  );
  static const ratingColors = <int, Color>{
    0: Color(0xcccccccc),
    1: Color(0xf8F18604),
    2: Color(0xddA15A02),
  };

  static const sandwich = IconData(
    0xf394,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );

  static const cloud = IconData(
    0xf398,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );

  static const uncheckedIcon = IconData(
    0xf372,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );

  static const checkedIcon = IconData(
    0xf373,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );

  static const transparentColor = Color(0x00000000);

  static const shadowColor = Color(0xa0000000);

  static const shadowGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [transparentColor, shadowColor],
  );

  static const Color settingsMediumGray = Color(0xffc7c7c7);

  static const Color settingsItemPressed = Color(0xffd9d9d9);

  static Color settingsItemColor(Brightness brightness) =>
      brightness == Brightness.light
          ? CupertinoColors.tertiarySystemBackground
          : CupertinoColors.darkBackgroundGray;

  static Color settingsLineation(Brightness brightness) =>
      brightness == Brightness.light ? Color(0xffbcbbc1) : Color(0xFF4C4B4B);

  static const Color settingsBackground = Color(0xffefeff4);

  static const Color settingsGroupSubtitle = Color(0xff777777);

  static const Color iconBlue = Color(0xff0000ff);
  static const Color iconMain = mainColor;
  static const Color iconGold = Color(0xffdba800);

  static const preferenceIcon = IconData(
    0xf443,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );
  static const profileIcon = IconData(
    0xf2d8,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );
  static const calorieIcon = IconData(
    0xf3bb,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );

  static const checkIcon = IconData(
    0xf383,
    fontFamily: CupertinoIcons.iconFont,
    fontPackage: CupertinoIcons.iconFontPackage,
  );

  static const heart = const IconData(0xf442,
          fontFamily: CupertinoIcons.iconFont,
          fontPackage: CupertinoIcons.iconFontPackage);
  static const heart_full = const IconData(0xf443,
          fontFamily: CupertinoIcons.iconFont,
          fontPackage: CupertinoIcons.iconFontPackage);
  static const comment = const IconData(0xf3fb,
          fontFamily: CupertinoIcons.iconFont,
          fontPackage: CupertinoIcons.iconFontPackage);
  static const share = const IconData(0xf473,
          fontFamily: CupertinoIcons.iconFont,
          fontPackage: CupertinoIcons.iconFontPackage);

  static const servingInfoBorderColor = Color(0xffb0b0b0);

  static const ColorFilter desaturatedColorFilter =
      // 222222 is a random color that has low color saturation.
      ColorFilter.mode(Color(0xFF222222), BlendMode.saturation);
}
