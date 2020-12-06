
import '../../users/profile.dart';

class ChatModel {
  final String messageThread;
  final String avatarUrl;
  final String name;
  final List<dynamic> userIndexes;
  final String lastMsgUser;
  final String datetime;
  final String message;

  ChatModel({
    this.messageThread, this.userIndexes, this.avatarUrl, this.name,
    this.lastMsgUser, this.datetime, this.message,
  }) {
    for (int i=0;i<userIndexes.length;i++) {
      Profile.lite(userIndexes[i]);
    }
  }
}
