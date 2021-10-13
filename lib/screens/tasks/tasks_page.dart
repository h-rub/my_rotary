import 'dart:convert';

import 'package:amplified_todo/utils/utils.dart';
import 'package:amplified_todo/widgets/alert_dialog.dart';
import 'package:amplified_todo/widgets/slidable_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

import 'package:get/get.dart';
import 'package:amplified_todo/theme.dart';

class TasksPage extends StatefulWidget {
  TasksPage({Key key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  String token;
  String url;
  List<dynamic> data;

  int _counter = 0;

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
    String url = "http://localhost:8000/api/v1/tasks/all";
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
      print("Status code ${res.statusCode}");
      print("Response JSON ${jsonResponse}");
      setState(() {
        data = jsonResponse;
      });
      print(data);
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
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: CustomRefreshIndicator(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: GestureDetector(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, position) {
                      return SlidableWidget(
                        child: Container(
                          margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: 150,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
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
                                  child: GestureDetector(
                                    onTap: () {
                                      print('testing');
                                      print(data[position]);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 9.0),
                                        Text(
                                          "${data[position]['title']}",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(shortenDescription(
                                            "${data[position]['description']}",
                                            descLimit: 100)),
                                        SizedBox(height: 7.0),
                                        Text(
                                          "Asignado a:",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 7.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 30.0,
                                              width: 30.0,
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                                "${data[position]['user_asigned_to']}"),
                                            SizedBox(width: 100.0),
                                            Text(
                                              formatDate(
                                                  "${data[position]['due_date']}"),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
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
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/addTask');
        },
        tooltip: 'Add a task',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _appBar() {
    return AppBar(
        brightness: context.theme.brightness,
        title: Text(
          "Mis tareas",
          style: headingTextStyle,
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
        ),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=687&q=80"),
          ),
          SizedBox(
            width: 20,
          ),
        ]);
  }

  showAlertDialog(BuildContext context, int position, String taskTitle) {
    deleteTask() async {
      String url = "http://localhost:8000/api/v1/task/delete/${position}";
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
