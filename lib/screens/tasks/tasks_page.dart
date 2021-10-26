import 'dart:async';
import 'dart:convert';

import 'package:my_rotary/providers/task_info.dart';
import 'package:my_rotary/providers/user_info.dart';
import 'package:my_rotary/screens/home/home_page.dart';
import 'package:my_rotary/utils/utils.dart';
import 'package:my_rotary/widgets/alert_dialog.dart';
import 'package:my_rotary/widgets/slidable_widget.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

import 'package:get/get.dart';
import 'package:my_rotary/theme.dart';

class TasksPage extends StatefulWidget {
  TasksPage({Key key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String token;
  String url;
  List<dynamic> data;
  List<dynamic> data_new;

  int _counter = 0;

  Timer timer;
  int counter = 0;

  bool isLoading = true;

  // Pull to refresh
  static const _indicatorSize = 150.0;

  /// Whether to render check mark instead of spinner
  bool _renderCompleteState = false;

  final Color primaryColor = Color.fromRGBO(23, 69, 143, 1);
  // Shared Preferennces
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  loadTasks() async {
    final SharedPreferences prefs = await _prefs;
    String token = await prefs.getString("token");
    String url = "http://rotary.syncronik.com/api/v1/tasks/all";
    var jsonResponse;
    var res = await http.get(
      url,
      headers: {
        'Authorization': "Token ${token}",
        'Content-Type': 'application/json; charset=utf-8'
      },
    );

    if (res.statusCode == 200) {
      String source = Utf8Decoder().convert(res.bodyBytes);
      jsonResponse = json.decode(source);
      // print("Status code ${res.statusCode}");
      // print("Response JSON ${jsonResponse}");
      setState(() {
        isLoading = !isLoading;
        data = new List.from(jsonResponse.reversed);
      });
      //print(data);
      if (jsonResponse != Null) {}
    } else if (res.statusCode == 401) {
      print("Error de autenticación");
    } else if (res.statusCode == 500) {
      print("Error del servidor");
    }
  }

  loadMyTasks(int myUserID) async {
    final SharedPreferences prefs = await _prefs;
    String token = await prefs.getString("token");
    String url = "http://rotary.syncronik.com/api/v1/tasks?user=${myUserID}";
    var jsonResponse;
    var res = await http.get(
      url,
      headers: {
        'Authorization': "Token ${token}",
        'Content-Type': 'application/json; charset=utf-8'
      },
    );

    if (res.statusCode == 200) {
      String source = Utf8Decoder().convert(res.bodyBytes);
      jsonResponse = json.decode(source);
      // print("Status code ${res.statusCode}");
      // print("Response JSON ${jsonResponse}");
      setState(() {
        isLoading = !isLoading;
        data = new List.from(jsonResponse.reversed);
      });
      //print(data);
      if (jsonResponse != Null) {}
    } else if (res.statusCode == 401) {
      print("Error de autenticación");
    } else if (res.statusCode == 500) {
      print("Error del servidor");
    }
  }

  void incrementCounter() {
    setState(() {
      _counter = _counter + 1;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //* Limits given string, adds '..' if necessary
  static String shortenDescription(String descRaw,
      {int descLimit = 10, bool addDots = true}) {
    //* Limiting val should not be gt input length (.substring range issue)
    final max = descLimit < descRaw.length ? descLimit : descRaw.length;
    //* Get short name
    final desc = descRaw.substring(0, max);
    //* Return with '..' if input string was sliced
    if (addDots && descRaw.length > max) return desc + '...';
    return desc;
  }

  formatDate(date) {
    if (date != 'null') {
      DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(date);
      String finalDate = new DateFormat("dd/MM/yyyy").format(tempDate);
      String stringDate = finalDate.toString();
      return "Vence: ${stringDate.substring(0, 10)}";
    } else {
      return " Sin fecha limite";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    final taskInfo = Provider.of<TaskInfo>(context);
    double _width = MediaQuery.of(context).size.width - 40;
    double _height = MediaQuery.of(context).size.width;
    double _separator = _width / 7.5;
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: _appBar(userInfo),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : CustomRefreshIndicator(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: GestureDetector(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, position) {
                            return SlidableWidget(
                              child: GestureDetector(
                                onTap: () {
                                  print('testing');
                                  print(data[position]);
                                  taskInfo.title = data[position]['title'];
                                  taskInfo.id = data[position]['_id_task'];
                                  Navigator.of(context).pushNamed('/detail');
                                },
                                child: Container(
                                  margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  height: _height / 2,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Container(
                                          color: data[position]['is_completed']
                                              ? Colors.green
                                              : Colors.yellow,
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${data[position]['title']}",
                                                style: TextStyle(
                                                    fontSize: 22.0,
                                                    color: primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 10.0),
                                              Text(
                                                shortenDescription(
                                                    "${data[position]['description']}",
                                                    descLimit: 70),
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(height: 12.0),
                                              Text(
                                                "Asignado a:",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(height: 7.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: CircleAvatar(
                                                      radius: 22,
                                                      backgroundImage: NetworkImage(
                                                          "http://rotary.syncronik.com/media/${data[position]['user_asigned_to']['picture']}"),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Text(
                                                      "${data[position]['user_asigned_to']['full_name']}",
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                  SizedBox(width: _separator),
                                                  Text(
                                                    formatDate(
                                                        "${data[position]['due_date']}"),
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              onDismissed: (action) => dismissSlidableItem(
                                  context,
                                  data[position]['_id_task'],
                                  data[position]['title'],
                                  action),
                            );
                          }),
                    ),
                  ),
                ),
                onRefresh: () {
                  Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    isLoading = true;
                  });
                  loadTasks();
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
        bottomNavigationBar: BottomAppBar(
          color: context.theme.backgroundColor,
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.list, color: Colors.amber),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 48.0),
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/myTasks');
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            Navigator.of(context).pushNamed('/addTask');
          },
          tooltip: 'Add a task',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked);
  }

  _appBar(userInfo) {
    return AppBar(
        brightness: context.theme.brightness,
        title: Text(
          "Tareas del club",
          style: headingTextStyle,
        ),
        elevation: 4,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            navigator.pushAndRemoveUntil<void>(
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => HomePage()),
              ModalRoute.withName('/'),
            );
          },
          child: Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
        ),
        actions: [
          CircleAvatar(
            radius: 22,
            backgroundImage: userInfo.urlPicture != ""
                ? NetworkImage(
                    "http://rotary.syncronik.com/media/${userInfo.urlPicture}")
                : AssetImage("assets/default-profile.png"),
          ),
          SizedBox(
            width: 20,
          ),
        ]);
  }

  showAlertDialog(BuildContext context, int position, String taskTitle) {
    deleteTask() async {
      String url = "http://rotary.syncronik.com/api/v1/task/delete/${position}";
      var jsonResponse;
      var res = await http.get(
        url,
      );

      if (res.statusCode == 200) {
        String source = Utf8Decoder().convert(res.bodyBytes);
        jsonResponse = json.decode(source);
        print("Status code ${res.statusCode}");
        print("Response JSON ${jsonResponse}");
        Navigator.of(context).pop();
        setState(() {
          isLoading = true;
        });
        loadTasks();
        if (jsonResponse != Null) {}
      } else if (res.statusCode == 401) {
        print("Error de autenticación");
      } else if (res.statusCode == 500) {
        print("Error del servidor");
      }
    }

    // set up the button
    Widget deleteButton = TextButton(
      child: Text("Eliminar", style: TextStyle(color: Colors.red)),
      onPressed: () {
        deleteTask();
      },
    );

    Widget cancel = TextButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Eliminar tarea"),
      content:
          Text("¿Estás seguro que deseas eliminar la tarea '${taskTitle}'?"),
      actions: [
        cancel,
        deleteButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void dismissSlidableItem(BuildContext context, int position, String taskTitle,
      SlidableAction action) {
    setState(() {});

    switch (action) {
      case SlidableAction.archive:
        Utils.showSnackBar(context, 'Chat has been archived');
        break;
      case SlidableAction.done:
        Utils.showSnackBar(context, 'Tarea marcada como completada');
        break;
      case SlidableAction.more:
        Utils.showSnackBar(context, 'Selected more');
        break;
      case SlidableAction.delete:
        showAlertDialog(context, position, taskTitle);
        break;
    }
  }
}
