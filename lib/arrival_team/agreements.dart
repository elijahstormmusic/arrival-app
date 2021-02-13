/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../data/socket.dart';
import '../users/data.dart';
import '../widgets/dialog.dart';
import '../styles.dart';


class LegalAgreements extends StatefulWidget {

  String agreementType = 'null';
  bool required = false;
  String title = 'missing';
  Function(bool) setParentValue;

  LegalAgreements.UGC() {
    agreementType = 'ugc';
    required = true;
    title = 'UCG Policy';
    setParentValue = (bool value) {
      UserData.UGC_Agreement = value;
    };
  }

  @override
  _LegalAgreementsState createState() => _LegalAgreementsState();
}

class _LegalAgreementsState extends State<LegalAgreements> {

  String _errText = '';
  bool _allowMessageSend = true;

  bool _isTimerRunning = false;

  void _errorReport(String reason) {
    setState(() => _errText = reason);
  }
  void _showToast(String _msg) {
    Toast.show(_msg, context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
  Future<bool> _willPopCallback() async {
    if (!widget.required) return true;

    if (UserData.UGC_Agreement) return true;

    _showToast('You must accept the terms to continue.');
    return false;
  }

  void _legalAgreement(bool answer) async {
    if (!_allowMessageSend) return;
    _allowMessageSend = false;

    socket.emit('userdata set legal agreement', {
      'user': UserData.client.cryptlink,
      'agreements': {
        'type': widget.agreementType,
        'value': answer,
      },
    });

    widget.setParentValue(answer);

    await Future.delayed(const Duration(seconds: 20));
    _allowMessageSend = true;
  }
  void _confirmDisagree() async {
    String cancelText, content;

    if (widget.required) {
      cancelText = 'Exit App';
      content = 'You cannot use our app without agreeing to our ${widget.title}';
    }
    else {
      cancelText = 'Still No';
      content = 'You experience with Arrival will be better with our ${widget.title}';
    }

    showDialog<void>(context: context, builder: (context) => AlertDialog(
      title: Text('Cancel ${widget.title}?'),
      content: Text(content),
      actions: [
        FlatButton(
          child: Text(cancelText),
          onPressed: () {
            _legalAgreement(false);
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Change'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: Icon(
            Icons.how_to_reg,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 30,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

                // Header
              Container(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),

                // Policy Text
              Container(
                height: MediaQuery.of(context).size.height - 330,
                // width: ,
                color: Styles.ArrivalPalletteGrey,
                // child: SingleChildScrollView(
                //   scrollDirection: Axis.vertical,
                //   child: Text(
                //     'yoyo',
                //   ),
                // ),
              ),

                // buttons
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: _confirmDisagree,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          color: Styles.ArrivalPalletteGrey,
                        ),
                        width: 130,
                        height: 50,
                        child: Center(
                          child: Text(
                            'Exit',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        _legalAgreement(true);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          color: Styles.ArrivalPalletteRed,
                          // gradient: LinearGradient(
                          //   begin: Alignment.bottomLeft,
                          //   end: Alignment.topRight,
                          //   colors: [
                          //     const Color(0xffF15D5D),
                          //     const Color(0xffF25E92),
                          //     const Color(0xffA35ADB),
                          //     const Color(0xff7e5ef2),
                          //     const Color(0xff4974D9),
                          //   ],
                          //   tileMode: TileMode.mirror,
                          // ),
                        ),
                        width: 130,
                        height: 50,
                        child: Center(
                          child: Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Styles.ArrivalPalletteWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: _willPopCallback,
    );
  }
}
