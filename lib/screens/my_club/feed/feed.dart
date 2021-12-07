import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_rotary/providers/user_info.dart';
import 'package:my_rotary/screens/members/models/post.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/post_widget.dart';
import 'widgets/separator_widget.dart';
import 'widgets/write_something.dart';
import 'package:http/http.dart' as http;

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class Feed extends StatefulWidget {
  const Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  Timer _timer;
  List posts = List<Post>();
  // Shared Preferennces
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  loadPosts() async {
    final SharedPreferences prefs = await _prefs;
    int user_id = await prefs.getInt("user_id");
    String url =
        "http://rotary.syncronik.com/api/v1/myclub/posts?me=${user_id}";
    var jsonResponse;
    var res = await http.get(
      url,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    if (res.statusCode == 200) {
      String source = Utf8Decoder().convert(res.bodyBytes);
      jsonResponse = json.decode(source);
      // print("Status code ${res.statusCode}");
      // print("Response JSON ${jsonResponse}");
      setState(() {
        var listPosts = new List.from(jsonResponse.reversed);
        for (var x in listPosts) {
          Post posts_temp = Post(
              pid: x['pk'].toString(),
              profileImageUrl: x['profile_image'],
              time: x['time_ago'],
              content: x['content'],
              likes: x['likes_count'].toString(),
              isLikedByMe: x['is_liked_by_me'],
              comments: x['comments_count'].toString(),
              shares: '2',
              username: x['posted_by']);
          posts.add(posts_temp);
        }
      });
      print(posts);
      if (jsonResponse != Null) {}
    } else if (res.statusCode == 401) {
      print("Error de autenticación");
    } else if (res.statusCode == 500) {
      print("Error del servidor");
    }
  }

  loadAnotherPosts() async {
    final SharedPreferences prefs = await _prefs;
    int user_id = await prefs.getInt("user_id");
    print(user_id);
    String url =
        "http://rotary.syncronik.com/api/v1/myclub/posts?me=${user_id}";
    var jsonResponse;
    var res = await http.get(
      url,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    if (res.statusCode == 200) {
      String source = Utf8Decoder().convert(res.bodyBytes);
      jsonResponse = json.decode(source);
      // print("Status code ${res.statusCode}");
      // print("Response JSON ${jsonResponse}");
      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          var listPosts = new List.from(jsonResponse.reversed);
          posts.clear();
          for (var x in listPosts) {
            Post posts_temp = Post(
                pid: x['pk'].toString(),
                profileImageUrl: x['profile_image'],
                time: x['time_ago'],
                content: x['content'],
                likes: x['likes_count'].toString(),
                isLikedByMe: x['is_liked_by_me'],
                comments: x['comments_count'].toString(),
                shares: '2',
                username: x['posted_by']);

            posts.add(posts_temp);
          }
        });
        print(posts);
      }

      if (jsonResponse != Null) {}
    } else if (res.statusCode == 401) {
      print("Error de autenticación");
    } else if (res.statusCode == 500) {
      print("Error del servidor");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPosts();
    _timer =
        new Timer.periodic(Duration(seconds: 10), (_) => loadAnotherPosts());
  }

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
