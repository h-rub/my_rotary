import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_rotary/screens/members/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class PostWidget extends StatefulWidget {
  final Post post;

  PostWidget({this.post});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool likedByMe = false;

  // Shared Preferennces
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  saveLike(postID) async {
    final SharedPreferences prefs = await _prefs;
    int user_id = await prefs.getInt("user_id");
    String url = "http://rotary.syncronik.com/api/v1/myclub/posts/reaction";
    var jsonResponse;
    Map body = {"post_id": postID.toString(), "liked_by": user_id.toString()};
    var res = await http.post(url, body: body);

    if (res.statusCode == 200) {
      String source = Utf8Decoder().convert(res.bodyBytes);
      jsonResponse = json.decode(source);
      print("Status code ${res.statusCode}");
      print("Response JSON ${jsonResponse}");
      setState(() {});
      if (jsonResponse != Null) {}
    } else if (res.statusCode == 401) {
      print("Error de autenticación");
    } else if (res.statusCode == 500) {
      print("Error del servidor");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                    "http://rotary.syncronik.com/media/${widget.post.profileImageUrl}"),
                radius: 20.0,
              ),
              SizedBox(width: 7.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.post.username,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0)),
                  SizedBox(height: 5.0),
                  Text(widget.post.time)
                ],
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.post.content,
                      style: TextStyle(fontSize: 16.0))),
            ],
          ),
          SizedBox(height: 13.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.thumbsUp,
                      size: 15.0, color: Colors.blue),
                  Text(' ${widget.post.likes}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('${widget.post.comments} comments'),
                ],
              ),
            ],
          ),
          Divider(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.post.isLikedByMe = !widget.post.isLikedByMe;
                    });
                    saveLike(widget.post.pid);
                    var likesInt = int.parse(widget.post.likes);
                    assert(likesInt is int);
                    if (widget.post.isLikedByMe) {
                      likesInt += 1;
                      widget.post.likes = likesInt.toString();
                    } else {
                      likesInt -= 1;
                      widget.post.likes = likesInt.toString();
                    }
                  },
                  child: widget.post.isLikedByMe
                      ? Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.thumbsUp,
                                size: 20.0, color: Colors.blue),
                            SizedBox(width: 5.0),
                            Text('Like',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.blue)),
                          ],
                        )
                      : Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.thumbsUp, size: 20.0),
                            SizedBox(width: 5.0),
                            Text('Like', style: TextStyle(fontSize: 14.0)),
                          ],
                        )),
              Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.commentAlt, size: 20.0),
                  SizedBox(width: 5.0),
                  Text('Comment', style: TextStyle(fontSize: 14.0)),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.share, size: 20.0),
                  SizedBox(width: 5.0),
                  Text('Share', style: TextStyle(fontSize: 14.0)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
