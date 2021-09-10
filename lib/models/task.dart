import 'package:doit/pages/home/home.types.dart';

class Task {
  int id;
  String title;
  String timeString;
  DateTime time;
  int reminderBefore;
  String type;
  bool done;
  List<int> notificationIds;

  Task({
    this.id = -1,
    required this.title,
    required this.timeString,
    required this.time,
    required this.reminderBefore,
    required this.type,
    required this.notificationIds,
    this.done = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'timeString': timeString,
      'time': time.toString(),
      'reminderBefore': reminderBefore,
      'type': type,
      'done': done ? 1 : 0,
      'notificationIds': this.notificationIds.join(" "),
    };
  }

  TaskListItem formated() {
    return TaskListItem(
      id: this.id,
      title: this.title,
      hour: "${this.time.hour} horas",
      isChecked: this.done,
      type: this.type,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      reminderBefore: json['reminderBefore'],
      time: DateTime.parse(json['time']),
      timeString: json['timeString'],
      title: json['title'],
      type: json['type'],
      done: json['done'] == 1,
      notificationIds: json["notificationIds"]
          .toString()
          .split(" ")
          .map((e) => int.parse(e))
          .toList(),
    );
  }
}
