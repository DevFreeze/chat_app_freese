import 'package:flutter/material.dart';

import 'package:chat_app_freese/models/chat_model.dart';
import 'package:chat_app_freese/ui/screens/chat.dart';

class ChatItem extends StatefulWidget {
  final ChatModel chat;

  const ChatItem({Key key, this.chat}) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {

  String mockAvatar = "https://randomuser.me/api/portraits/men/76.jpg";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: mockAvatar != null ? CircleAvatar(
        backgroundImage:
            NetworkImage(mockAvatar),
      ) : Container(
        width: 20,
      ),
      title: Text(widget.chat.topic ?? ""),
      subtitle: Text(widget.chat.last_message ?? ""),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Chat(chat: widget.chat),
          ),
        );
      },
    );
  }
}
