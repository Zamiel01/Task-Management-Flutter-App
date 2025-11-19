import '../models/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    //the below first two lines find a free available space on your phone to create the db for you to use it later on
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'auth.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

//creates new table named auth
  _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE Task (task TEXT ,  id INTEGER PRIMARY KEY AUTOINCREMENT)',
    );
  }

//add user to table
  Future<Task> insert(Task task) async {
    var dbClient = await db;
    try {
      await dbClient!.insert('auth', task.toMap());
    } catch (error) {
      print(error);
    }
    return task;
  }
  
  //checks if task already exist in db
  Future<bool> isTaskExist(String task,) async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('auth');
    var allTasks = queryResult.map((e) => Task.fromMap(e)).toList();
    for(var userTask in allTasks){
      print("Hello *******************");
      print("task :${userTask.task}");
      if(task == userTask.task){
        return true;
      }
    }
    return false;
  }

  
}