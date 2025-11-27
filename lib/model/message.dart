import 'package:chat_app/constants.dart';

class Message {
  final String message;
  final String id;

  Message({required this.message, required this.id});
  factory Message.fromjson(jsonData) {
    return Message(message: jsonData[kMessage] ?? '', id: jsonData['id'] ?? '');
  }
}
