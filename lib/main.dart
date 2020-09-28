import 'package:chat_app_freese/provider/auth_provider.dart';
import 'package:chat_app_freese/ui/screens/chats.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // Mock user
  User user = User(
    id: "123",
    username: "Jens",
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(user),
        ),
      ],
      child: MaterialApp(
        title: 'Chat Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Chats(),
      ),
    );
  }
}