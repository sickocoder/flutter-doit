import 'package:doit/models/task.dart';
import 'package:doit/pages/home/widgets/bottom-tabs.dart';
import 'package:doit/services/db/database.dart';
import 'package:doit/shared/widgets/button.dart';
import 'package:doit/shared/widgets/text.dart';
import 'package:doit/theme/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

// import 'widgets/reminder-selector.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
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
                            print('confirm $time');
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
                title: 'Nova Tarefa',
                onPressed: () {
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
