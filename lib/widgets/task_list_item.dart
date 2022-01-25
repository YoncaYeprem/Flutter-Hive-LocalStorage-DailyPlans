import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/data/local_storage.dart';
import 'package:new_project/models/daily_task.dart';

import '../main.dart';

class TaskListItem extends StatefulWidget {
  DailyTask task;
  TaskListItem({Key? key, required this.task}) : super(key: key);

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  TextEditingController updateController = TextEditingController();
  String updateValue = '';
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    updateController.text = widget.task.content;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),

            blurRadius: 10,
            // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            setState(() {
              widget.task.isDone = !widget.task.isDone;
              _localStorage.updateTask(task: widget.task);
            });
          },
          child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  color: widget.task.isDone ? Colors.green : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.8))),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              )),
        ),
        title: widget.task.isDone
            ? Text(widget.task.content,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey))
            : GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title:
                                const Center(child: Text('Update Your Plan')),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: updateController,
                                  minLines: 1,
                                  maxLines: null,
                                  onChanged: (value) {
                                    setState(() {
                                      updateValue = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.red),
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green),
                                        child: const Text('Update'),
                                        onPressed: () {
                                          setState(() {
                                            updateValue == ''
                                                ? widget.task.content
                                                : widget.task.content =
                                                    updateValue;
                                            _localStorage.updateTask(
                                                task: widget.task);
                                          });

                                          Navigator.of(context).pop();
                                        })
                                  ],
                                )
                              ],
                            ),
                          ));
                },
                child: Text(widget.task.content)),
        trailing: Text(DateFormat('hh:mm a').format(widget.task.createdAt)),
      ),
    );
  }
}
