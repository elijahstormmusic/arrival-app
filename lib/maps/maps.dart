/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../styles.dart';
import '../data/arrival.dart';
import '../data/socket.dart';
import '../widgets/close_button.dart';
import 'locator.dart';
import '../partners/partner.dart';
import 'partner_markers.dart';


class Maps extends StatefulWidget {
  static const routeName = '/maps';
  static _MapState currentState;

  static void scrollToTop() =>
    currentState.refresh();
  static void refresh() =>
    currentState.refresh();

  static void openSnackBar(Map<String, dynamic> input) =>
    currentState.openSnackBar(input);

  static MyLocation myself;

  Partner partner;

  Maps();
  Maps.directions(this.partner);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Maps> {
  MyLocation myself;
  ScrollController _scrollController;
  double _bottomCardVerticalPosition = 400;
  final double _bottomCardTopValue = 0;
  double _bottomCardBottomValue = 400;
  double _bottomCardOutValue = 500;
  bool initating;

  PartnerMarkersMap _localMap;

  _MapState();

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
    _localMap = PartnerMarkersMap(onMapLoaded: _onMapLoaded, onMapInteraction: _onMapInteraction);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    myself = MyLocation(onRelocation: _onRelocated);

    if (ArrivalData.partners.length < 20) {
      socket.emit('foryou ask', {
        'type': 'partners',
        'amount': 20,
      });
    }

    initating = true;
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildBackButton() =>
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: ArrCloseButton(() {
                Navigator.of(context).pop();
              }),
            ),
          );

  void _setMainCardToTop() {
    if (_bottomCardVerticalPosition==_bottomCardTopValue) return;
    setState(() => _bottomCardVerticalPosition = _bottomCardTopValue);
  }
  void _setMainCardToBottom() {
    if (_bottomCardVerticalPosition==_bottomCardBottomValue) return;
    _localMap.padding = _bottomCardOutValue - _bottomCardBottomValue;
    setState(() => _bottomCardVerticalPosition = _bottomCardBottomValue);
  }
  void _setMainCardOut() {
    if (_bottomCardVerticalPosition==_bottomCardOutValue) return;
    _localMap.padding = 0;
    setState(() => _bottomCardVerticalPosition = _bottomCardOutValue);
  }
  void _setMainCardUp() {
    if (_bottomCardVerticalPosition==_bottomCardBottomValue) {
      _setMainCardToTop();
    }
    else if (_bottomCardVerticalPosition==_bottomCardOutValue) {
      _setMainCardToBottom();
    }
  }
  void _setMainCardDown() {
    if (_bottomCardVerticalPosition==_bottomCardTopValue) {
      _setMainCardToBottom();
    }
    else if (_bottomCardVerticalPosition==_bottomCardBottomValue) {
      _setMainCardOut();
    }
  }

  double _startCardDrag, _cardDragDeadzone = 15;
  bool _doneDragAction = false;
  void _onVerticalDragStart(var details) {
    _startCardDrag = details.globalPosition.dy;
    _doneDragAction = false;
  }
  void _onVerticalDragUpdate(var details) {
    if (_doneDragAction) return;
    if (details.globalPosition.dy > _startCardDrag + _cardDragDeadzone) { // down
      _setMainCardDown();
      _doneDragAction = true;
    }
    else if (details.globalPosition.dy < _startCardDrag - _cardDragDeadzone) { // up
      _setMainCardUp();
      _doneDragAction = true;
    }
  }
  void _onMapInteraction(LatLng pos) {
    _setMainCardOut();
  }
  void _onRelocated(LatLng new_pos) {
    _localMap.relocate(new_pos);
  }

  void _scrollListener() {
    if (_scrollController.offset >= 200) {
      _setMainCardToTop();
    }
    else {
      _setMainCardToBottom();
    }
  }

  void _onMapLoaded() {
    for (final partner in ArrivalData.partners) {
      _localMap.addMarker(partner.location, {
        'title': partner.name,
        'info': partner.shortDescription,
        'rating': partner.rating,
        'ratingAmount': partner.ratingAmount,
      });
    }
    if (widget.partner != null) {
      _locateAndTakeMe(widget.partner, {
        'title': widget.partner.name,
      });
    }
  }

  void refresh() {
    _localMap.refresh();

    for (final partner in ArrivalData.partners) {
      _localMap.addMarker(partner.location, {
        'title': partner.name,
        'info': partner.shortDescription,
        'rating': partner.rating,
        'ratingAmount': partner.ratingAmount,
      });
    }

    setState(() => 0);
  }

  void _locateAndTakeMe(var partner, var info) {
    _localMap.locateAndTakeMe(partner.location, myself.latlng, info);
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
        _locateAndTakeMe(partner, {
          'title': partner.name,
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

  @override
  Widget build(BuildContext context) {

    if (initating) {
      _bottomCardBottomValue = (MediaQuery.of(context).size.height / 200).ceil().toDouble() * 100;
      _bottomCardOutValue = MediaQuery.of(context).size.height
                - MediaQuery.of(context).padding.top - 110;
      _bottomCardVerticalPosition = _bottomCardBottomValue;
      _localMap.padding = _bottomCardOutValue - _bottomCardBottomValue;
      initating = false;
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              height: _bottomCardOutValue + 10,
              color: Styles.ArrivalPalletteCream,
              child: _localMap,
            ),

            widget.partner != null
              ? _buildBackButton()
              : Container(width: 0, height: 0),

            GestureDetector(
              onDoubleTap: () {
                if (_bottomCardVerticalPosition==_bottomCardBottomValue) {
                  _setMainCardToTop();
                }
                else {
                  _setMainCardToBottom();
                }
              },
              onTap: () {
                if (_bottomCardVerticalPosition==_bottomCardOutValue) {
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
                margin: EdgeInsets.only(top: _bottomCardVerticalPosition),
                child: ListView(
                  controller: _scrollController,
                  physics: _bottomCardVerticalPosition==_bottomCardTopValue
                  ? ClampingScrollPhysics()
                  : NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_bottomCardVerticalPosition==_bottomCardBottomValue) {
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
                    // Divider(height: 1.0, thickness: 1.0),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 26,
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
                    SizedBox(height: 8),
                    Divider(height: 1.0, thickness: 2.0),
                    SizedBox(height: 8),

                    Container(
                      margin: EdgeInsets.only(top: 30, left: 16, bottom: 6),
                      child: Text(
                        'extra stuff can go here...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(),  // next things
                    SizedBox(height: 8),
                    Divider(height: 1.0, thickness: 2.0),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
