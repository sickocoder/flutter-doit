import 'package:doit/models/task.dart';
import 'package:doit/pages/home/widgets/task-list-item.dart';
import 'package:doit/shared/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:grouped_list/sliver_grouped_list.dart';

import '../home.types.dart';

class TaskList extends StatefulWidget {
  final String filterBy;
  final List<TaskListItem> tasks;
  final List<Task> tasksWithFullData;
  final Function(TaskListItem task) onTaskItemChange;
  final Function shouldUpdateUI;

  TaskList({
    Key? key,
    required this.tasks,
    required this.onTaskItemChange,
    required this.filterBy,
    required this.tasksWithFullData,
    required this.shouldUpdateUI,
  }) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    List<TaskListItem> actualElements = this.widget.filterBy != "All"
        ? this
            .widget
            .tasks
            .where((element) => element.type == this.widget.filterBy)
            .toList()
        : this.widget.tasks;

    if (actualElements.length == 0)
      return SliverFillRemaining(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Opacity(
            opacity: 0.5,
            child: Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/png/no-data.png'),
                    Container(height: 16),
                    ScalableText('Sem Tarefas No Momento'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

    return SliverGroupedListView<TaskListItem, String>(
      elements: actualElements,
      groupBy: (element) => element.hour,
      groupComparator: (value1, value2) => value2.compareTo(value1),
      itemComparator: (item1, item2) => item1.hour.compareTo(item2.hour),
      order: GroupedListOrder.ASC,
      groupSeparatorBuilder: (String value) {
        bool isAllDone = actualElements
            .where((element) => element.hour == value)
            .every((element) => element.isChecked);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Opacity(
            opacity: isAllDone ? 0.6 : 1,
            child: ScalableText(
              value,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        );
      },
      itemBuilder: (context, element) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 12.0,
          ),
          child: TaskListItemWidget(
            element: element,
            taskData: this
                .widget
                .tasksWithFullData
                .firstWhere((el) => el.id == element.id),
            onSelect: (isSelected) {
              TaskListItem selectedTask = element;
              selectedTask.isChecked = isSelected;
              this.widget.onTaskItemChange(selectedTask);
            },
            updateTheUI: () {
              this.widget.shouldUpdateUI();
            },
          ),
        );
      },
    );
  }
}
