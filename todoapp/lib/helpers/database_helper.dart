import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  String tasksTable = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database> get db async => _db ??= await _initDb();

  // Future<Database> get db async {
  //   if (_db == null) {
  //     _db = await _initDb();
  //   }
  //   return _db;
  // }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_list.db';
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  // database oluşturma

  void _createDb(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $tasksTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT  , $colTitle TEXT ,$colDate TEXT, $colPriority TEXT, $colStatus INTEGER)",
    );
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(tasksTable);
    return result;
  }

  // listeyi listeleme
  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
    return taskList;
  }

  // data ekleme - görev ekleme
  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    //final int result = await db.insert(tasksTable, task.toMap());
    var result = await db.insert(tasksTable, task.toMap());
    return result;
  }

  // listeyi guncelleme
  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int result = await db.update(
      tasksTable,
      task.toMap(),
      where: '$colId = ?',
      whereArgs: [task.id],
    );
    return result;
  }

  // listeyi silme
  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result =
        await db.delete(tasksTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }
}
