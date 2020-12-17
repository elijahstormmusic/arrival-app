import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';

import '../../posts/cloudinary/cloudinary_client.dart';

import '../../data/socket.dart';
import '../../users/data.dart';
import '../../users/profile.dart';
import '../../styles.dart';
import '../../const.dart';


class Messager extends StatefulWidget {
  final String thread;
  final ChatUser clientUser = ChatUser(
    name: UserData.client.name,
    uid: UserData.client.cryptlink,
    avatar: UserData.client.media_href(),
  );
  final Map<String, ChatUser> usersMap = Map<String, ChatUser>();
  String chatName;
  bool _allowedToChat = false;
  bool newChat = false;

  Messager(@required this.thread, Map<String, dynamic> inputData) {
    _initalizeChat(inputData);
  }
  Messager.create(Map<String, dynamic> inputData, {
    this.thread = '',
  }) {
    newChat = true;
    _initalizeChat(inputData);
  }

  void _initalizeChat(Map<String, dynamic> inputData) {
    chatName = inputData['name'];

    usersMap[clientUser.uid] = clientUser;

    if (inputData['group'] != null) {
      for (int i=0;i<inputData['group'].length;i++) {
        if (inputData['group'][i]==clientUser.uid) {
          _allowedToChat = true;
          continue;
        }

        Profile otherUser = Profile.lite(
          inputData['group'][i],
        );

        usersMap[inputData['group'][i]] = ChatUser(
          name: otherUser.name,
          uid: otherUser.cryptlink,
          avatar: otherUser.media_href(),
        );
      }
    }

    if (chatName==null) {
      String newName = '';

      for (int i=0;i<inputData['group'].length;i++) {
        if (inputData['group'][i]==clientUser.uid) continue;

        Profile otherUser = Profile.lite(
          inputData['group'][i],
        );

        newName += otherUser.name + ', ';
      }

      chatName = newName.substring(0, newName.length - 2);
    }
  }

  @override
  _MessagerState createState() => _MessagerState();
}

class _MessagerState extends State<Messager> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  var _messagesStream;
  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();
  bool _disabledForRapidSending = false;
  CloudinaryClient cloudinary_client =
    new CloudinaryClient('868422847775537', 'QZeAt-YmyaViOSNctnmCR0FF61A', 'arrival-kc');

  var i = 0;

  @override
  void initState() {
    super.initState();
    _messagesStream = socket.stream('');

    if (widget.newChat) return;

    _messagesStream.emit('set chat state', {
      'link': UserData.client.cryptlink,
      'thread': widget.thread,
    });
  }
  @override
  void dispose() {
    _messagesStream.dispose();
    super.dispose();
  }

  void _systemMessage() {
    if (m.length == 0) return;

    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        _messagesStream.add([m[i].toJson()]);
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void _onSend(ChatMessage message) async {
    if (_disabledForRapidSending) return;
    _disabledForRapidSending = true;

    if (widget.newChat) {
      List<String> usersGroup = <String>[];

      // String msgIcon;
      int chatUserIndex = 0;

      widget.usersMap.forEach((user, _) {
        usersGroup.add(user);
        // if (chatUserIndex++ == 1) {
        //   msgIcon = _.avatar;
        // }
      });

      _messagesStream.emit('message new', {
        'users_list': usersGroup,
  			'icon': '',//msgIcon,
  			'name': '',//widget.chatName,
      });

      do {
        await Future.delayed(Duration(milliseconds: 100));
      } while (widget.newChat);
    }

    _messagesStream.emit('chat', {
      'id': message.id,
      'text': message.text,
      'image': message.image,
      'video': message.video,
      'time': message.createdAt.millisecondsSinceEpoch,
      'user': message.user.uid,
      'properties': message.customProperties,
    });

    var msg = message.toJson();

    msg['interior'] = 'crocodile';

    _messagesStream.add([msg]);

    if (i == 0) {
      _systemMessage();
      Timer(Duration(milliseconds: 600), () {
        _systemMessage();
      });
    } else {
      _systemMessage();
    }

    await Future.delayed(Duration(milliseconds: 500));
    _disabledForRapidSending = false;
  }
  void _insertMessage(var data) {
    if (data['image']!=null) {
      data['image'] = Constants.media_source + data['image'];
    }

    try {
      if (data['interior']=='crocodile') {
        messages.add(ChatMessage.fromJson(data));
      }
      else {
        data['createdAt'] = data['time'];

        data['user'] = widget.usersMap[data['user']].toJson();

        messages.add(ChatMessage.fromJson(data));
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> _uploadMedia(File _media, bool isVideo) async {
    if (_media == null) return {
      'link': '',
    };

    try {
      var media_data;

      if (isVideo) {
        media_data = await cloudinary_client.uploadVideo(
          _media.path,
          folder: 'messages/' + UserData.client.name,
        );
      }
      else {
        media_data = await cloudinary_client.uploadImage(
          _media.path,
          folder: 'messages/' + UserData.client.name,
        );
      }

      return {
        'link': media_data.secure_url.replaceAll(
                  Constants.media_source, ''
                ),
        'height': media_data.height,
        // 'duration': media_data.duration==null ? null : media_data.duration,
      };
    } catch (e) {
      print('''
      =====================================
                  Arrival Error
          $e
      =====================================
      ''');
    }

    return {
      'link': '',
    };
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName),
      ),
      body: StreamBuilder(
        stream: _messagesStream.response,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (int i=0;i<snapshot.data.length;i++) {
              if (snapshot.data[i]['type'] == 1001) {
                widget.newChat = false;
              }
              else if (messages.length == 0) {
                _insertMessage(snapshot.data[i]);
              }
              else if (snapshot.data[i]['id'] != messages.last.id) {
                _insertMessage(snapshot.data[i]);
              }
            }
          }

          return DashChat(
            key: _chatViewKey,
            inverted: false,
            onSend: _onSend,
            sendOnEnter: true,
            textInputAction: TextInputAction.send,
            user: widget.clientUser,
            inputDecoration:
            InputDecoration.collapsed(hintText: "Start collaborating..."),
            dateFormat: DateFormat('yyyy-MMM-dd'),
            timeFormat: DateFormat('HH:mm'),
            messages: messages,
            showUserAvatar: false,
            showAvatarForEveryMessage: false,
            scrollToBottom: true,
            onPressAvatar: (ChatUser user) {
              print("OnPressAvatar: ${user.name}");
            },
            onLongPressAvatar: (ChatUser user) {
              print("OnLongPressAvatar: ${user.name}");
            },
            inputMaxLines: 5,
            messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
            alwaysShowSend: true,
            inputTextStyle: TextStyle(fontSize: 16.0),
            inputContainerStyle: BoxDecoration(
              border: Border.all(width: 0.0),
              color: Colors.white,
            ),
            onQuickReply: (Reply reply) {

              print('-> INSIDE QUICK REPLY TEST');


              _messagesStream.add([ChatMessage(
                text: reply.value,
                createdAt: DateTime.now(),
                user: widget.clientUser).toJson()]);

              Timer(Duration(milliseconds: 300), () {
                _chatViewKey.currentState.scrollController
                ..animateTo(
                  _chatViewKey.currentState.scrollController.position
                  .maxScrollExtent,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );

                if (i == 0) {
                  _systemMessage();
                  Timer(Duration(milliseconds: 600), () {
                    _systemMessage();
                  });
                } else {
                  _systemMessage();
                }
              });
            },
            shouldShowLoadEarlier: false,
            showTraillingBeforeSend: true,
            trailing: <Widget>[
              IconButton(
                icon: Icon(Icons.photo),
                onPressed: () async {
                  File result = await ImagePicker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                    maxHeight: 400,
                    maxWidth: 400,
                  );

                  if (result != null) {
                    if (_isUnacceptableFile(result)) return;

                    var data = await _uploadMedia(result, _isVideo(result));

                    _onSend(ChatMessage(text: "", user: widget.clientUser, image: data['link']));
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }
}
