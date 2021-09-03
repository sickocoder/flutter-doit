import 'package:doit/models/task.dart';
import 'package:doit/pages/add-task/index.dart';
import 'package:doit/shared/widgets/text.dart';
import 'package:doit/utils/constants.dart';
import 'package:flutter/material.dart';

import '../home.types.dart';
import 'checkbox.dart';

class TaskListItemWidget extends StatelessWidget {
  final TaskListItem element;
  final Task taskData;
  final Function(bool selected) onSelect;
  final Function()? updateTheUI;

  final textKey = GlobalKey();

  TaskListItemWidget({
    Key? key,
    required this.element,
    required this.onSelect,
    required this.taskData,
    this.updateTheUI,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(seconds: 3),
      opacity: element.isChecked ? 0.6 : 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DoitCheckbox(
            value: element.isChecked,
            onValueChanged: (selected) {
              this.onSelect(selected);
            },
          ),
          Container(width: 16),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                enableDrag: true,
                builder: (BuildContext context) {
                  return AddTask(
                    isEdit: true,
                    realTaskData: taskData,
                    taskItemData: element,
                    updateTheUI: () {
                      this.updateTheUI!();
                    },
                  );
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: ScalableText(
                    element.title,
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          decoration: element.isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationThickness: 2.0,
                        ),
                  ),
                ),
                Container(height: 4),
                Container(
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: ScalableText(
                      ptTodoType[element.type] as String,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
