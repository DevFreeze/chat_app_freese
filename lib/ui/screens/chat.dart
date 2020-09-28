import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_freese/models/chat_message_model.dart';
import 'package:chat_app_freese/models/chat_model.dart';
import 'package:chat_app_freese/provider/auth_provider.dart';
import 'package:chat_app_freese/ui/widgets/message.dart';

class Chat extends StatefulWidget {

  final ChatModel chat;

  const Chat({Key key, this.chat}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  String chatEndpoint = "https://idtm-media.s3.amazonaws.com/programming-test/api/";
  List<ChatMessageModel> chatMessages = new List();
  TextEditingController controller = new TextEditingController();
  ScrollController scrollController = ScrollController();

  int timeUntilMockAnswer = 2000;
  String mockAnswer = "Cool";

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    if (widget.chat.id.isNotEmpty) {
      final response = await get(chatEndpoint + widget.chat.id  + ".json");

      if (response.statusCode == 200) {

        // Check if the JSON list ends with a final comma
        // If so -> delete it
        String body = response.body.trim();

        if (body.contains("},]")) {
          body = body.substring(0, body.length - 3) + "}]";
        }

        final parsed = json.decode(body);
        setState(() {
          chatMessages = ChatMessageModel.getChatMessages(parsed);
        });
      } else {
        throw Exception('Failed to load the chat messages');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.topic ?? ""),
      ),
      body: Column(
        children: [
          _chatMessages(),
          _textField(),
        ],
      ),
    );
  }

  Widget _chatMessages() {
    return Expanded(
      child: ListView.builder(
        itemCount: chatMessages.length,
        itemBuilder: (context, index) {
          if (chatMessages[index] == null) {
            return Container();
          } else {
            return Message(
              message: chatMessages[index],
            );
          }
        },
        controller: scrollController,
      ),
    );
  }

  Widget _textField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Your message...",
        filled: true,
        suffixIcon: IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            _sendMessage();
          },
        ),
      ),
      controller: controller,
    );
  }

  void _sendMessage() {
    String _message = controller.text;
    DateTime now = DateTime.now();

    ChatMessageModel newMessage = new ChatMessageModel(
      id: widget.chat.id,
      message: _message,
      sender: Provider.of<AuthProvider>(context, listen: false).user.username,
      modified_at: now.millisecondsSinceEpoch,
    );

    setState(() {
      chatMessages.add(newMessage);
    });

    scrollDown();
    controller.clear();

    Future.delayed(Duration(milliseconds: timeUntilMockAnswer)).then((val) {
      sendMockAnswer();
    });
  }

  void sendMockAnswer() {
    DateTime now = DateTime.now();

    ChatMessageModel newMessage = new ChatMessageModel(
      id: widget.chat.id,
      message: mockAnswer,
      sender: widget.chat.members.first,
      modified_at: now.millisecondsSinceEpoch,
    );

    setState(() {
      chatMessages.add(newMessage);
    });

    scrollDown();
  }

  // Wait some milliseconds, so the list is updated
  // Then scroll list to the end
  void scrollDown() {
    Future.delayed(Duration(milliseconds: 500)).then((val) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }
}
