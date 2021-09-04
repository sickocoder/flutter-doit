import 'package:doit/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DoItDatabase {
  Database? database;

  Future<DoItDatabase> openDoItDatabase() async {
    database = await openDatabase(
      join(
        await getDatabasesPath(),
        'doit_database.db',
      ),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, timeString TEXT, reminderBefore INTEGER, type TEXT, time TEXT, done INTEGER)',
        );
      },
    );

    return this;
  }

  Future<void> insertTask(Task task) async {
    final db = database;
    if (db == null) return;

    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> tasks() async {
    final db = database;
    if (db == null) return [];

    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        timeString: maps[i]['timeString'],
        time: DateTime.parse(maps[i]['time']),
        reminderBefore: maps[i]['reminderBefore'],
        type: maps[i]['type'],
        done: maps[i]['done'] == 1 ? true : false,
      );
    });
  }

  Future<void> updateTask(Task task) async {
    final db = database;
    if (db == null) return;

    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = database;
    if (db == null) return;

    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
