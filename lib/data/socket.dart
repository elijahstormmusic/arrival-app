
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';
import '../users/data.dart';
import '../data/arrival.dart';
import '../posts/post.dart';

class ArrivalSocket {
  SocketIO socket;
  var source;

  void init() {
    socket = SocketIOManager().createSocketIO(
      'https://arrival-app.herokuapp.com', '/');
    socket.init();

    socket.subscribe('message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);

      if(data['type']==800) {
        var list = data['response'];

        for(int i=0;i<list.length;i++) {
          ArrivalData.posts.add(Post.icon(
            cryptlink: list[i]['link']
          ));
        }
for(int i=0;i<list.length;i++) {
ArrivalData.posts.add(Post.icon(
cryptlink: list[i]['link']
));
}
        source.responded();
      }
    });

    socket.connect();
  }

  void send(String _req, var _data) {
    socket.sendMessage(
      _req, json.encode(_data),
    );
  }
}
