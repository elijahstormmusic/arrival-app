/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../widgets/cards.dart';
import '../styles.dart';


class CasingFavorites extends StatefulWidget {

  void open(Map<String, dynamic> data) {}
  Map<String, dynamic> generateListData(int index) => {};
  int listSize() => 0;

  @override
  State<CasingFavorites> createState() => _CasingCircle();
}

class CasingFavoritesBox extends StatefulWidget {

  void open(Map<String, dynamic> data) {}
  Map<String, dynamic> generateListData(int index) => {};
  int listSize() => 0;

  @override
  State<CasingFavoritesBox> createState() => _CasingBox();
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

  @override
  initState() {
    super.initState();
    _rowButtonListData = List<Map<String, dynamic>>.generate(
                            widget.listSize(), _generateGenericListData
                          );
  }

  Widget _buildBookmark(BuildContext context, int index) {
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
              width: 80,
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
    return Container();
    //   padding: EdgeInsets.all(6),
    //   width: 90,
    //   child: Center(
    //     child: Column(
    //       children: [
    //         PressableCircle(
    //           onPressed: () {
    //             print('add more');
    //           },
    //           downElevation: 1,
    //           upElevation: 5,
    //           radius: 35,
    //           shadowColor: Styles.ArrivalPalletteBlack,
    //           child: _buildBookmarkedIcon(
    //             context,
    //             false,
    //             Icon(
    //               Icons.add,
    //               size: 25,
    //               color: Styles.ArrivalPalletteWhite,
    //             ),
    //           ),
    //         ),
    //         SizedBox(height: 6),
    //         GestureDetector(
    //           onTap: () {
    //
    //           },
    //           child: Text(
    //             'explore',
    //             style: _bookmarkLabel,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
  List<Widget> _generateFavorites(BuildContext context) {
    List<Widget> yourFavs = List<Widget>();

    for (int i=0;i<_rowButtonListData.length;i++) {
      yourFavs.add(_buildBookmark(context, i));
    }

    yourFavs.add(_buildSearchForMoreButton(context));
    return yourFavs;
  }

  @override
  Widget build(BuildContext context) {
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

class _CasingCircle extends State<CasingFavorites> {

  List<Map<String, dynamic>> _rowButtonListData;
  TextStyle _bookmarkLabel = TextStyle(
    fontWeight: FontWeight.bold,
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
    int maxSize = 8;
    if (input.length>=maxSize) return input.substring(0, maxSize) + '...';
    return input;
  }

  @override
  initState() {
    super.initState();
    _rowButtonListData = List<Map<String, dynamic>>.generate(
                            widget.listSize(), _generateGenericListData
                          );
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
                _rowButtonListData[index]['seen'],
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
                print('add more');
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

              },
              child: Text(
                'explore',
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

    for (int i=0;i<_rowButtonListData.length;i++) {
      yourFavs.add(_buildBookmark(context, i));
    }

    yourFavs.add(_buildSearchForMoreButton(context));
    return yourFavs;
  }

  @override
  Widget build(BuildContext context) {
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
