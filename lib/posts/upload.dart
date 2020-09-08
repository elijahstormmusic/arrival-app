/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../data/socket.dart';
import '../users/data.dart';
import '../styles.dart';

class PostUploadScreen extends StatefulWidget {
  @override
  _PostUploadState createState() => new _PostUploadState();
}

class _PostUploadState extends State<PostUploadScreen> {
  var _image;
  bool isLoading;
  CloudinaryClient cloudinary_client =
    new CloudinaryClient('868422847775537', 'QZeAt-YmyaViOSNctnmCR0FF61A', 'arrival-kc');
  String caption = 'upload test caption';

  @override
  void initState() {
    isLoading = false;
  }

  void _uploadImage() async {
    if(_image == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      String img_url = (await cloudinary_client.uploadImage(
        _image.path,
        // filename: 'uploadtest',
        folder: 'posts/' + UserData.client.name,
      )).secure_url;

      if(img_url!=null) {
        socket.emit('posts upload', {
          'cloudlink': img_url.replaceAll('https://res.cloudinary.com/arrival-kc/image/upload/', ''),
          'userlink': UserData.client.cryptlink,
          'id': UserData.client.name,
          'caption': caption,
        });
      }

      _image = null;
      // feedback that it has uploaded
    } catch (e) {
      print(e);
      // feedback that it has failed
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
          ? Loading(
            indicator: BallPulseIndicator(),
            size: 100.0,
            color: Styles.ArrivalPalletteCream,
          )
          : _image != null
            ? Image(image: FileImage(_image))
            : CircleAvatar(
              radius: 100,
              backgroundColor: Styles.ArrivalPalletteBlue,
              child: Icon(
                Icons.person,
                size: 100,
                color: Styles.ArrivalPalletteCream,
              ),
        ),
      ),
      floatingActionButton: _image == null
        ? FloatingActionButton(
            onPressed: _getImage,
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
            backgroundColor: Styles.ArrivalPalletteBlue,
          )
        : SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            // onOpen: () => print('opening dial'),
            // onClose: () => print('clsing dial'),
            visible: true,
            curve: Curves.bounceIn,
            backgroundColor: Styles.ArrivalPalletteBlue,
            children: [
              SpeedDialChild(
                child: Icon(
                  Icons.add_a_photo,
                  color: Styles.ArrivalPalletteCream,
                ),
                backgroundColor: Styles.ArrivalPalletteBlue,
                onTap: _getImage,
                label: 'Repick',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Styles.ArrivalPalletteCream
                ),
                labelBackgroundColor: Styles.ArrivalPalletteBlue,
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.cloud,
                  color: Styles.ArrivalPalletteCream,
                ),
                backgroundColor: Styles.ArrivalPalletteRed,
                onTap: _uploadImage,
                label: 'Upload',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Styles.ArrivalPalletteCream
                ),
                labelBackgroundColor: Styles.ArrivalPalletteRed,
              ),
            ],
          ),
    );
  }
}
