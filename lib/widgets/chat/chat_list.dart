
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../data/socket.dart';
import '../../data/link.dart';
import '../../users/data.dart';
import '../../users/profile.dart';
import '../../foryou/explore.dart';
import '../../styles.dart';
import 'chat_model.dart';
import 'messager.dart';

class ChatList extends StatefulWidget {
  _ChatListState state;

  ChatList() {
    socket.emit('chatlist ask', {
      'user': UserData.client.cryptlink,
    });

    socket.chatlist = this;

    state = _ChatListState();
  }

  void loadData(List<dynamic> data) => state.loadData(data);

  @override
  _ChatListState createState() => state;
}

class _ChatListState extends State<ChatList> {

  List<ChatModel> _fluidChatList;
  Future<bool> _loaded;

  @override
  void initState() {
    super.initState();
    _loaded = _waitForDataLoad();
  }

  Future<bool> _waitForDataLoad() async {
    do {
      await Future.delayed(Duration(milliseconds: 100));
    } while (_fluidChatList == null);
    return true;
  }

  void loadData(List<dynamic> addableChatData) {
    if (!mounted) return;

    if (_fluidChatList == null) _fluidChatList = List<ChatModel>();

    List<ChatModel> chatList = List<ChatModel>();
    
    for (int i=0;i<addableChatData.length;i++) {
      if (addableChatData[i]==null) continue;

      if (addableChatData[i]['icon']=='') {
        int userIndex = 0;

        while (addableChatData[i]['users'][userIndex]==UserData.client.cryptlink) {
          userIndex++;
        }

        addableChatData[i]['icon'] = Profile.lite(addableChatData[i]['users'][userIndex]).media_href();
      }

      if (addableChatData[i]['name']=='') {
        int userIndex = 0;

        while (addableChatData[i]['users'][userIndex]==UserData.client.cryptlink) {
          userIndex++;
        }

        addableChatData[i]['name'] = Profile.lite(addableChatData[i]['users'][userIndex]).name;
      }

      chatList.add(ChatModel(
        messageThread: addableChatData[i]['thread'],
        userIndexes: addableChatData[i]['users'],
        avatarUrl: addableChatData[i]['icon'],
        name: addableChatData[i]['name'],
        datetime: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.fromMillisecondsSinceEpoch(addableChatData[i]['lastMsgTime'])),
        message: addableChatData[i]['lastMsg']=='' ? 'Sent an Image' : addableChatData[i]['lastMsg'],
        lastMsgUser: addableChatData[i]['lastMsgUser'],
      ));
    }

    setState(() => _fluidChatList += chatList);
  }

  Widget _buildChatListData(List<ChatModel> chatList) {
    if (chatList.isEmpty) {
      return Center(
        child: Container(
          height: 250,
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Text(
                'You have no active messages. Start by adding friends or finding new ones!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Arrival.navigator.currentState.push(MaterialPageRoute(
                    builder: (context) => Explore(type: 'posts'),
                    fullscreenDialog: true,
                  ));
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Styles.ArrivalPalletteRed,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text(
                    'Explore',
                    style: TextStyle(
                      color: Styles.ArrivalPalletteWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        ChatModel _model = chatList[index];
        return GestureDetector(
          onTap: () => Arrival.navigator.currentState.push(MaterialPageRoute(
            builder: (context) => Messager(
              _model.messageThread,
              {
                'group': chatList[index].userIndexes,
              }
            ),
            fullscreenDialog: true,
          )),
          child: Column(
            children: <Widget>[
              Divider(
                height: 12.0,
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 24.0,
                  backgroundImage: NetworkImage(_model.avatarUrl),
                ),
                title: Row(
                  children: <Widget>[
                    Text(_model.name),
                    SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      _model.datetime,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      _model.lastMsgUser == UserData.client.cryptlink ?
                        Icons.call_made :
                        Icons.call_received,
                      color: _model.lastMsgUser == UserData.client.cryptlink ?
                        Styles.ArrivalPalletteBlue :
                        Styles.ArrivalPalletteGreen,
                      size: 16,
                    ),
                    SizedBox(width: 8.0),
                    Text(_model.message),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arrival Chat'),
      ),
      body: FutureBuilder<bool>(
        future: _loaded,
        builder: (c, snapshot) =>
          snapshot.hasData ?
            _buildChatListData(_fluidChatList) :
            Center(
              child: Container(
                width: 100.0,
                height: 100.0,
                child: Styles.ArrivalBucketLoading,
              ),
            ),
      ),
    );
  }
}
