import 'package:flutter/material.dart';
import 'package:xenforo/components/threadForumBox/index.dart';
import 'package:xenforo/models/forumContent.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xenforo/helpers/key.dart';

class ThreadInfo extends StatefulWidget {
  final int id;
  ThreadInfo({Key key, this.title, this.id}) : super(key: key);

  final String title;

  @override
  _ThreadInfoState createState() => new _ThreadInfoState();
}

class _ThreadInfoState extends State<ThreadInfo> {
  final GlobalKey _scaffoldKey = new GlobalKey();
  Future<dynamic> futureForums;
  List<ForumContent> forums;

  Future<dynamic> fetchThreadInfo() async {
    final response = await http.get(
      url + 'threads/'+widget.id.toString()+'?with_posts=true',
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
      print(json
          .decode(response.body)['threads']);
      List<ForumContent> tester = List();
      for(var i =0;i<json.decode(response.body)['threads'].length;i++){
       tester.add(ForumContent.fromMap(json
          .decode(response.body)['threads'][i]));
      }
      return tester;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load forums');
    }
  }

  @override
  void initState() {
    super.initState();
    futureForums = fetchThreadInfo();
  }

  @override
  Widget build(BuildContext context) {
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
              return Center(child: Text('No Forums available'));
            }
            if (snapshot.hasData) {
             // print(jsonDecode(snapshot.data[0]));
              return new ListView.builder(
                itemBuilder: (BuildContext context, int index){
               //   print(Forum(title: snapshot.data));
                 return new ThreadForumBox(
                  forumData: snapshot.data[index]);
                },
                itemCount: snapshot.data.length,
                shrinkWrap: true,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      
    );
  }
}