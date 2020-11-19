/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../styles.dart';
import '../data/arrival.dart';
import 'locator.dart';
import 'partner_markers.dart';


class Maps extends StatefulWidget {
  static const routeName = '/maps';
  static _MapState currentState;

  static void scrollToTop() =>
    currentState.restart();
  static void refresh_state() =>
    currentState.refresh_state();

  static void openSnackBar(Map<String, dynamic> input) =>
    currentState.openSnackBar(input);

  static MyLocation myself = MyLocation();

  String partner;

  Maps();
  Maps.directions({this.partner});

  @override
  _MapState createState() => _MapState(MyLocation());
}

class _MapState extends State<Maps> {
  MyLocation myself;
  ScrollController _scrollController;
  double _bottomCardPositionTop = 400;
  final double _bottomCardTopValue = 0;
  final double _bottomCardBottomValue = 400;
  double _bottomCardOutValue = 500;

  PartnerMarkersMap _localMap;

  _MapState(this.myself);

  SnackBar _snackBar;
  void openSnackBar(Map<String, dynamic> input) {
    try {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(input['text']),
        backgroundColor: Styles.ArrivalPalletteRed,
        elevation: 15.0,
        duration: input['duration']==null ? null : Duration(seconds: input['duration']),
        action: input['action']==null ? null : SnackBarAction(
          textColor: Styles.ArrivalPalletteBlue,
          disabledTextColor: Styles.ArrivalPalletteGrey,
          label: input['action-label'],
          onPressed: input['action'],
        ),
      ));
    } catch (e) {

    }
  }

  @override
  void initState() {
    super.initState();
    _localMap = PartnerMarkersMap();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    myself.relocationHandler(this);
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setMainCardToTop() {
    if (_bottomCardPositionTop==_bottomCardTopValue) return;
    setState(() => _bottomCardPositionTop = _bottomCardTopValue);
  }
  void _setMainCardToBottom() {
    if (_bottomCardPositionTop==_bottomCardBottomValue) return;
    setState(() => _bottomCardPositionTop = _bottomCardBottomValue);
  }
  void _setMainCardOut() {
    if (_bottomCardPositionTop==_bottomCardOutValue) return;
    setState(() => _bottomCardPositionTop = _bottomCardOutValue);
  }

  double _startCardDrag, _cardDragDeadzone = 15;
  void _onVerticalDragStart(var details) {
    _startCardDrag = details.globalPosition.dy;
  }
  void _onVerticalDragUpdate(var details) {
    if (details.globalPosition.dy > _startCardDrag + _cardDragDeadzone) { // down
      _setMainCardToBottom();
    }
    else if (details.globalPosition.dy < _startCardDrag - _cardDragDeadzone) { // up
      _setMainCardToTop();
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >= 200) {
      _setMainCardToTop();
    }
    else {
      _setMainCardToBottom();
    }
  }

  void restart() {

  }
  void refresh_state() {

  }
  void relocate() {

  }

  void _locateAndTakeMe(LatLng location, var info) {
    _localMap.addMarker(location, info);
  }

  void _pushPage(BuildContext context, var page) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  Widget _generatePartnersRow(BuildContext context, var partner) {
    return GestureDetector(
      onTap: () {
        _setMainCardOut();
        _locateAndTakeMe(partner.location, {
          'title': partner.name,
          'info': partner.shortDescription,
          'rating': partner.rating,
          'ratingAmount': partner.ratingAmount,
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        margin: EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              partner.images.logo,
              fit: BoxFit.fitHeight,
              height: 70,
              width: 70,
            ),
            SizedBox(width: 8),
            Container(
              width: MediaQuery.of(context).size.width - 56 - 78,
              height: 78,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          partner.name,
                          style: Styles.headlineNameTL,
                        ),
                      ),
                    ],
                  ),
                  // StarRating(rating: partner.rating,),
                  Expanded(
                    child: Text(
                      partner.shortDescription,
                      style: Styles.headlineDescriptionTL,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _debuggerToggle = true;

  @override
  Widget build(BuildContext context) {
    _bottomCardOutValue = MediaQuery.of(context).size.height
              - MediaQuery.of(context).padding.top - 110;

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Container(
            height: _debuggerToggle ? _bottomCardOutValue + 10 : _bottomCardPositionTop + 10,
            child: _localMap,
          ),
          GestureDetector(
            onDoubleTap: () {
              if (_bottomCardPositionTop==_bottomCardBottomValue) {
                _setMainCardToTop();
              }
              else {
                _setMainCardToBottom();
              }
            },
            onVerticalDragStart: (details) {
              _onVerticalDragStart(details);
            },
            onVerticalDragUpdate: (details) {
              _onVerticalDragUpdate(details);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 350),
              curve: Curves.easeOut,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Styles.ArrivalPalletteWhite,
                borderRadius: BorderRadius.circular(18),
              ),
              margin: EdgeInsets.only(top: _bottomCardPositionTop),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: ListView(
                controller: _scrollController,
                physics: _bottomCardPositionTop==_bottomCardTopValue
                  ? ClampingScrollPhysics()
                  : NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_bottomCardPositionTop==_bottomCardBottomValue) {
                          _setMainCardToTop();
                        }
                        else {
                          _setMainCardToBottom();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        child: Container(
                          height: 3,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Styles.ArrivalPalletteRed,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, left: 16, bottom: 6),
                    child: Text(
                      'Our Partners',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Styles.ArrivalPalletteGrey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: Styles.ArrivalPalletteCream,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: ListView.builder(
                      itemCount: ArrivalData.partners.length,
                      itemBuilder: (context, index) => _generatePartnersRow(
                        context,
                        ArrivalData.partners[index],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _debuggerToggle = !_debuggerToggle,
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      color: Styles.ArrivalPalletteRed,
                      height: 100,
                      width: 200,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
