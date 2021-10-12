import 'dart:convert';

import 'package:amplified_todo/utils/utils.dart';
import 'package:amplified_todo/widgets/alert_dialog.dart';
import 'package:amplified_todo/widgets/slidable_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tareas"),
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
              onPressed: () {
                // TODO: Implementar el filtrado de tareas
                print("HAZ SELECCIONADO EL FILTRO!!!");
              })
        ],
      ),
      body: Container(
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
                              color: Colors.green,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        Text("Nombre"),
                                        SizedBox(width: 130.0),
                                        Text(
                                          "Vence:",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "22/10/2021",
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
                    onDismissed: (action) =>
                        dismissSlidableItem(context, position, action),
                  );
                }),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {},
        tooltip: 'Add a task',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  showAlertDialog(BuildContext context, int position) {
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
      content: Text("¿Estás seguro que deseas eliminar la tarea?"),
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

  void dismissSlidableItem(
      BuildContext context, int position, SlidableAction action) {
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
        showAlertDialog(context, position);
        break;
    }
  }
}
