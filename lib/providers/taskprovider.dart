import 'package:flutter/material.dart';
import '../models/taskmodel.dart';
import '../helper/databasehelper.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    final data = await DatabaseHelper.instance.getTasks();
    _tasks = data;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await DatabaseHelper.instance.insertTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    if (task.id != null) {
      await DatabaseHelper.instance.updateTask(task);
      await loadTasks();
    }
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    await loadTasks();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    await DatabaseHelper.instance.updateTask(task);
    await loadTasks();
  }
}
