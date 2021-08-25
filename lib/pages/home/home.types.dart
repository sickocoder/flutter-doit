import 'package:doit/utils/constants.dart';

class TaskListItem {
  int id;
  String title;
  String hour;
  bool isChecked;
  String type;

  TaskListItem({
    this.id = -1,
    required this.title,
    required this.hour,
    required this.type,
    this.isChecked = false,
  });
}
