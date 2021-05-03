import 'package:messaging_app/models/Message.dart';

class Conversation {
  Conversation({this.name = "", this.peopleUserId, this.latestMessage});

  String name; // Conversation Name
  List<String> peopleUserId; // List of user ids
  Message latestMessage;
  // List<Message>
  //     messages; // Should be sorted by timestamp, with latest at the top

  // Message getLatestMessage() {
  //   // To change if ever
  //   return this.messages.isEmpty
  //       ? Message(senderId: "asd", message: "Empty", timeSent: DateTime.now())
  //       : this.messages[0];
  // }
}
