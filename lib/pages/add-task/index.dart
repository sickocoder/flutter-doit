import 'dart:io';
import 'dart:math' as math;

import 'package:alert/alert.dart';
import 'package:doit/models/task.dart';
import 'package:doit/pages/home/home.types.dart';
import 'package:doit/pages/home/widgets/bottom-tabs.dart';
import 'package:doit/services/db/database.dart';
import 'package:doit/services/notification/notification-service.dart';
import 'package:doit/shared/widgets/button.dart';
import 'package:doit/shared/widgets/text.dart';
import 'package:doit/theme/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

import 'widgets/reminder-selector.dart';

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

  void createTask(BuildContext context, NotificationService model) async {
    int firstNotificationId = math.Random().nextInt(2000);
    int lastNotificationId = math.Random().nextInt(2000);

    Task task = Task(
      title: this.titleTextController.text,
      time: this.selectedTime,
      timeString: this.timeTextController.text,
      reminderBefore: this.reminderTimes[this._selectedReminder],
      type: this.todoTypes[this._selectedTodoType],
      notificationIds: [firstNotificationId, lastNotificationId],
    );

    try {
      await model.scheduleNotification(
        zonedId: math.Random().nextInt(1000),
        id: "task-reminder-pre-${this.titleTextController.text}",
        title: "Uma tarefa se avista",
        body:
            "Faltam ${this.reminderTimes[this._selectedReminder]} minutos para começar a executar a tarefa: ${this.titleTextController.text}",
        scheduledTime: this.selectedTime.subtract(
            Duration(minutes: this.reminderTimes[this._selectedReminder])),
      );

      await model.scheduleNotification(
        zonedId: math.Random().nextInt(1000),
        id: "task-reminder-ontime-${this.titleTextController.text}",
        title: "Hora de começar a tarefa",
        body:
            "Está na hora de executar a tarefa: ${this.titleTextController.text}",
        scheduledTime: this.selectedTime,
      );

      var database = await DoItDatabase().openDoItDatabase();
      await database.insertTask(task);
      Navigator.of(context).pop();
    } catch (error) {
      Alert(message: 'Ocorreu um erro ao criar a tarefa').show();
    }
  }

  void updateTask(BuildContext context) async {
    Task task = Task(
      title: this.titleTextController.text,
      time: this.selectedTime,
      timeString: this.timeTextController.text,
      reminderBefore: this.reminderTimes[this._selectedReminder],
      type: this.todoTypes[this._selectedTodoType],
      notificationIds: this.widget.realTaskData!.notificationIds,
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

  void deleteTask(BuildContext context, NotificationService model) async {
    try {
      var database = await DoItDatabase().openDoItDatabase();
      await database.deleteTask(this.widget.taskItemData!.id);

      this.widget.realTaskData!.notificationIds.forEach((notificationId) async {
        await model.cancelNotification(notificationId);
      });
    } catch (error) {
      print(error);
      Alert(message: 'Ocorreu um erro ao apagar a tarefa').show();
    }

    this.widget.updateTheUI!();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    Provider.of<NotificationService>(context, listen: false).initialize();

    if (Platform.isIOS) {
      Provider.of<NotificationService>(context, listen: false)
          .requestIOSPermissions();
    }

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

    super.initState();
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
                          currentTime: DateTime.now().add(
                            Duration(minutes: 10),
                          ),
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
                  if (!this.widget.isEdit)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32.0, left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ScalableText('Reminder',
                              style: AppTextStyles.formTitleText),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ReminderSelector(
                              data: data,
                              selectedIndex: _selectedReminder,
                              onItemClicked: (index) {
                                setState(() {
                                  this._selectedReminder = index;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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
                  if (!this.widget.isEdit)
                    Opacity(
                      opacity: 0.4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 32),
                        child: ScalableText(
                            'Att: Todas as tarefas serão criadas para hoje e consequentemente desaparecerão no dia imediatamente a seguir.'),
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
              child: Consumer<NotificationService>(
                builder: (context, model, _) => DoItButton(
                  title:
                      this.widget.isEdit ? 'Atualizar Tarefa' : 'Nova Tarefa',
                  onPressed: () {
                    if (this.widget.isEdit)
                      updateTask(context);
                    else {
                      createTask(context, model);
                      // model.instantNofitication();

                    }
                  },
                ),
              ),
            ),
            if (this.widget.isEdit)
              Consumer<NotificationService>(
                builder: (context, model, _) => Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  child: DoItButton(
                    title: 'Apagar Tarefa',
                    type: DoItButtonType.Delete,
                    onPressed: () {
                      deleteTask(context, model);
                    },
                  ),
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
