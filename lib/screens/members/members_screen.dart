import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_rotary/providers/member_info.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'package:get/get.dart';
import 'package:my_rotary/theme.dart';
import 'package:http/http.dart' as http;

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({Key key}) : super(key: key);

  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  List userList = List<User>();
  // List<User> _users = [
  //   User(
  //     'Elliana Palacios',
  //     '@elliana',
  //     'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
  //   ),
  //   User(
  //     'Kayley Dwyer',
  //     '@kayley',
  //     'https://images.unsplash.com/photo-1503467913725-8484b65b0715?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=cf7f82093012c4789841f570933f88e3',
  //   ),
  //   User(
  //     'Kathleen Mcdonough',
  //     '@kathleen',
  //     'https://images.unsplash.com/photo-1507081323647-4d250478b919?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=b717a6d0469694bbe6400e6bfe45a1da',
  //   ),
  //   User(
  //     'Kathleen Dyer',
  //     '@kathleen',
  //     'https://images.unsplash.com/photo-1502980426475-b83966705988?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=ddcb7ec744fc63472f2d9e19362aa387',
  //   ),
  //   User(
  //     'Mikayla Marquez',
  //     '@mikayla',
  //     'https://images.unsplash.com/photo-1541710430735-5fca14c95b00?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ',
  //   ),
  //   User(
  //     'Kiersten Lange',
  //     '@kiersten',
  //     'https://images.unsplash.com/photo-1542534759-05f6c34a9e63?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ',
  //   ),
  //   User(
  //     'Carys Metz',
  //     '@metz',
  //     'https://images.unsplash.com/photo-1516239482977-b550ba7253f2?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ',
  //   ),
  //   User(
  //     'Ignacio Schmidt',
  //     '@schmidt',
  //     'https://images.unsplash.com/photo-1542973748-658653fb3d12?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ',
  //   ),
  //   User(
  //     'Clyde Lucas',
  //     '@clyde',
  //     'https://images.unsplash.com/photo-1569443693539-175ea9f007e8?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ',
  //   ),
  //   User(
  //     'Mikayla Marquez',
  //     '@mikayla',
  //     'https://images.unsplash.com/photo-1541710430735-5fca14c95b00?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ',
  //   )
  // ];

  List<User> _foundedUsers = [];

  bool isLoading = true;

  Future<void> getDataApi() async {
    List userListTemp = List<User>();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json; charset=utf-8',
    };

    var response = await http.get(
        "http://rotary.syncronik.com/api/v1/members/all",
        headers: requestHeaders);

    if (response.statusCode == 200) {
      String source = Utf8Decoder().convert(response.bodyBytes);
      var dataUsers = json.decode(source);
      print(dataUsers);

      for (var x in dataUsers) {
        //DateTime tempDate = new DateFormat("yyyy-MM").parse(x['id']);
        User fileData = User(
          x['pk'],
          x['first_name'],
          x['last_name'],
          x['full_name'],
          x['user_name'],
          x['email'],
          x['company'],
          x['phone'],
          x['address'],
          x['bio'],
          x['picture'],
        );
        userListTemp.add(fileData);
      }
      setState(() {
        //userListTemp.sort((b, a) => a.id.compareTo(b.id));
        userList = userListTemp;
        _foundedUsers = userList;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataApi();

    setState(() {
      _foundedUsers = userList;
    });
  }

  onSearch(String search) {
    setState(() {
      _foundedUsers =
          userList.where((user) => user.userName.contains(search)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final memberInfo = Provider.of<MemberInfo>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark,
        backgroundColor: primaryClr,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, size: 24, color: Colors.white),
        ),
        title: Container(
          height: 38,
          child: TextField(
            style: TextStyle(color: Colors.white),
            onChanged: (value) => onSearch(value),
            decoration: InputDecoration(
                filled: true,
                fillColor: primaryClr,
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none),
                hintStyle: TextStyle(fontSize: 14, color: Colors.white),
                hintText: "Buscar miembros"),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: CustomRefreshIndicator(
            child: Container(
              color: context.theme.backgroundColor,
              child: _foundedUsers.length > 0
                  ? ListView.builder(
                      itemCount: _foundedUsers.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              memberInfo.uid = _foundedUsers[index].id;
                              memberInfo.firstName =
                                  _foundedUsers[index].firstName;
                              memberInfo.lastName =
                                  _foundedUsers[index].lastName;
                              memberInfo.fullName =
                                  _foundedUsers[index].fullName;
                              memberInfo.userName =
                                  _foundedUsers[index].userName;
                              memberInfo.address = _foundedUsers[index].address;
                              memberInfo.company = _foundedUsers[index].company;
                              memberInfo.email = _foundedUsers[index].email;
                              memberInfo.phone = _foundedUsers[index].phone;
                              memberInfo.biography =
                                  _foundedUsers[index].biography;
                              memberInfo.urlPicture =
                                  _foundedUsers[index].image;
                              Navigator.of(context)
                                  .pushNamed('/member-profile');
                            },
                            child: userComponent(user: _foundedUsers[index]));
                      })
                  : Center(
                      child: Text(
                      "No users found",
                      style: TextStyle(color: Colors.white),
                    )),
            ),
            onRefresh: () {
              Future.delayed(const Duration(seconds: 2));
              setState(() {
                isLoading = true;
              });
              getDataApi();
            },
            builder: (
              BuildContext context,
              Widget child,
              IndicatorController controller,
            ) {
              return AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, _) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      if (!controller.isIdle)
                        Positioned(
                          top: 35.0 * controller.value,
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              value: !controller.isLoading
                                  ? controller.value.clamp(0.0, 1.0)
                                  : null,
                            ),
                          ),
                        ),
                      Transform.translate(
                        offset: Offset(0, 100.0 * controller.value),
                        child: child,
                      ),
                    ],
                  );
                },
              );
            }),
      ),
    );
  }

  userComponent({User user}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "http://rotary.syncronik.com/media/${user.image}"),
                  ),
                )),
            SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user.fullName,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
              SizedBox(
                height: 5,
              ),
              Text("@${user.userName}",
                  style: TextStyle(color: Colors.grey[500])),
            ])
          ]),
        ],
      ),
    );
  }
}
