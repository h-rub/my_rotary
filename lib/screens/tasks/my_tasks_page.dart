import 'dart:async';
import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:my_rotary/providers/task_info.dart';
import 'package:my_rotary/providers/user_info.dart';
import 'package:my_rotary/screens/tasks/tasks_page.dart';
import 'package:my_rotary/utils/utils.dart';
import 'package:my_rotary/widgets/alert_dialog.dart';
import 'package:my_rotary/widgets/slidable_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

import 'package:get/get.dart';
import 'package:my_rotary/theme.dart';

class MyTasksPage extends StatefulWidget {
  MyTasksPage({Key key}) : super(key: key);

  @override
  _MyTasksPageState createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {
  String token;
  String url;
  List<dynamic> data;
  List<dynamic> data_new;

  int _counter = 0;

  Timer myTimer;
  int counter = 0;
  bool isLoading = true;

  // Pull to refresh
  static const _indicatorSize = 150.0;

  /// Whether to render check mark instead of spinner
  bool _renderCompleteState = false;

  final Color primaryColor = Color.fromRGBO(23, 69, 143, 1);
  // Shared Preferennces
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  loadMyTasks() async {
    final SharedPreferences prefs = await _prefs;
    int user_id = await prefs.getInt("user_id");
    String token = await prefs.getString("token");
    String url = "http://rotary.syncronik.com/api/v1/tasks?user=${user_id}";
    print(url);
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
      print("Response JSON ${jsonResponse}");
      setState(() {
        isLoading = !isLoading;
        data = new List.from(jsonResponse.reversed);
      });
      //print(data);
      if (jsonResponse != Null) {}
    } else if (res.statusCode == 401) {
      print("Error de autenticaci??n");
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
    loadMyTasks();
  }

  @override
  void dispose() {
    myTimer.cancel();
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
                              isCompleted: data[position]['is_completed'],
                              child: GestureDetector(
                                onTap: () {
                                  print('testing');
                                  print(data[position]);
                                  taskInfo.title = data[position]['title'];
                                  taskInfo.description =
                                      data[position]['description'];
                                  taskInfo.id = data[position]['_id_task'];
                                  taskInfo.dueDate = data[position]['due_date'];
                                  taskInfo.full_name_assigned_to =
                                      data[position]['user_asigned_to']
                                          ['full_name'];
                                  taskInfo.isCompleted =
                                      data[position]['is_completed'];
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
                                              : Colors.indigo,
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
                                                style: GoogleFonts.poppins(
                                                    fontSize: 22.0,
                                                    color: primaryColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(height: 10.0),
                                              Text(
                                                shortenDescription(
                                                    "${data[position]['description']}",
                                                    descLimit: 70),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18),
                                              ),
                                              SizedBox(height: 12.0),
                                              Text(
                                                "Asignado a:",
                                                style: GoogleFonts.poppins(
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
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: 16)),
                                                  SizedBox(width: _separator),
                                                  Text(
                                                    formatDate(
                                                        "${data[position]['due_date']}"),
                                                    style: GoogleFonts.poppins(
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
                                  action,
                                  data[position]['is_completed']),
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
                  loadMyTasks();
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
                  icon: Icon(Icons.list),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 48.0),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.amber),
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
          "Mis tareas",
          style: headingTextStyle,
        ),
        elevation: 4,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/me');
            },
            child: CircleAvatar(
              radius: 22,
              backgroundImage: userInfo.urlPicture != ""
                  ? NetworkImage(
                      "http://rotary.syncronik.com/media/${userInfo.urlPicture}")
                  : AssetImage("assets/default-profile.png"),
            ),
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
        navigator.pushAndRemoveUntil<void>(
          MaterialPageRoute<void>(
              builder: (BuildContext context) => TasksPage()),
          ModalRoute.withName('/tasks'),
        );
        loadMyTasks();
        if (jsonResponse != Null) {}
      } else if (res.statusCode == 401) {
        print("Error de autenticaci??n");
      } else if (res.statusCode == 500) {
        print("Error del servidor");
      }
    }

    // set up the button
    Widget deleteButton = TextButton(
      child: Text("Eliminar", style: GoogleFonts.poppins(color: Colors.red)),
      onPressed: () {
        setState(() {
          isLoading = true;
        });
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
          Text("??Est??s seguro que deseas eliminar la tarea '${taskTitle}'?"),
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

  showCompletedTask(
      BuildContext context, int position, String taskTitle, bool isComplete) {
    print(isComplete);

    notCompletedTask() async {
      print("NO COMPLETANDO");
      String url =
          "http://rotary.syncronik.com/api/v1/task/notcomplete/${position}";
      var jsonResponse;
      Map notbody = {"is_completed": "False"};
      var res = await http.post(url, body: notbody);

      if (res.statusCode == 200) {
        String source = Utf8Decoder().convert(res.bodyBytes);
        jsonResponse = json.decode(source);
        print("Status code ${res.statusCode}");
        print("Response JSON ${jsonResponse}");
        Navigator.of(context).pop();
        setState(() {
          isLoading = true;
        });
        loadMyTasks();
        if (jsonResponse != Null) {}
      } else if (res.statusCode == 401) {
        print("Error de autenticaci??n");
      } else if (res.statusCode == 500) {
        print("Error del servidor");
      }
    }

    completedTask() async {
      String url =
          "http://rotary.syncronik.com/api/v1/task/complete/${position}";
      var jsonResponse;
      Map body = {"is_completed": "True"};
      var res = await http.post(url, body: body);

      if (res.statusCode == 200) {
        String source = Utf8Decoder().convert(res.bodyBytes);
        jsonResponse = json.decode(source);
        print("Status code ${res.statusCode}");
        print("Response JSON ${jsonResponse}");
        Navigator.of(context).pop();
        setState(() {
          isLoading = true;
        });
        loadMyTasks();
        if (jsonResponse != Null) {}
      } else if (res.statusCode == 401) {
        print("Error de autenticaci??n");
      } else if (res.statusCode == 500) {
        print("Error del servidor");
      }
    }

    // set up the button
    Widget completedButton = TextButton(
      child: Text("Completar", style: GoogleFonts.poppins(color: Colors.green)),
      onPressed: () {
        completedTask();
      },
    );
    Widget notCompletedButton = TextButton(
      child: Text("Confirmar", style: GoogleFonts.poppins(color: Colors.red)),
      onPressed: () {
        notCompletedTask();
      },
    );

    Widget cancel = TextButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog completedAlert = AlertDialog(
      title: isComplete
          ? Text("Marcar como no completada")
          : Text("Completar tarea"),
      content: isComplete
          ? Text(
              "??Est??s seguro que deseas marcar como no completada la tarea '${taskTitle}'?")
          : Text(
              "??Est??s seguro que deseas marcar como completada la tarea '${taskTitle}'?"),
      actions: [
        cancel,
        isComplete ? notCompletedButton : completedButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return completedAlert;
      },
    );
  }

  void dismissSlidableItem(BuildContext context, int position, String taskTitle,
      SlidableAction action, bool isComplete) {
    setState(() {});

    switch (action) {
      case SlidableAction.archive:
        Utils.showSnackBar(context, 'Chat has been archived');
        break;
      case SlidableAction.done:
        //Utils.showSnackBar(context, 'Tarea marcada como completada');
        showCompletedTask(context, position, taskTitle, isComplete);
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
