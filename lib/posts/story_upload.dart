/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'cloudinary/cloudinary_client.dart';
// import 'package:cloudinary_client/cloudinary_client.dart';

import '../data/socket.dart';
import '../users/data.dart';
import '../users/profile.dart';
import '../styles.dart';
import '../const.dart';


class StoryUpload extends StatefulWidget {
  @override
  _StoryUploadState createState() => _StoryUploadState();
}

class _StoryUploadState extends State<StoryUpload> {
  File _image;
  final _picker = ImagePicker();
  CloudinaryClient _cloudinary_client =
    new CloudinaryClient('868422847775537', 'QZeAt-YmyaViOSNctnmCR0FF61A', 'arrival-kc');

  @override
  void initState() {
    super.initState();

    _getImage();
  }

  Future _getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    if (pickedFile == null) return;

    setState(() => _image = File(pickedFile.path));
  }

  bool _isUnacceptableFile(File _media) {
    var length = _media.path.length;
    String extension = _media.path.substring(length-4, length);

    return (extension=='.gif');
  }
  bool _isVideo(File _media) {
    var length = _media.path.length;
    String extension = _media.path.substring(length-4, length);

    return (extension=='.mp4' || extension=='.mov' || extension=='.avi'
          || extension=='.wmv');
  }
  void _upload() async {
    Navigator.of(context).pop();

    File _media = _image;
    bool isVideo = _isVideo(_media);

    try {
      var media_data;

      if (isVideo) {
        media_data = await _cloudinary_client.uploadVideo(
          _media.path,
          folder: UserData.client.name + '/stories',
        );
      }
      else {
        media_data = await _cloudinary_client.uploadImage(
          _media.path,
          folder: UserData.client.name + '/stories',
        );
      }

      socket.emit('story upload', {
        'media': media_data.secure_url.replaceAll(
                  Constants.media_source, ''
                ),
        'time': 5,
        'user': UserData.client.cryptlink,
      });
    } catch (e) {
      print('''
      =====================================
                  Arrival Error
          $e
      =====================================
      ''');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: _image == null ? Container() : Image.file(
                _image,
                fit: BoxFit.cover,
              ),
            ),

            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: EdgeInsets.all(18.0),
                child: Icon(
                  Icons.close,
                  color: Styles.ArrivalPalletteWhite,
                ),
              ),
            ),

            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _upload,
                child: Container(
                  margin: EdgeInsets.all(18.0),
                  child: Icon(
                    Styles.share,
                    color: Styles.ArrivalPalletteWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
