import 'package:chat_app/constants.dart';
import 'package:chat_app/model/message.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      // Align : to alignment Container in ListView
      // Alignment : بتعمل مساحة حوالين ال child عشان تحركه زي مهي عايزة
      alignment:
          Alignment.centerLeft, // خلت ال Container ياخد مساحة ال child بتاعه
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // مينفعش تبقي موجودة لانها بتعمل مساحة للنص وملهاش لازمة alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          color: kPrimaryColor,
        ),
        child: Text(message.message, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class ChatBubbleForFriend extends StatelessWidget {
  const ChatBubbleForFriend({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      // Align : to alignment Container in ListView
      // Alignment : بتعمل مساحة حوالين ال child عشان تحركه زي مهي عايزة
      alignment:
          Alignment.centerRight, // خلت ال Container ياخد مساحة ال child بتاعه
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // مينفعش تبقي موجودة لانها بتعمل مساحة للنص وملهاش لازمة alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomLeft: Radius.circular(32),
          ),
          color: Color(0xFF006D84),
        ),
        child: Text(message.message, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
