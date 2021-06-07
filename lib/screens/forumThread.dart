import 'package:flutter/material.dart';
import '../components/threadForumBox/index.dart';
import '../models/forumContent.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/key.dart';
import '../components/emptyData/index.dart';
import '../components/loader.dart';
import '../components/buttons/floatingButton.dart';
import 'package:page_transition/page_transition.dart';
import 'newThread.dart';
import 'package:provider/provider.dart';
import '../providers/user.dart';
import 'auth/login.dart';

class ForumThread extends StatefulWidget {
  final int id;
  ForumThread({Key key, @required this.title, @required this.id})
      : super(key: key);

  final String title;

  @override
  _ForumThreadState createState() => new _ForumThreadState();
}

class _ForumThreadState extends State<ForumThread> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<dynamic> futureForums;
  List<ForumContent> forums;

  Future<dynamic> fetchForumThread() async {
    final response = await http.get(
      url + 'forums/' + widget.id.toString() + '?with_threads=true',
      headers: <String, String>{
        'XF-Api-Key': apiKey,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      // body: jsonEncode(<String, String>{
      //   'title': title,
      // }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(json.decode(response.body)['threads']);
      List<ForumContent> tester = List();
      for (var i = 0; i < json.decode(response.body)['threads'].length; i++) {
        tester.add(
            ForumContent.fromMap(json.decode(response.body)['threads'][i]));
      }
      return tester;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //  throw Exception('Failed to load forums');
    }
  }

  @override
  void initState() {
    super.initState();
    futureForums = fetchForumThread();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<UserModel>(context);
    if (appState.id != '') {}
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () => {},
          ),
        ],
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: futureForums,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return EmptyData(title: 'Threads for ' + widget.title);
          }
          if (snapshot.hasData) {
            // print(jsonDecode(snapshot.data[0]));
            return new ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                //   print(Forum(title: snapshot.data));
                return new ThreadForumBox(forumData: snapshot.data[index]);
              },
              itemCount: snapshot.data.length,
              shrinkWrap: true,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Loader();
        },
      ),
      floatingActionButton: FloatingButton(
        onPressed: appState.id != ''
            ? () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: NewThread(
                          title: widget.title,
                          id: widget.id,
                        )));
              }
            : () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: Login()));
              },
      ),
    );
  }
}
