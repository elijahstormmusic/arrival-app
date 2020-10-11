/// Code written and created by Elijah Storm
// Copywrite April 5, 2020
// for use only in ARRIVAL Project

import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery/image_gallery.dart';
import 'package:camera/camera.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/scheduler.dart';
import 'package:cloudinary_client/cloudinary_client.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../data/socket.dart';
import '../data/link.dart';
import '../users/data.dart';
import '../widgets/close_button.dart';
import '../foryou/list.dart';
import '../screens/home.v2.dart';
import '../maps/locator.dart';
import '../styles.dart';


class PostUploadEditingScreen extends StatefulWidget {
  final File upload_single;
  final List<File> upload_collection;

  PostUploadEditingScreen(this.upload_single)
    : assert(upload_single != null),
      upload_collection = null;

  PostUploadEditingScreen.collection(this.upload_collection)
    : assert(upload_collection != null),
      upload_single = null;

  @override
  _UploadEditingState createState() => new _UploadEditingState();
}
class _UploadEditingState extends State<PostUploadEditingScreen> {
  bool isLoading;
  var post_loc;
  bool _track_with_ana;
  String caption;

  TextEditingController _captionInput;
  CloudinaryClient cloudinary_client =
    new CloudinaryClient('868422847775537', 'QZeAt-YmyaViOSNctnmCR0FF61A', 'arrival-kc');

  @override
  void initState() {
    isLoading = false;
    _track_with_ana = false;
    post_loc = {
      'name': '',
      'lat': 39.1439117,
      'lng': -94.5785244,
    };
    caption = '';
    _captionInput = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _captionInput.dispose();
    super.dispose();
  }


  Future<String> _uploadImage(File _image) async {
    if (_image == null) return '';

    setState(() {
      isLoading = true;
    });

    try {
      String img_url = (await cloudinary_client.uploadImage(
        _image.path,
        folder: 'posts/' + UserData.client.name,
      )).secure_url.replaceAll('https://res.cloudinary.com/arrival-kc/image/upload/', '');

      return img_url;
    } catch (e) {
      print('''
      =====================================
                  Arrival Error
          $e
      =====================================
      ''');
    }

    return '';
  }


  Map<String, double> _settingsValues = {
    'padding': 8.0,
    'devider': 1.0,
    'text size': 16.0,
  };
  Widget _buildAdvancedSettingsButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _settingsValues['padding'] * 1.5,
        horizontal: _settingsValues['padding'] * 3,
      ),
      child: GestureDetector(
        onTap: () {
          print('tapped advanced settings');
        },
        child: GestureDetector(
          onTap: () {
            print('add location btn pressed');
          },
          child: Text(
            'Advanced Settings',
            style: TextStyle(
              fontSize: _settingsValues['text size'] - 2,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildAnalyticsButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _settingsValues['padding'] * 1.5,
        horizontal: _settingsValues['padding'] * 3,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() => _track_with_ana = !_track_with_ana);
        },
        child: Text(
          _track_with_ana ? 'Analytics are on for this post. Remove?' : 'Track with Analytics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _track_with_ana ? Styles.ArrivalPalletteRed : null,
            fontSize: _settingsValues['text size'],
          ),
        ),
      ),
    );
  }
  Widget _buildLocationChooser(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _settingsValues['padding'] * 1.5,
        horizontal: _settingsValues['padding'] * 3,
      ),
      child: GestureDetector(
        onTap: () {
          print('choose a location tapped');
        },
        child: Text(
          'Choose a Location',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _settingsValues['text size'],
          ),
        ),
      ),
    );
  }
  Widget _buildAddLocationButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _settingsValues['padding'] * 1.5,
        horizontal: _settingsValues['padding'] * 3,
      ),
      child: GestureDetector(
        onTap: () {
          MyLocation myself = MyLocation();
          setState(() => post_loc = {
            'name': 'undefined',
            'lat': myself.lat,
            'lng': myself.lng,
          });
        },
        child: Text(
          post_loc['name']=='' ? 'Add My Location'
            : (post_loc['name'] + ' ('
                  + post_loc['lat'].toString() + ', '
                  + post_loc['lng'].toString() + ')'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _settingsValues['text size'],
          ),
        ),
      ),
    );
  }
  Widget _buildPostSettings(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAddLocationButton(context),
          Container(
            height: _settingsValues['devider'],
            color: Styles.ArrivalPalletteGrey,
          ),
          _buildLocationChooser(context),
          Container(
            height: _settingsValues['devider'],
            color: Styles.ArrivalPalletteGrey,
          ),
          _buildAnalyticsButton(context),
          Container(
            height: _settingsValues['devider'],
            color: Styles.ArrivalPalletteGrey,
          ),
          _buildAdvancedSettingsButton(context),
        ],
      ),
    );
  }

  void _onCaptionChanged(String input) {
    caption = input;
  }
  Map<String, double> _captionValues = {
    'padding': 4.0,
    'min size': 40.0,
    'circle': 30.0,
    'fontSize': 12.0,
  };
  Widget _buildCaptionInsert(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_captionValues['padding'] * 2),
      child: TextField(
        controller: _captionInput,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 10,
        decoration: InputDecoration(
          labelText: 'Caption',
        ),
        onChanged: _onCaptionChanged,
      ),
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_captionValues['padding'] * 2),
      height: (_captionValues['circle'] + _captionValues['padding']) * 2,
      child: CircleAvatar(
        radius: _captionValues['circle'],
        backgroundImage: NetworkImage(UserData.client.image_href()),
      ),
    );
  }
  Widget _buildPostIcon(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_captionValues['padding']),
      child: widget.upload_single!=null
                ? Image(image: FileImage(widget.upload_single))
                : Image(image: FileImage(widget.upload_collection[0])),
    );
  }

  Widget _buildPostInformationDisplay(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _captionValues['padding'],
        horizontal: _captionValues['padding'],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: _buildProfileIcon(context),
          ),
          Expanded(
            flex: 4,
            child: _buildCaptionInsert(context),
          ),
          Expanded(
            flex: 1,
            child: _buildPostIcon(context),
          ),
        ],
      ),
    );
  }

  Map<String, double> _headerValues = {
    'height': 50.0,
    'padding': 6.0,
  };
  Widget _buildUploadHeader() {
    return Container(
      height: _headerValues['height'],
      padding: EdgeInsets.fromLTRB(_headerValues['padding'], 0, 0, 0),
      width: MediaQuery.of(context).size.width - (_headerValues['padding'] * 2),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(
              child: ArrCloseButton(() {
                Navigator.of(context).pop();
              }),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  String post_id = UserData.client.name + Random().nextInt(1000000).toString();
                  var database_info = {
                    'userlink': UserData.client.cryptlink,
                    'caption': caption,
                    'id': post_id,
                    'analytics': _track_with_ana,
                    'loc': {
                      'name': post_loc['name'],
                      'lat': post_loc['lat'],
                      'lng': post_loc['lng'],
                    }
                  };

                  if (widget.upload_single!=null) {
                    String link = await _uploadImage(widget.upload_single);

                    if (link=='') return;

                    database_info['type'] = 0;
                    database_info['cloudlink'] = link;
                  }
                  else {
                    List<String> links = List<String>();
                    for (int i=0;i<widget.upload_collection.length;i++) {
                      links.add(await _uploadImage(widget.upload_collection[i]));
                      if (links[i]=='') return;
                    }

                    database_info['type'] = 1;
                    database_info['cloudlink'] = links;
                  }

                  socket.emit('posts upload', database_info);

                  HomeScreen.gotoForyou();
                  ForYouPage.scrollToTop();
                },
                child: Text(
                  'UPLOAD',
                  style: Styles.activeTabButton,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Map<String, double> _containerValues = {
    'devider': 1.0,
  };
  Widget _buildEditsContainer(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: <Widget>[
        _buildUploadHeader(),
        Container(
          height: _containerValues['devider'],
          color: Styles.ArrivalPalletteGrey,
        ),
        _buildPostInformationDisplay(context),
        Container(
          height: _containerValues['devider'],
          color: Styles.ArrivalPalletteGrey,
        ),
        _buildPostSettings(context),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildEditsContainer(context),
      ),
    );
  }
}


class PostUploadScreen extends StatefulWidget {
  @override
  _PostUploadState createState() => new _PostUploadState();
}
class _PostUploadState extends State<PostUploadScreen> {
  var _image;

  ScrollController _galleryScrollController;
  ScrollController _uploadContainerScrollController;

  List _galleryImages, _galleryImageNames;

  Future<void> _loadImageList() async {
    Map allImageTemp;
    try {
      allImageTemp = await FlutterGallaryPlugin.getAllImages;
    }
    catch (e) {
      print('''
        =======================================
                  Arrival Error
            $e
        =======================================
      ''');
      return;
    }

    setState(() {
      _galleryImages = allImageTemp['URIList'] as List;
      _galleryImageNames = allImageTemp['DISPLAY_NAME'] as List;
    });
  }

  List<CameraDescription> _allCameras;
  CameraController _cameraController;
  bool _cameraFailed = false;
  Future<void> _initializeControllerFuture;

  void _initalizeCamera() async {
    try {
      _allCameras = await availableCameras();
      _cameraController = CameraController(_allCameras[0], ResolutionPreset.medium);
      _cameraController.initialize().then((_) {
        if (!mounted) {
          _cameraFailed = true;
        }
      });
      _initializeControllerFuture = _cameraController.initialize();
    }
    catch (e) {
      print('''
          ==================================
                    Camera Error
                $e
          ==================================
      ''');
    }
  }
  @override
  void initState() {
    super.initState();
    _galleryImages = List();
    _galleryImageNames = List();
    _galleryScrollController = ScrollController();
    _galleryScrollController.addListener(_galleryScrollListener);
    _uploadContainerScrollController = ScrollController();
    _uploadContainerScrollController.addListener(_containerScrollListener);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _loadImageList();
    });
    _initalizeCamera();
  }
  @override
  void dispose() {
    _cameraController?.dispose();
    _galleryScrollController.dispose();
    _uploadContainerScrollController.dispose();
    super.dispose();
  }

  void _galleryScrollListener() {
    if (_galleryScrollController.offset >= _galleryScrollController.position.maxScrollExtent &&
        !_galleryScrollController.position.outOfRange) {
      // _loadMore();
    }
  }
  void _containerScrollListener() {
    if (_uploadContainerScrollController.offset >= _uploadContainerScrollController.position.maxScrollExtent &&
        !_uploadContainerScrollController.position.outOfRange) {
      // _loadMore();
    }
  }


  Map<String, double> _imageValues = {
    'body': 300.0,
    'row': 40.0,
    'circle': 20.0,
    'padding': 6.0,
  };
  Widget _buildImageShowcase() {
    return Center(
      child: _image != null
        ? Image(image: FileImage(_image))
        : Icon(
            Icons.photo,
            size: _imageValues['circle'] * 5,
            color: Styles.ArrivalPalletteGrey,
          ),
    );
  }

  Map<String, double> _headerValues = {
    'height': 50.0,
    'padding': 6.0,
  };
  Widget _buildUploadHeader() {
    return Container(
      height: _headerValues['height'],
      padding: EdgeInsets.fromLTRB(_headerValues['padding'], 0, 0, 0),
      width: MediaQuery.of(context).size.width - (_headerValues['padding'] * 2),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(
              child: ArrCloseButton(() {
                Navigator.of(context).pop();
              }),
            ),
          ),
          Expanded(
            flex: 3,
            child: _selectedIndex==1
              ? Container()
              : GestureDetector(
                onTap: () => print('tapped folder change'),
                child: Text(
                  'Recent Gallery',
                  style: Styles.activeTabButton,
                ),
              ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: _selectedIndex==1 && !_imageTaken
                ? Container()
                : GestureDetector(
                    onTap: () {
                      if (_image==null) return;
                      Arrival.navigator.currentState.push(MaterialPageRoute(
                        builder: (context) => PostUploadEditingScreen(_image),
                        fullscreenDialog: true,
                      ));
                    },
                    child: Text(
                      'NEXT',
                      style: Styles.activeTabButton,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayCasing(BuildContext context) {
    return Container(
      height: _imageValues['body'],
      child: Stack(
        children: <Widget>[
          _buildImageShowcase(),
          Positioned(
            bottom: _imageValues['padding'],
            left: _imageValues['padding'],
            child: Container(
              height: _imageValues['row'],
              width: MediaQuery.of(context).size.width - (_imageValues['padding'] * 2),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => print('tapped #1'),
                        child: CircleAvatar(
                          radius: _imageValues['circle'],
                          backgroundColor: Styles.ArrivalPalletteGrey,
                          child: Icon(
                            Icons.person,
                            size: _imageValues['circle'],
                            color: Styles.ArrivalPalletteWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => print('tapped #2'),
                        child: CircleAvatar(
                          radius: _imageValues['circle'],
                          backgroundColor: Styles.ArrivalPalletteGrey,
                          child: Icon(
                            Icons.person,
                            size: _imageValues['circle'],
                            color: Styles.ArrivalPalletteWhite,
                          ),
                        ),
                      ),
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
  Widget _buildGalleryCasing(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: 1,
      scrollDirection: Axis.vertical,
      crossAxisCount: 4,
      controller: _galleryScrollController,
      physics: ClampingScrollPhysics(),
      children: new List<Widget>.generate(
        _galleryImages.length, (index) {
          return Container(
            padding: EdgeInsets.all(1.0),
            child: GestureDetector(
              onTap: () {
                setState(() => _image = File(_galleryImages[index]));
              },
              child: Image.file(File(_galleryImages[index].toString())),
            ),
          );
        }
      ).toList(),
    );
  }

  Map<String, double> _cameraValues = {
    'outter UI glow': 42.0,
    'outter UI button': 40.0,
    'inner UI button': 35.0,
  };
  bool _imageTaken = false;
  Widget _buildCameraVisualDisplay(BuildContext context) {
    if (!_cameraController.value.isInitialized || _cameraFailed) {
      return Container();
    }
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return AspectRatio(
            aspectRatio: _cameraController.value.aspectRatio,
            child: CameraPreview(_cameraController),
          );
        } else if (_cameraFailed) {
          return Container(
            color: Styles.ArrivalPalletteBlack,
          );
        } else {
          // Otherwise, display a loading indicator.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  Widget _buildCameraDisplayCasing(BuildContext context) {
    return Container(
      color: Styles.ArrivalPalletteBlack,
      height: _imageValues['body'],
      child: _imageTaken ? Center(
                child: Image(image: FileImage(_image))
              )
            : _buildCameraVisualDisplay(context),
    );
  }
  Widget _buildCameraUICasing(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top
        - _imageValues['body'] - (_headerValues['height']*3) - (_containerValues['devider']*2),
      child: Center(
        child: GestureDetector(
          onTap: () async {
            if (_imageTaken) return;

            try {
              await _initializeControllerFuture;

              final path = join(
                (await getTemporaryDirectory()).path,
                '${DateTime.now()}.png',
              );

              await _cameraController.takePicture(path);

              _image = File(path);
              setState(() => _imageTaken = true);
            } catch (e) {
              print('''
              =========================
                      Arrival Error
                  $e
              =========================
              ''');
ForYouPage.openSnackBar({
'text': 'Camera Error $e',
'duration': 10,
});
            }
          },
          child: CircleAvatar(
            radius: _cameraValues['outter UI glow'],
            backgroundColor: Styles.ArrivalPalletteRedTransparent,
            child: CircleAvatar(
              radius: _cameraValues['outter UI button'],
              backgroundColor: Styles.ArrivalPalletteGrey,
              child: CircleAvatar(
                radius: _cameraValues['inner UI button'],
                backgroundColor: Styles.ArrivalPalletteBlack,
                child: Icon(
                  Icons.camera,
                  size: _imageValues['circle'],
                  color: Styles.ArrivalPalletteWhite,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, double> _containerValues = {
    'devider': 1.0,
  };
  Widget _buildUploadContainer(BuildContext context) {
    var displayList = <Widget>[
      _buildUploadHeader(),
      Container(
        height: 1,
        color: Styles.ArrivalPalletteGrey,
      ),
    ];

    if (_selectedIndex==0) {  // gallery option
      displayList += <Widget>[
        _buildDisplayCasing(context),
        Container(
          height: _containerValues['devider'],
          color: Styles.ArrivalPalletteGrey,
        ),
        _buildGalleryCasing(context),
      ];
    }
    else {  // camera option
      displayList += <Widget>[
        _buildCameraDisplayCasing(context),
        Container(
          height: _containerValues['devider'],
          color: Styles.ArrivalPalletteGrey,
        ),
        _buildCameraUICasing(context),
      ];
    }

    return ListView(
      physics: ClampingScrollPhysics(),
      controller: _uploadContainerScrollController,
      children: displayList,
    );
  }

  int _selectedIndex = 0;
  void _selectedTab(BuildContext context, int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildUploadContainer(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _selectedTab(context, index),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(),
            title: Text('Gallery'),
          ),
          BottomNavigationBarItem(
            icon: Container(),
            title: Text('Camera'),
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Styles.ArrivalPalletteWhite,
        selectedFontSize: 18.0,
        unselectedFontSize: 18.0,
        selectedItemColor: Styles.ArrivalPalletteBlack,
        unselectedItemColor: Styles.ArrivalPalletteGrey,
      ),
    );
  }
}
