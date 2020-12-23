/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

import '../data/preferences.dart';
import '../widgets/cards.dart';
import '../styles.dart';


class CasingFavorites extends StatefulWidget {

  void open(Map<String, dynamic> data) {}
  Map<String, dynamic> generateListData(int index) => {};
  int listSize() => 0;
  void explore() => {};
  String getExploreText() => 'explore';

  @override
  State<CasingFavorites> createState() => _CasingCircle();
}
class CasingFavoritesBox extends StatefulWidget {

  void open(Map<String, dynamic> data) {}
  Map<String, dynamic> generateListData(int index) => {};
  int listSize() => 0;
  void explore() => {};
  String getExploreText() => 'explore';
  int bookmarkableType() => 99;

  @override
  State<CasingFavoritesBox> createState() => _CasingBox();
}


class _CasingCircle extends State<CasingFavorites> {

  List<Map<String, dynamic>> _rowButtonListData;
  TextStyle _bookmarkLabel = TextStyle(
    fontWeight: FontWeight.bold,
  );

  Map<String, dynamic> _generateGenericListData(int index) {
    var result = widget.generateListData(index);
    // result['seen'] = false;
    return result;
  }
  String getNavigationLink(int index) {
    if (index<0 && index>=_rowButtonListData.length) return '';
    // _rowButtonListData[index]['seen'] = true;
    return _rowButtonListData[index]['cryptlink'];
  }
  void _openGenericAction(int index) {
    if (index<0 && index>=_rowButtonListData.length) return;
    widget.open(_rowButtonListData[index]);
  }
  String _capSize(String input) {
    int maxSize = 8;
    if (input.length>=maxSize) return input.substring(0, maxSize) + '...';
    return input;
  }

  Widget _buildBookmarkedIcon(BuildContext context, bool hasBeenSeen, Widget display) {
    return CircleAvatar(
      radius: hasBeenSeen ? 32 : 35,
      backgroundColor: hasBeenSeen ? Styles.ArrivalPalletteGrey : Styles.ArrivalPalletteRed,
      child: CircleAvatar(
        radius: 31,
        backgroundColor: Styles.ArrivalPalletteCream,
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Styles.ArrivalPalletteBlack,
          child: display,
        ),
      ),
    );
  }
  Widget _buildBookmark(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.all(6),
      width: 90,
      child: Center(
        child: Column(
          children: [
            PressableCircle(
              onPressed: () {
                _openGenericAction(index);
              },
              downElevation: 1,
              upElevation: 5,
              radius: 35,
              shadowColor: Styles.ArrivalPalletteBlack,
              child: _buildBookmarkedIcon(
                context,
                _rowButtonListData[index]['story'] == null ? false :
                  _rowButtonListData[index]['story'].seen,
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    _rowButtonListData[index]['icon'],
                  ),
                ),
              ),
            ),
            SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                _openGenericAction(index);
              },
              child: Text(
                _capSize(_rowButtonListData[index]['name']),
                style: _bookmarkLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSearchForMoreButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      width: 90,
      child: Center(
        child: Column(
          children: [
            PressableCircle(
              onPressed: () {
                widget.explore();
              },
              downElevation: 1,
              upElevation: 5,
              radius: 35,
              shadowColor: Styles.ArrivalPalletteBlack,
              child: _buildBookmarkedIcon(
                context,
                false,
                Icon(
                  Icons.add,
                  size: 25,
                  color: Styles.ArrivalPalletteWhite,
                ),
              ),
            ),
            SizedBox(height: 6),
            GestureDetector(
              onTap: () {
                widget.explore();
              },
              child: Text(
                widget.getExploreText(),
                style: _bookmarkLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
  List<Widget> _generateFavorites(BuildContext context) {
    List<Widget> yourFavs = List<Widget>();

    yourFavs.add(Container(width: 6));

    for (int i=0;i<_rowButtonListData.length;i++) {
      yourFavs.add(_buildBookmark(context, i));
    }

    yourFavs.add(_buildSearchForMoreButton(context));
    return yourFavs;
  }

  @override
  Widget build(BuildContext context) {

    _rowButtonListData = List<Map<String, dynamic>>.generate(
                            widget.listSize(), _generateGenericListData
                          );

    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 6,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _generateFavorites(context),
        ),
      ),
    );
  }
}
class _CasingBox extends State<CasingFavoritesBox> {

  List<Map<String, dynamic>> _rowButtonListData;
  TextStyle _bookmarkLabel = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Styles.ArrivalPalletteWhite,
  );

  Map<String, dynamic> _generateGenericListData(int index) {
    var result = widget.generateListData(index);
    result['seen'] = false;
    return result;
  }
  String getNavigationLink(int index) {
    if (index<0 && index>=_rowButtonListData.length) return '';
    _rowButtonListData[index]['seen'] = true;
    return _rowButtonListData[index]['cryptlink'];
  }
  void _openGenericAction(int index) {
    if (index<0 && index>=_rowButtonListData.length) return;
    widget.open(_rowButtonListData[index]);
  }
  String _capSize(String input) {
    int maxSize = 16;
    if (input.length>=maxSize) return input.substring(0, maxSize) + '...';
    return input;
  }

  Widget _buildBookmarkedIcon(BuildContext context, bool hasBeenSeen, Widget display) {
    return CircleAvatar(
      radius: hasBeenSeen ? 32 : 35,
      backgroundColor: hasBeenSeen ? Styles.ArrivalPalletteGrey : Styles.ArrivalPalletteRed,
      child: CircleAvatar(
        radius: 31,
        backgroundColor: Styles.ArrivalPalletteCream,
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Styles.ArrivalPalletteBlack,
          child: display,
        ),
      ),
    );
  }
  Widget _buildBookmark(BuildContext context, int index) {
    Preferences prefs = ScopedModel.of<Preferences>(context);

    return Container(
      child: PressableCard(
        onPressed: () {
          _openGenericAction(index);
        },
        downElevation: 1,
        upElevation: 5,
        shadowColor: Styles.ArrivalPalletteBlack,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 120,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _rowButtonListData[index]['color'],
                  BlendMode.hardLight,
                ),
                child: Image.network(
                  _rowButtonListData[index]['icon'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                width: 84,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FutureBuilder<bool>(
                      future: prefs.isBookmarked(widget.bookmarkableType(), _rowButtonListData[index]['link']),
                      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
                      GestureDetector(
                        onTap: () async {
                          await prefs.toggleBookmarked(widget.bookmarkableType(), _rowButtonListData[index]['link']);
                          setState(() => 0);
                        },
                        child: Icon(
                          snapshot.hasData ?
                            (snapshot.data ? Icons.star : Icons.star_border)
                            : Icons.star_border,
                          color: snapshot.hasData ?
                            (snapshot.data ? Styles.ArrivalPalletteYellow : Styles.ArrivalPalletteWhite)
                            : Styles.ArrivalPalletteWhite,
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      _capSize(_rowButtonListData[index]['name']),
                      style: _bookmarkLabel,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSearchForMoreButton(BuildContext context) {
    return Container(
      child: PressableCard(
        onPressed: () {
          widget.explore();
        },
        downElevation: 1,
        upElevation: 5,
        shadowColor: Styles.ArrivalPalletteBlack,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 120,
              color: Styles.ArrivalPalletteRed,
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                width: 84,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.add,
                      color: Styles.ArrivalPalletteWhite,
                    ),
                    SizedBox(height: 12),
                    Text(
                      widget.getExploreText(),
                      style: _bookmarkLabel,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  List<Widget> _generateFavorites(BuildContext context) {
    List<Widget> yourFavs = List<Widget>();

    for (int i=1;i<_rowButtonListData.length;i++) {
      yourFavs.add(_buildBookmark(context, i));
    }

    yourFavs.add(_buildSearchForMoreButton(context));
    return yourFavs;
  }

  @override
  Widget build(BuildContext context) {

    _rowButtonListData = List<Map<String, dynamic>>.generate(
                            widget.listSize(), _generateGenericListData
                          );

    return Container(
      height: 120,
      margin: EdgeInsets.only(top: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _generateFavorites(context),
        ),
      ),
    );
  }
}
