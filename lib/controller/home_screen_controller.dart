import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class HomeScreenController {
  static late Database database;
  static List<Map> todoList = [
    {
      "task": "task",
      "date": "date",

      "status": "pending",
      "priority": "selectedPriority",
    },
  ];
  static List<Map> pendingList = [
    {
      "task": "task",
      "date": "date",

      "status": "pending",
      "priority": "selectedPriority",
    },
  ];
  static List<Map> completedList = [
    {
      "task": "task",
      "date": "date",

      "status": "pending",
      "priority": "selectedPriority",
    },
  ];
  static void onPrioritySelection(String? value) {
    selectedPriority = value;
  }

  static const List priorities = [
    "High Priority",
    "Medium Priority",
    "Low Priority",
    "No Priority",
  ];
  static const List priorityFlags = [
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.grey,
  ];
  static String? selectedPriority;
  static Future<String> onDateSelection(BuildContext context) async {
    var selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (selectedDate != null) {
      String formattedDate = DateFormat("dd/MM/yyyy").format(selectedDate);

      return formattedDate;
    }
    return "";
  }

  static Future<void> createDb() async {
    database = await openDatabase(
      "todo.db",
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
          'CREATE TABLE Todo (id INTEGER PRIMARY KEY, task TEXT, date TEXT, priority TEXT,status TEXT)',
        );
        log("Database Created");
      },
    );
  }

  static Future<void> insertData({
    required String task,
    required String date,
  }) async {
    String priority = selectedPriority ?? "No Priority";
    await database.rawInsert(
      'INSERT INTO Todo(task, date, priority, status) VALUES(?, ?, ?,?)',
      [task, date, priority, "pending"],
    );
    await getAllTasks();
  }

  static Future<void> getAllTasks() async {
    todoList = await database.rawQuery('SELECT * FROM Todo ORDER BY date ASC');
    log(todoList.toString());
  }

  static Future<void> updateTask(int id, String status) async {
    await database.rawUpdate('UPDATE Todo SET status = ? WHERE id = ?', [
      status,
      id,
    ]);
    await getAllTasks();
  }

  static Future<void> getPendingTasks() async {
    pendingList = await database.query(
      'Todo',
      where: 'status = ?',
      whereArgs: ["pending"],
    );
    log(pendingList.toString());
  }

  static Future<void> getCompletedTasks() async {
    completedList = await database.query(
      'Todo',
      where: 'status=?',
      whereArgs: ["completed"],
    );
    log(completedList.toString());
  }

  static Future<void> deleteTasks(var taskId) async {
    await database.rawDelete('DELETE FROM Todo WHERE id = ?', [taskId]);
    await getAllTasks();
  }

  static String checkOverDue(String dueDate) {
    DateTime today = DateTime.now();
    DateTime formattedToday = DateTime(today.year, today.month, today.day);

    DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(dueDate);
    DateTime formattedDueDate = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
    );

    if (formattedDueDate.isBefore(formattedToday)) {
      return "Overdue";
    } else if (formattedDueDate.isAtSameMomentAs(formattedToday)) {
      return "Due Today";
    } else if (formattedDueDate.isAtSameMomentAs(
      formattedToday.add(Duration(days: 1)),
    )) {
      return "Tomorrow";
    } else {
      return "Upcoming";
    }
  }

  static Future<void> updateTaskDetails({
    required String task,
    required String date,
    var todoId,
  }) async {
    await database.rawUpdate(
      'UPDATE Todo SET  task= ?,  priority=?, date=? WHERE id = ?',
      [task, selectedPriority, date, todoId],
    );
    await getAllTasks();
  }
}
