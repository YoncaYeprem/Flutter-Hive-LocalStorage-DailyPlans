import 'package:hive/hive.dart';
import 'package:new_project/models/daily_task.dart';

abstract class LocalStorage {
  Future<void> addTask({required DailyTask task});
  Future<DailyTask?> getTask({required String id});
  Future<List<DailyTask>> getAllTasks();
  Future<bool> deleteTask({required DailyTask task});
  Future<DailyTask> updateTask({required DailyTask task});
}

class HiveLocalStorage extends LocalStorage {
  late Box<DailyTask> _taskBox;

  HiveLocalStorage() {
    _taskBox = Hive.box<DailyTask>('tasks');
  }

  @override
  Future<void> addTask({required DailyTask task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required DailyTask task}) async {
    await task.delete();
    return true;
  }

  @override
  Future<List<DailyTask>> getAllTasks() async {
    List<DailyTask> allTasks = <DailyTask>[];
    allTasks = _taskBox.values.toList();

    if (allTasks.isNotEmpty) {
      allTasks.sort(
          (DailyTask a, DailyTask b) => b.createdAt.compareTo(a.createdAt));
    }
    return allTasks;
  }

  @override
  Future<DailyTask?> getTask({required String id}) async {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<DailyTask> updateTask({required DailyTask task}) async {
    await task.save();
    return task;
  }
}
