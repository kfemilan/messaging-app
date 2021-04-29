import 'package:messaging_app/models/Message.dart';

class Conversation {
  List<String> peopleUserId; // List of user ids
  List<Message> messages; // Should be sorted by timestamp
}
