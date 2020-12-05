
import '../../users/profile.dart';

class ChatModel {
  final String messageIndex;
  final String avatarUrl;
  final String name;
  final List<String> userIndexes;
  final String datetime;
  final String message;

  ChatModel({this.messageIndex, this.userIndexes, this.avatarUrl, this.name, this.datetime, this.message}) {
    for (int i=0;i<userIndexes.length;i++) {
      Profile.lite(userIndexes[i]);
    }
  }
}
