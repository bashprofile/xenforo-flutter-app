import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../components/emptyData/index.dart';
import '../components/loader.dart';
import '../helpers/key.dart';
import '../models/user.dart';
import '../providers/user.dart';

String username = "s";

class Profile extends StatefulWidget {
  Profile({
    Key key,
  }) : super(key: key);

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<User> futureProfile;
  User user;

  Future<User> fetchProfile() async {
    final response = await http.get(
      url +
          'users/' +
          Provider.of<UserModel>(context, listen: false).id.toString(),
      headers: <String, String>{
        'XF-Api-Key': apiKey,
        'XF-Api-User': Provider.of<UserModel>(context, listen: false).id,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(json.decode(response.body)['user']);
      user = User.fromMap(json.decode(response.body)['user']);
      return user;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //  throw Exception('Failed to load forums');
    }
  }

  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<UserModel>(context);
    if (appState.id != '') {}
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        /*title: Text(user.username != "" ? user.username : 'Profile',
            style: TextStyle(color: Colors.black, fontSize: 16.0)),*/
      ),
      body: FutureBuilder(
        future: futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return EmptyData(title: 'Profil');
          }
          if (snapshot.hasData) {
            var proinfo = snapshot.data;
            return Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 20,
                        margin: EdgeInsets.only(bottom: 5.0, top: 5.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.blue, Colors.green]),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              /*BoxShadow(
                                  offset: Offset(4.0, 5.0),
                                  blurRadius: 20,
                                  spreadRadius: 1)*/
                            ]),
                        //height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    foregroundImage: NetworkImage(
                                        snapshot.data.avatar_urls['h']),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Column(
                                      children: [
                                        Text(
                                            "${snapshot.data.username}\n\nReactions: ${snapshot.data.reactionScore}   Çözümler: ${snapshot.data.question_solution_count}")
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10.0, left: 10.0),
                            alignment: Alignment.center,
                            width: 125,
                            height: 125,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Custom Fields"),
                                Text(
                                  "${snapshot.data.custom_fields['customfields']}",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      //offset: Offset(5.0, 10.0),
                                      blurRadius: 20,
                                      spreadRadius: 2)
                                ]),
                          ),
                        ],
                      ),
                    ],
                  )
                ]);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return Loader();
        },
      ),
    );
  }
}
