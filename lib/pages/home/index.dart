import 'package:doit/models/quote.dart';
import 'package:doit/models/task.dart';
import 'package:doit/services/db/database.dart';
import 'package:doit/shared/widgets/button.dart';
import 'package:doit/shared/widgets/text.dart';
import 'package:doit/theme/text.dart';
import 'package:doit/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/bottom-tabs.dart';
import 'widgets/quote-of-day.dart';
import 'widgets/task-list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTabIndex = 0;
  late Future<List<Task>> tasks;

  List<String> tabs = [
    "All",
    TodoTaskType.NEED_TOS,
    TodoTaskType.WANT_TOS,
    TodoTaskType.MIGHT_TOS,
  ];

  void updateUI() {
    setState(() {
      tasks = getTasks();
    });
  }

  Future<List<Task>> getTasks() async {
    var database = await DoItDatabase().openDoItDatabase();
    var dataBaseTasks = await database.tasks();

    return dataBaseTasks;
  }

  Future<void> updateTask(Task task) async {
    var database = await DoItDatabase().openDoItDatabase();
    await database.updateTask(task);

    updateUI();
  }

  Future<void> navigateToAddTaskPage() async {
    await Navigator.of(context).pushNamed(AppConstants.AddTask);
    updateUI();
  }

  @override
  void initState() {
    super.initState();
    tasks = getTasks();
  }

  @override
  Widget build(BuildContext context) {
    final quote = ModalRoute.of(context)!.settings.arguments as Quote;
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: tasks,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Task>> snapshot,
        ) {
          if (!snapshot.hasData) return Container();

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        centerTitle: true,
                        elevation: 0,
                        backgroundColor: Colors.black,
                        title: ScalableText(
                          'Do It',
                          style: AppTextStyles.appTitle,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: QuoteOfDay(quote: quote),
                      ),
                      TaskList(
                        tasksWithFullData: snapshot.data as List<Task>,
                        tasks: (snapshot.data as List<Task>)
                            .map((e) => e.formated())
                            .toList(),
                        filterBy: this.tabs[selectedTabIndex],
                        onTaskItemChange: (task) {
                          List<Task> data = snapshot.data as List<Task>;
                          Task element = data
                              .firstWhere((dataItem) => dataItem.id == task.id);
                          element.done = task.isChecked;

                          updateTask(element);
                        },
                        shouldUpdateUI: () {
                          updateUI();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(color: Color(0xFF828282)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DoItButton(
                          onPressed: () {
                            navigateToAddTaskPage();
                          },
                          title: 'Nova Tarefa',
                        ),
                      ),
                      BottomTabs(
                        tabsData: [
                          "Tudo",
                          "Preciso Fazer",
                          "Quero Fazer",
                          "Posso Fazer",
                        ],
                        onSelected: (tabIndex) {
                          setState(() {
                            this.selectedTabIndex = tabIndex;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
