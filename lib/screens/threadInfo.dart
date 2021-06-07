import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../components/emptyData/index.dart';
import '../components/loader.dart';
import '../components/postBox/index.dart';
import '../components/threadHeader/threadHeader.dart';
import '../helpers/key.dart';
import '../models/forumContent.dart';
import '../models/post.dart';
import '../providers/user.dart';
import 'auth/login.dart';
import 'newPost.dart';

int pagenum = 1;

class ThreadInfo extends StatefulWidget {
  final int id;
  final ForumContent forumData;
  ThreadInfo({Key key, this.title, this.id, this.forumData}) : super(key: key);

  final String title;

  @override
  _ThreadInfoState createState() => new _ThreadInfoState();
}

class _ThreadInfoState extends State<ThreadInfo> {
  ScrollController _controller = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<dynamic> futurePosts;
  List<Post> posts;

  Future<dynamic> fetchThreadInfo() async {
    print('Evet${widget.id}');
    final response = await http.get(
      url + 'threads/' + widget.id.toString() + '/posts',
      headers: <String, String>{
        'XF-Api-Key': apiKey,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(json.decode(response.body)['posts']);
      List<Post> tester = List();
      for (var i = 0; i < json.decode(response.body)['posts'].length; i++) {
        tester.add(Post.fromMap(json.decode(response.body)['posts'][i]));
      }
      return tester;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load posts');
    }
  }

  @override
  void initState() {
    super.initState();
    futurePosts = fetchThreadInfo();
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
              onPressed: () => {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: Login()))
              },
            ),
          ],
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: futurePosts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                //print('project snapshot data is: ${projectSnap.data}');
                return EmptyData(title: 'Posts for ' + widget.title);
              }
              if (snapshot.hasData) {
                // print(jsonDecode(snapshot.data[0]));
                return new Stack(children: <Widget>[
                  Column(children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          futurePosts;
                        },
                        child: Text("Sonraki Sayfa")),
                    ThreadHeader(forumData: widget.forumData),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  child: NewPost(
                                    forumData: widget.forumData,
                                    id: widget.id,
                                    title: widget.title,
                                  )));
                        },
                        child: Text("Mesaj gönder")),
                    new ListView.builder(
                      physics: PageScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        //   print(Post(title: snapshot.data));
                        return new PostBox(post: snapshot.data[index]);
                      },
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      controller: _controller,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: NewPost(
                        forumData: widget.forumData,
                        title: widget.title,
                        id: widget.forumData.id,
                      ),
                    )
                  ]),
                ]);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return Loader();
            },
          ),
        ));
  }
}
