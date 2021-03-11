import 'package:flutter/material.dart';
import 'package:cempro_gps/ui/screens/screens.dart';


class MensajesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        // 'chat': (ctx) => ChatScreen(),
      },
    );
  }
}