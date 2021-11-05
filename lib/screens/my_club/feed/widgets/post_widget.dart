import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_rotary/screens/members/models/post.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  PostWidget({this.post});

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool likedByMe = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage(widget.post.profileImageUrl),
                radius: 20.0,
              ),
              SizedBox(width: 7.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
          Text(widget.post.content, style: TextStyle(fontSize: 15.0)),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.thumbsUp,
                      size: 15.0, color: Colors.blue),
                  Text('${widget.post.likes}'),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('${widget.post.comments} comments  •  '),
                  Text('${widget.post.shares} shares'),
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
                    print("Like!");
                    setState(() {
                      likedByMe = !likedByMe;
                    });
                    var likesInt = int.parse(widget.post.likes);
                    assert(likesInt is int);
                    if (likedByMe) {
                      likesInt += 1;
                      widget.post.likes = likesInt.toString();
                    } else {
                      likesInt -= 1;
                      widget.post.likes = likesInt.toString();
                    }
                  },
                  child: likedByMe
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
