import 'dart:convert';

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

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
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
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
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
      appBar: _appBar(userInfo),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              InputField(
                title: "Título",
                hint: "Ingresa un titulo",
                controller: _titleController,
                isDescription: false,
              ),
              InputField(
                  title: "Descripción",
                  hint: "Ingresa una descripción",
                  isDescription: true,
                  controller: _descController),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Fecha límite",
                      isDescription: false,
                      hint: DateFormat("dd/MM/yyyy").format(_selectedDate),
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
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InputField(
                      title: "Hora de fin",
                      isDescription: false,
                      hint: _startTime,
                      widget: IconButton(
                        icon: (Icon(
                          FlutterIcons.clock_faw5,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Asignado a",
                isDescription: false,
                hint: "Hever Rubio",
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
                  MyButton(
                    label: "Crear tarea",
                    onTap: () {
                      _validateInputs();
                    },
                  ),
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
    // await _taskController.addTask(
    //   task: Task(
    //     note: _descController.text,
    //     title: _titleController.text,
    //     date: DateFormat.yMd().format(_selectedDate),
    //     startTime: _startTime,
    //     endTime: _endTime,
    //     remind: _selectedRemind,
    //     repeat: _selectedRepeat,
    //     color: _selectedColor,
    //     isCompleted: 0,
    //   ),
    // );
    print("Añadiendo tarea");
    print("Hora que se agregó: ${_startTime}");

    var datetime_deadline = DateTime.parse(selectedDate.toString());
    var format_date =
        "${datetime_deadline.year}-${datetime_deadline.month}-${datetime_deadline.day}";

    var jsonResponse;

    final res = await http.post(
      Uri.parse(
          'https://morning-retreat-88403.herokuapp.com/api/v1/task/create'),
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

  _appBar(userInfo) {
    return AppBar(
        brightness: context.theme.brightness,
        title: Text(
          "Añadir tarea",
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
          CircleAvatar(
            radius: 22,
            backgroundImage: userInfo.urlPicture != ""
                ? NetworkImage(
                    "https://morning-retreat-88403.herokuapp.com/media/${userInfo.urlPicture}")
                : AssetImage("assets/default-profile.png"),
          ),
          SizedBox(
            width: 20,
          ),
        ]);
  }

  // _compareTime() {
  //   print("compare time");
  //   print(_startTime);
  //   print(_endTime);

  //   var _start = double.parsestartTime);
  //   var _end = toDouble(_endTime);

  //   print(_start);
  //   print(_end);

  //   if (_start > _end) {
  //     Get.snackbar(
  //       "Invalid!",
  //       "Time duration must be positive.",
  //       snackPosition: SnackPosition.BOTTOM,
  //       overlayColor: context.theme.backgroundColor,
  //     );
  //   }
  // }

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
}
