import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:my_rotary/providers/task_info.dart';
import 'package:my_rotary/providers/user_info.dart';
import 'package:my_rotary/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:my_rotary/theme.dart';
import 'package:my_rotary/widgets/button.dart';
import 'package:my_rotary/widgets/input_field.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:get/get.dart';
import 'package:my_rotary/theme.dart';

class DetailsPageTask extends StatefulWidget {
  @override
  _DetailsPageTaskState createState() => _DetailsPageTaskState();
}

class _DetailsPageTaskState extends State<DetailsPageTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  //String _startTime = DateFormat("hh:mm").format(DateTime.now());
  //_startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();

  String _endTime = "9:30 AM";
  int _selectedColor = 0;

  String _selectedRemind = "Hever Rubio";
  List<String> remindList = [
    'Hever Rubio',
    'Jorge Estrada',
    'Heriberto León',
    'Juan Arias',
  ];

  String _selectedRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Limpia el controlador cuando el widget se elimine del árbol de widgets
    // Esto también elimina el listener _printLatestValue
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
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
        Navigator.of(context).popAndPushNamed('/tasks');

        if (jsonResponse != Null) {}
      } else if (res.statusCode == 401) {
        print("Error de autenticación");
      } else if (res.statusCode == 500) {
        print("Error del servidor");
      }
    }

    // set up the button
    Widget deleteButton = TextButton(
      child: Text("Eliminar", style: GoogleFonts.poppins(color: Colors.red)),
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

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);

    final taskInfo = Provider.of<TaskInfo>(context);
    //Below shows the time like Sep 15, 2021
    //print(new DateFormat.yMMMd().format(new DateTime.now()));
    print(" starttime " + _startTime);
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, now.minute, now.second);
    final format = DateFormat.jm();
    print(format.format(dt));
    print("add Task date: " + DateFormat("yyyy-MM-dd").format(_selectedDate));
    //_startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(userInfo, taskInfo),
      bottomNavigationBar: SizedBox(
        height: 80.0,
        child: Material(
          color: Theme.of(context).bottomAppBarColor,
          shadowColor: Colors.black,
          elevation: 32.0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    print("Eliminando tarea");
                    showAlertDialog(context, taskInfo.id, taskInfo.title);
                    //Navigator.pop(context);
                  },
                  child: Text(
                    'Eliminar',
                    style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print("Marcando la tarea como completado");
                    showCompletedTask(context, taskInfo.id, taskInfo.title,
                        taskInfo.isCompleted);
                    //Navigator.pop(context);
                  },
                  child: taskInfo.isCompleted
                      ? Text(
                          'Marcar como no completado',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          'Marcar como completado',
                          style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  taskInfo.isCompleted
                      ? Text(
                          "Tarea completada",
                          style: GoogleFonts.poppins(
                              color: Colors.green, fontWeight: FontWeight.w600),
                        )
                      : Text("Tarea aún no completada",
                          style: GoogleFonts.poppins(
                              color: Colors.indigo,
                              fontWeight: FontWeight.w600)),
                ],
              ),
              InputField(
                  title: "Título",
                  hint: taskInfo.title,
                  controller: _titleController,
                  isDescription: false,
                  isReadOnly: true),
              InputField(
                  title: "Descripción",
                  hint: taskInfo.description,
                  isDescription: true,
                  controller: _descController,
                  isReadOnly: true),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      isReadOnly: true,
                      title: "Fecha límite",
                      isDescription: false,
                      hint: DateFormat("dd/MM/yyyy").format(
                          DateFormat("yyyy-MM-dd").parse(taskInfo.dueDate)),
                      widget: IconButton(
                        icon: (Icon(
                          FlutterIcons.calendar_ant,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          //_showDatePicker(context);
                          _getDateFromUser();
                        },
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // Expanded(
                  //   child: InputField(
                  //     isReadOnly: true,
                  //     title: "Hora de fin",
                  //     isDescription: false,
                  //     hint: _startTime,
                  //     widget: IconButton(
                  //       icon: (Icon(
                  //         FlutterIcons.clock_faw5,
                  //         color: Colors.grey,
                  //       )),
                  //       onPressed: () {
                  //         _getTimeFromUser(isStartTime: true);
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              InputField(
                isReadOnly: true,
                title: "Asignado a",
                isDescription: false,
                hint: taskInfo.full_name_assigned_to,
                widget: Row(
                  children: [
                    DropdownButton<String>(
                        //value: _selectedRemind.toString(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        style: subTitleTextStle,
                        underline: Container(height: 0),
                        onChanged: (String newValue) {
                          setState(() {
                            _selectedRemind = newValue;
                          });
                        },
                        items: remindList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(value.toString()),
                          );
                        }).toList()),
                    SizedBox(width: 6),
                  ],
                ),
              ),
              SizedBox(
                height: 18.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // _colorChips(),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateInputs() {
    if (_titleController.text.isNotEmpty && _descController.text.isNotEmpty) {
      _addTaskToDB(_titleController.text, _descController.text, _selectedDate,
          _startTime);
      //Get.back();
      Navigator.popAndPushNamed(context, '/tasks');
    } else if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      print("############ SOMETHING BAD HAPPENED #################");
    }
  }

  _addTaskToDB(
      titleContent, descriptionContent, selectedDate, _startTime) async {
    print("Añadiendo tarea");
    print("Hora que se agregó: ${_startTime}");

    var datetime_deadline = DateTime.parse(selectedDate.toString());
    var format_date =
        "${datetime_deadline.year}-${datetime_deadline.month}-${datetime_deadline.day}";

    var jsonResponse;

    final res = await http.post(
      Uri.parse('http://rotary.syncronik.com/api/v1/task/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': titleContent,
        'description': descriptionContent,
        'deadline': format_date,
        'due_time': _startTime
      }),
    );
    if (res.statusCode == 200) {
      String source = Utf8Decoder().convert(res.bodyBytes);
      jsonResponse = json.decode(source);
      print("Status code ${res.statusCode}");
      print("Response JSON ${jsonResponse}");
    }
  }

  _colorChips() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Color",
        style: titleTextStle,
      ),
      SizedBox(
        height: 8,
      ),
      Wrap(
        children: List<Widget>.generate(
          3,
          (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: index == _selectedColor
                      ? Center(
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : Container(),
                ),
              ),
            );
          },
        ).toList(),
      ),
    ]);
  }

  _appBar(userInfo, taskInfo) {
    return AppBar(
        brightness: context.theme.brightness,
        title: Text(
          "Tarea #${taskInfo.id}",
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
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/editTask');
              },
              icon: Icon(Icons.edit, color: colorIcon),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ]);
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  _getTimeFromUser({@required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    print(_pickedTime.format(context));
    String _formatedTime = _pickedTime.format(context);
    print(_formatedTime);
    if (_pickedTime == null)
      print("time canceld");
    else if (isStartTime)
      setState(() {
        _startTime = _formatedTime;
      });
    else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
      //_compareTime();
    }
  }

  _showTimePicker() async {
    return showTimePicker(
      initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0])),
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
    );
  }

  _getDateFromUser() async {
    final DateTime _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    }
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
          //isLoading = true;
        });
        //loadTasks();
        if (jsonResponse != Null) {}
      } else if (res.statusCode == 401) {
        print("Error de autenticación");
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
          //isLoading = true;
        });
        //loadTasks();
        if (jsonResponse != Null) {}
      } else if (res.statusCode == 401) {
        print("Error de autenticación");
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
              "¿Estás seguro que deseas marcar como no completada la tarea '${taskTitle}'?")
          : Text(
              "¿Estás seguro que deseas marcar como completada la tarea '${taskTitle}'?"),
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
}
