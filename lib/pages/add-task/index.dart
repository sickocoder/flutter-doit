import 'package:doit/models/task.dart';
import 'package:doit/pages/home/home.types.dart';
import 'package:doit/pages/home/widgets/bottom-tabs.dart';
import 'package:doit/services/db/database.dart';
import 'package:doit/shared/widgets/button.dart';
import 'package:doit/shared/widgets/text.dart';
import 'package:doit/theme/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

// import 'widgets/reminder-selector.dart';

class AddTask extends StatefulWidget {
  final bool isEdit;
  final TaskListItem? taskItemData;
  final Task? realTaskData;
  final Function()? updateTheUI;

  const AddTask({
    Key? key,
    this.isEdit = false,
    this.taskItemData,
    this.realTaskData,
    this.updateTheUI,
  }) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  List<String> todoTypes = ["Need Tos", "Want Tos", "Might Tos"];
  List<String> data = [
    'Before 5min',
    'Before 15min',
    'Before 30min',
    'An hour before',
  ];
  List<int> reminderTimes = [5, 15, 30, 60];
  int _selectedReminder = 0;
  int _selectedTodoType = 0;

  final titleTextController = TextEditingController();
  final timeTextController = TextEditingController();
  DateTime selectedTime = new DateTime.now();

  void createTask(BuildContext context) async {
    Task task = Task(
      title: this.titleTextController.text,
      time: this.selectedTime,
      timeString: this.timeTextController.text,
      reminderBefore: this.reminderTimes[this._selectedReminder],
      type: this.todoTypes[this._selectedTodoType],
    );

    var database = await DoItDatabase().openDoItDatabase();
    await database.insertTask(task);

    Navigator.of(context).pop();
  }

  void updateTask(BuildContext context) async {
    Task task = Task(
      title: this.titleTextController.text,
      time: this.selectedTime,
      timeString: this.timeTextController.text,
      reminderBefore: this.reminderTimes[this._selectedReminder],
      type: this.todoTypes[this._selectedTodoType],
    );

    var realTaskData = {
      ...{'id': this.widget.realTaskData!.id},
      ...this.widget.realTaskData!.toMap(),
      ...task.toMap(),
    };

    var database = await DoItDatabase().openDoItDatabase();
    await database.updateTask(Task.fromJson(realTaskData));

    this.widget.updateTheUI!();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    if (this.widget.taskItemData != null && this.widget.realTaskData != null) {
      // title
      titleTextController.text = this.widget.taskItemData!.title;

      // date
      var date = DateTime.parse(this.widget.realTaskData!.time.toString());
      String hour = date.hour < 10 ? "0${date.hour}" : date.hour.toString();
      String minutes =
          date.minute < 10 ? "0${date.minute}" : date.minute.toString();

      this.timeTextController.text = "Hoje às $hour:$minutes";

      // todo types
      // Todo Type
      int index = todoTypes
          .indexWhere((element) => element == this.widget.taskItemData!.type);
      setState(() {
        _selectedTodoType = index;
        this.selectedTime = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: this.widget.isEdit ? Colors.transparent : Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: this.widget.isEdit ? Colors.transparent : Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: this.titleTextController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintStyle: AppTextStyles.inputText,
                        hintText: 'Título',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32.0, left: 16.0, right: 16.0),
                    child: TextField(
                      onTap: () {
                        DatePicker.showTimePicker(
                          context,
                          showTitleActions: true,
                          showSecondsColumn: false,
                          onConfirm: (time) {
                            String hour = time.hour < 10
                                ? "0${time.hour}"
                                : time.hour.toString();
                            String minutes = time.minute < 10
                                ? "0${time.minute}"
                                : time.minute.toString();

                            this.timeTextController.text =
                                "Hoje às $hour:$minutes";

                            setState(() {
                              selectedTime = time;
                            });
                          },
                          currentTime: DateTime.now(),
                          locale: LocaleType.pt,
                        );
                      },
                      readOnly: true,
                      style: TextStyle(color: Colors.white),
                      controller: this.timeTextController,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintStyle: AppTextStyles.inputText,
                        hintText: 'Horário',
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       top: 32.0, left: 16.0, right: 16.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       ScalableText('Reminder',
                  //           style: AppTextStyles.formTitleText),
                  //       Padding(
                  //         padding: const EdgeInsets.only(top: 8.0),
                  //         child: ReminderSelector(
                  //           data: data,
                  //           selectedIndex: _selectedReminder,
                  //           onItemClicked: (index) {
                  //             setState(() {
                  //               this._selectedReminder = index;
                  //             });
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ScalableText(
                            'Tipo',
                            style: AppTextStyles.formTitleText,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: BottomTabs(
                            defaultSelected: this._selectedTodoType,
                            tabsData: [
                              "Preciso Fazer",
                              "Quero Fazer",
                              "Posso Fazer",
                            ],
                            onSelected: (index) {
                              setState(() {
                                this._selectedTodoType = index;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(color: Color(0xFF828282)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DoItButton(
                title: this.widget.isEdit ? 'Atualizar Tarefa' : 'Nova Tarefa',
                onPressed: () {
                  if (this.widget.isEdit)
                    updateTask(context);
                  else
                    createTask(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleTextController.dispose();
    timeTextController.dispose();
    super.dispose();
  }
}
