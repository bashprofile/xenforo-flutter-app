import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../components/buttons/borderButton/index.dart';
import '../components/loader.dart';
import '../helpers/key.dart';
import '../models/forumContent.dart';
import '../providers/user.dart';
import 'threadInfo.dart';

var _controllerr;

class NewPost extends StatefulWidget {
  NewPost(
      {Key key,
      @required this.id,
      @required this.title,
      @required this.forumData})
      : super(key: key);
  final int id;
  final String title;
  final ForumContent forumData;

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _message;
  Future<dynamic> newPost;
  bool _showLoader = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<dynamic> postThread() async {
    _showLoader = true;
    final response = await http.post(
      url + 'posts/?thread_id=' + widget.id.toString() + '&message=' + _message,
      headers: <String, String>{
        'XF-Api-Key': apiKey,
        'XF-Api-User': Provider.of<UserModel>(context, listen: false).id,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        _showLoader = false;
      });
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ThreadInfo(forumData: widget.forumData, title: widget.title),
          ),
          (Route<dynamic> route) => false);
    } else {
      setState(() {
        _showLoader = false;
      });
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to load post thread');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void post() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to our variables
      _formKey.currentState.save();
      postThread();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      /*appBar: AppBar(
        title: Text(widget.title),
      ),*/
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: customForm(),
          ),
        ),
      ),
    );
  }

  Widget customForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _showLoader ? Loader() : Container(),
        new Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
            width: MediaQuery.of(context).size.width * 0.90,
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                //                    <--- top side
                //color: const Color(0xffC4C4C4),
                width: 1.0,
              ),
            )),
            child: new TextFormField(
              controller: _controllerr,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: new InputDecoration(
                labelText: "Message",
                fillColor: Colors.white,
                hintText: 'Enter message of post',
                hintStyle: TextStyle(
                  fontSize: 13.0,
                  color: const Color(0xffC4C4C4),
                ),
                border: InputBorder.none,
              ),
              validator: (val) {
                if (val.length == 0) {
                  return "Message is required for this post";
                } else {
                  return null;
                }
              },
              style: new TextStyle(
                fontSize: 16.0,
                //color: Colors.black,
                //    height: 1.0,
              ),
              onSaved: (String val) {
                _message = val;
              },
            )),
        Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
            child: BorderButton(
              title: 'POST',
              onPressed: () {
                post();
                Navigator.pop(context);
              },
            ))
      ],
    );
  }
}
