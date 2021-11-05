import 'package:flutter/material.dart';
import 'package:my_rotary/screens/members/models/post.dart';

import 'widgets/post_widget.dart';
import 'widgets/separator_widget.dart';
import 'widgets/write_something.dart';

class Feed extends StatefulWidget {
  const Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          WriteSomethingWidget(),
          for (Post post in posts)
            Column(
              children: <Widget>[
                SeparatorWidget(),
                PostWidget(post: post),
              ],
            ),
          SeparatorWidget(),
        ],
      ),
    );
  }
}
