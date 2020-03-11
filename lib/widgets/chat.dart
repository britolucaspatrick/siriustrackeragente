import 'package:flutter/material.dart';
import 'package:siriustrackeragente/models/servicesbyuser.dart';
import 'package:siriustrackeragente/screens/chat.dart';

class Chat extends StatelessWidget {
  final ServicesByUser service;

  Chat({Key key, @required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: new Text('Chat', style: TextStyle(color: Colors.black),),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
        elevation: 0,
        centerTitle: true,
      ),
      body: new ChatScreen(
        serv: service,
      ),
    );
  }
}
