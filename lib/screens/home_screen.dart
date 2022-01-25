import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:new_project/data/local_storage.dart';
import 'package:new_project/main.dart';
import 'package:new_project/models/daily_task.dart';
import 'package:new_project/widgets/task_list_item.dart';
import 'package:new_project/widgets/task_search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<DailyTask> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = [];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "What is your plans for today?",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _showSearchPage();
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                _showBottomModalSheet(context);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ))
        ],
      ),
      body: SafeArea(
          child: _allTasks.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    var currentTask = _allTasks[index];
                    return Dismissible(
                      key: Key(currentTask.id),
                      onDismissed: (direction) async {
                        await _localStorage.deleteTask(task: currentTask);
                        setState(() {
                          _allTasks.removeAt(index);
                        });
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
                  itemCount: _allTasks.length,
                )
              : const Center(
                  child: Text("Lets Add Tasks"),
                )),
    );
  }

  void _showBottomModalSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ListTile(
              title: TextField(
                autofocus: true,
                decoration:
                    const InputDecoration(hintText: 'What is your task?'),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  if (value.length > 3) {
                    DatePicker.showTimePicker(context, showSecondsColumn: false,
                        onConfirm: (time) async {
                      var newTask =
                          DailyTask.create(content: value, createdAt: time);
                      await _localStorage.addTask(task: newTask);
                      setState(() {
                        _allTasks.add(newTask);
                      });
                    });
                  }
                },
              ),
            ),
          );
        });
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTasks();
    setState(() {});
  }

  void _showSearchPage() async {
    await showSearch(
        context: context, delegate: TaskSearchDelegate(allTasks: _allTasks));
    setState(() {});
    _getAllTaskFromDb();
  }
}
