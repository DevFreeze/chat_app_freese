import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';

import 'package:chat_app_freese/models/chat_model.dart';
import 'package:chat_app_freese/ui/widgets/chat_item.dart';

class Chats extends StatefulWidget {

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  List<ChatModel> chats = new List();
  String chatEndpoint = "https://idtm-media.s3.amazonaws.com/programming-test/api/inbox.json";

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  Future<void> fetchChats() async {
    final response = await get(chatEndpoint);

    if (response.statusCode == 200) {
      // Check if the JSON list ends with a final comma
      // If so -> delete it
      String body = response.body.trim();

      if (body.isNotEmpty) {
        if (body.contains("},]")) {
          body = body.substring(0, body.length - 3) + "}]";
        }

        final parsed = json.decode(body);

        setState(() {
          chats = ChatModel.getChats(parsed);
        });
      }
    } else {
      throw Exception('Failed to load chats');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => seperator(),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          if(chats[index] != null) {
            return ChatItem(chat: chats[index]);
          } else {
            return Container();
          }

        },
      ),
    );
  }

  Widget seperator() {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
      child: Divider(
        height: 5.0,
        thickness: 1.0,
      ),
    );
  }
}