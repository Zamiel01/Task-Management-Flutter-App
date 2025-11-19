import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/auth.dart';  // Your DBHelper lives here

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];        // Holds tasks loaded from DB
  Task? _selectedTask;           // Holds currently selected task

  List<Task> get tasks => _tasks;
  Task? get selectedTask => _selectedTask;

  final DBHelper _db = DBHelper();  // Create DB instance to use its methods

  // ------------------ LOAD TASKS ------------------
  Future<void> loadTasks() async {
    _tasks = await _db.getAllTasks();   // Load from SQLite
    notifyListeners();                  // Refresh the UI
  }

  // ------------------ SELECT TASK ------------------
  void selectTask(Task task) {
    _selectedTask = task;
    notifyListeners();
  }

  // ------------------ CHECK IF TASK EXISTS ------------------
  Future<bool> isTaskExist(String taskText) async {
    return await _db.isTaskExist(taskText);
  }

  // ------------------ ADD TASK ------------------
  Future<void> addTask(Task task) async {
    if (await isTaskExist(task.task)) {
      // Optionally, throw an error or return early
      print("Task already exists: ${task.task}");
      return;
    }
    await _db.insertTask(task);      // Save into DB
    await loadTasks();               // Reload list
  }

  // ------------------ UPDATE TASK ------------------
  Future<void> updateTask(Task task) async {
    await _db.updateTask(task);      // Update DB entry
    await loadTasks();               // Reload list
  }

  // ------------------ DELETE TASK ------------------
  Future<void> deleteTask(int id) async {
    await _db.deleteTask(id);       // Remove from DB
    await loadTasks();              // Reload list
  }
}
