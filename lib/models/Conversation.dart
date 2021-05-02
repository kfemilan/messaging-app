import 'package:messaging_app/models/Message.dart';

class Conversation {
  Conversation({this.name, this.peopleUserId, this.messages});

  String name; // Conversation Name
  List<String> peopleUserId; // List of user ids
  List<Message> messages; // Should be sorted by timestamp, with latest at the top

  Message getLatestMessage() {
    // To change if ever
    return this.messages.isEmpty ? Message(senderId: 0, message: "Empty", timeSent: DateTime.now()) : this.messages[0];
  }
}
