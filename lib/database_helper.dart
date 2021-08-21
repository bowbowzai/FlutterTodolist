import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todolist/models/todo.dart';
import './models/task.dart';
import './models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, desc TEXT)');
        await db.execute(
            'CREATE TABLE todolist(id INTEGER PRIMARY KEY, title TEXT, isDone INTEGER, taskID INTEGER)');
        // return db;
      },
      version: 1,
    );
  }

  Future<void> updateTask(String title, int id) async {
    Database _database = await database();

    _database.rawUpdate('UPDATE tasks set title=\'$title\' where id=$id');
  }

  Future<void> updateDesc(String desc, int id) async {
    Database _database = await database();

    _database.rawUpdate('UPDATE tasks set desc=\'$desc\' where id=$id');
  }

  Future<void> updateTodo(int isDone, int todoId) async {
    Database _database = await database();
    _database.rawUpdate('UPDATE todolist SET isDone=$isDone WHERE id=$todoId');
  }

  Future<int> insertTask(Task task) async {
    int taskid = 0;
    Database _database = await database();
    await _database
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => taskid = value);
    return taskid;
  }

  Future<void> insertTodo(TodoList tdl) async {
    Database _database = await database();
    await _database.insert('todolist', tdl.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTask() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
        id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        desc: taskMap[index]['desc'],
      );
    });
  }

  Future<List<TodoList>> getTodo(int id) async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap =
        await _db.rawQuery('SELECT * FROM todolist where taskID=$id');
    return List.generate(taskMap.length, (index) {
      return TodoList(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          taskID: taskMap[index]['taskID'],
          isDone: taskMap[index]['isDone']);
          
    });
  }

  Future<void> deleteTask(int id) async {
    Database _database = await database();
    await _database.rawDelete('DELETE FROM tasks WHERE id=$id');
    await _database.rawDelete('DELETE FROM todolist WHERE taskID=$id');
  }
}
