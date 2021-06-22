import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../helpers/key.dart';
import '../../models/post.dart';
import '../../providers/user.dart';

class PostBox extends StatefulWidget {
  final Post post;
  PostBox({Key key, this.title, @required this.post}) : super(key: key);
  final String title;

  @override
  _PostBoxState createState() => _PostBoxState();
}

class _PostBoxState extends State<PostBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                foregroundImage: NetworkImage(
                    "http://10.0.2.2/data/avatars/o/0/" +
                        (widget.post.user.id).toString() +
                        ".jpg"),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              title: Text(
                "${widget.post.user.username}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              /* trailing: Text(
                DateTime.fromMicrosecondsSinceEpoch(widget.post.date)
                        .day
                        .toString() +
                    '-' +
                    DateTime.fromMicrosecondsSinceEpoch(widget.post.date)
                        .month
                        .toString() +
                    '-' +
                    DateTime.fromMicrosecondsSinceEpoch(widget.post.date)
                        .year
                        .toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),*/
            ),
            Container(
                //width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 5.0),
                padding: EdgeInsets.only(bottom: 5.0, left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 1.0, color: Color(0xffc4c4c4)))),
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 95.0,
                        child: Text(
                          widget.post.message,
                          //textWidthBasis: TextWidthBasis.values,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        width: 75.0,
                        child: FloatingActionButton(
                          onPressed: () {
                            Future<dynamic> postThreaddd() async {
                              print('${widget.post.id}abcberke');
                              final response = await http.post(
                                url + 'mesaj/8393/react?reaction_id=1',
                                headers: <String, String>{
                                  'XF-Api-Key': apiKey,
                                  'XF-Api-User': Provider.of<UserModel>(context,
                                          listen: false)
                                      .id,
                                  'Content-Type':
                                      'application/x-www-form-urlencoded',
                                },
                              );
                              if (response.statusCode == 200) {
                                setState(() {});
                                // If the server did return a 200 OK response,
                                // then parse the JSON.
                              } else {
                                setState(() {});
                                // If the server did not return a 200 OK response,
                                // then throw an exception.
                                //throw Exception('Failed to load post thread');
                              }
                            }

                            postThreaddd();
                          },
                          child: Icon(Icons.thumb_up),
                        ),
                      )
                    ],
                  ),
                )),
            // Image.asset(
            //   "${widget.img}",
            //   height: 170,
            //   width: MediaQuery.of(context).size.width,
            //   fit: BoxFit.cover,
            // ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
