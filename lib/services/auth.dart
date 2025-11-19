import '../models/user.dart';
import '../models/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db!;
    _db = await initDatabase();
    return _db;

    
  }

  // Initialize database
  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'auth.db');

    var db = await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'CREATE TABLE Task (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT)',
          );
        }
      },
    );

    return db;
  }

  // Create tables
  _onCreate(Database db, int version) async {
   

    await db.execute(
      'CREATE TABLE Task (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT)',
    );
  }


  //update task function
  Future<int> updateTask(Task task) async {
  var dbClient = await db;
  
  if (task.id == null) {
    print("Cannot update a task without an ID");
    return 0;
  }

  try {
    // Update only the task text
    int result = await dbClient!.update(
      'Task', 
      {'task': task.task},   // Only update the 'task' column
      where: 'id = ?', 
      whereArgs: [task.id],
    );
    return result; // Returns number of rows updated
  } catch (error) {
    print("Error updating task: $error");
    return 0;
  }
}




  // ------------------- TASK METHODS -------------------
  

  Future<Task> insertTask(Task task) async {
    var dbClient = await db;
    try {
      // Only include id in map if it exists
      int id = await dbClient!.insert('Task', task.toMap());
      task.id = id; // assign the generated id
    } catch (error) {
      print(error);
    }
    return task;
  }

  Future<void> deleteTask(int id) async {
    var dbClient = await db;
    await dbClient!.delete('Task', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isTaskExist(String taskText) async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query(
      'Task',
    );
    var allTasks = queryResult.map((e) => Task.fromMap(e)).toList();
    for (var t in allTasks) {
      if (taskText == t.task) return true;
    }
    return false;
  }

  Future<List<Task>> getAllTasks() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query(
      'Task',
      orderBy: 'id DESC',
    );
    return queryResult.map((e) => Task.fromMap(e)).toList();
  }
}


//update task function
