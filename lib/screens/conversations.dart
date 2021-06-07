import 'package:flutter/material.dart';

class Conversations extends StatefulWidget {
  Conversations({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ConversationsState createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: CircularProgressIndicator(
      backgroundColor: Color(0xff007C89),
    )));
  }
}
