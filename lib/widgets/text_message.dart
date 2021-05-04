import 'package:flutter/material.dart';

import '../models/Message.dart';

class TextMessage extends StatelessWidget {
  const TextMessage(this.message, this.color);

  final Message message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Text(
        message.message,
        style: TextStyle(color: color),
      ),
    );
  }
}
