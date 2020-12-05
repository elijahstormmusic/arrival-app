import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';

import '../../data/socket.dart';
import '../../users/data.dart';
import '../../users/profile.dart';
import '../../styles.dart';


class Messager extends StatefulWidget {
  final String index;
  final ChatUser clientUser = ChatUser(
    name: UserData.client.name,
    uid: UserData.client.cryptlink,
    avatar: UserData.client.media_href(),
  );
  final Map<String, ChatUser> usersMap = Map<String, ChatUser>();
  String chatName;
  bool _allowedToChat = false;
  bool newChat = false;

  Messager(@required this.index, Map<String, dynamic> inputData) {
    _initalizeChat(inputData);
  }
  Messager.create(Map<String, dynamic> inputData, {
    this.index = '',
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
      String newName = 'Chat with ';

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

  var i = 0;

  @override
  void initState() {
    super.initState();
    _messagesStream = socket.stream('');

    _messagesStream.emit('set chat state', {
      'name': 'ya mama',
      'link': UserData.client.cryptlink,
      'thread': widget.index,
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
        _messagesStream.add(m[i].toJson());
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
    if (widget.newChat) {
      widget.newChat = false;
      List<String> usersGroup = <String>[];

      widget.usersMap.forEach((user, _) {
        if (UserData.client.cryptlink == user) return;
        usersGroup.add(user);
      });

      _messagesStream.emit('message new', {
        'user': UserData.client.cryptlink,
        'users_list': usersGroup,
      });
    }

    await Future.delayed(Duration(milliseconds: 500));
    
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

    _messagesStream.add(msg);

    if (i == 0) {
      _systemMessage();
      Timer(Duration(milliseconds: 600), () {
        _systemMessage();
      });
    } else {
      _systemMessage();
    }
  }
  void _insertMessage(var messages, var data) {
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
            if (messages.length == 0) {
              _insertMessage(messages, snapshot.data);
            }
            else if (snapshot.data['id'] != messages.last.id) {
              _insertMessage(messages, snapshot.data);
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


              _messagesStream.add(ChatMessage(
                text: reply.value,
                createdAt: DateTime.now(),
                user: widget.clientUser).toJson());

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
