import 'package:flutter/material.dart';
import 'package:new_project/data/local_storage.dart';
import 'package:new_project/main.dart';
import 'package:new_project/models/daily_task.dart';
import 'package:new_project/widgets/task_list_item.dart';

class TaskSearchDelegate extends SearchDelegate {
  final List<DailyTask> allTasks;

  TaskSearchDelegate({required this.allTasks});
  //Buttons for right end of the search part
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  //Icon-Buttons left start side
  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          close(context, null);
        },
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.grey,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    var filteredTask = allTasks
        .where((currentTask) =>
            currentTask.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredTask.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              var currentTask = filteredTask[index];
              return Dismissible(
                key: Key(currentTask.id),
                onDismissed: (direction) async {
                  await locator<LocalStorage>().deleteTask(task: currentTask);
                  filteredTask.removeAt(index);
                },
                background: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text("This task is deleting...")
                  ],
                ),
                child: TaskListItem(task: currentTask),
              );
            },
            itemCount: filteredTask.length,
          )
        : const Center(
            child: Text('Your plans not found'),
          );
  }

  //part to be shown without any input
  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
