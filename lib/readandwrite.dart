import 'dart:async';
import 'dart:io';
import 'todo.dart';

import 'package:path_provider/path_provider.dart';

class ToDosStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFileInProgressToDos async {
    final path = await _localPath;
    return File('$path/inProgressTodos.txt');
  }

  Future<File> get _localFileCompletedToDos async {
    final path = await _localPath;
    return File('$path/completedTodos.txt');
  }

  // Read data from a file
  Future<List<ToDo>> readToDos(String type) async {
    List<ToDo> todoList = [];
    try {
      File file;
      List<String> todos;

      if (type == "inProgress") {
        file = await _localFileInProgressToDos;
      } else {
        file = await _localFileCompletedToDos;
      }
      todos = file.readAsLinesSync();

      for (int i = 0; i < todos.length; i = i + 3) {
        String title = todos[i];
        String description = todos[i + 1];
        String date = todos[i + 2];
        ToDo td = ToDo(title: title, description: description, date: date);
        todoList.add(td);
      }

      // Read the file

      return todoList;
    } catch (e) {
      // If encountering an error, return 0
      return todoList;
    }
  }

  void writeToDos(String type, List<ToDo> todos) async {
    File file;

    if (type == "inProgress") {
      file = await _localFileInProgressToDos;
    } else {
      file = await _localFileCompletedToDos;
    }

    IOSink outStream = file.openWrite();

    for (var todo in todos) {
      String title = todo.title;
      String description = todo.description;
      String date = todo.date;

      outStream.write(title);
      outStream.write(description);
      outStream.write(date);
    }
    outStream.close();
  }
}
