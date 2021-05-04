import 'package:flutter/material.dart';

import '../models/Message.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage(this.message);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 100.0,
        minWidth: 100.0,
        maxHeight: 200.0,
        maxWidth: 200.0,
      ),
      child: Image(
        image: NetworkImage(message.message),
        fit: BoxFit.cover,
      ),
    );
  }
}
