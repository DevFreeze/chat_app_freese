import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_freese/models/chat_message_model.dart';
import 'package:chat_app_freese/provider/auth_provider.dart';

class Message extends StatefulWidget {
  final ChatMessageModel message;

  const Message({
    Key key,
    this.message,
  }) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  bool fromMe = false;

  @override
  void initState() {
    super.initState();
    // Check if the message is from me for color and position in list
    if (widget.message != null &&
        (widget.message.sender ==
            Provider.of<AuthProvider>(context, listen: false).user.username)) {
      fromMe = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        child: Column(
          // Messages from me -> right; all others -> left
          crossAxisAlignment:
              fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            _userNameAndTimestamp(),
            _chatMessage(),
          ],
        ),
      ),
    );
  }

  Widget _userNameAndTimestamp() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Text(
        (widget.message.sender ?? "") +
            " - " +
            _formatTimestampToDate(widget.message.modified_at),
      ),
    );
  }

  Widget _chatMessage() {
    return Material(
      color: fromMe ? Colors.blue : Colors.blue[200],
      borderRadius: BorderRadius.circular(20.0),
      elevation: 6.0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                widget.message != null ? (widget.message.message ?? "") : "",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestampToDate(int timestamp) {
    if (timestamp == null) {
      return "";
    }
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var format = new DateFormat('dd.MM, hh:mm');
    return format.format(date);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
