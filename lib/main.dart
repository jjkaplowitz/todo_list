import 'package:flutter/material.dart';
import 'todolistitem.dart';
import 'todo.dart';
import 'todoeditor.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({required this.todos, Key? key}) : super(key: key);

  final List<ToDo> todos;

  // The framework calls createState the first time
  // a widget appears at a given location in the tree.
  // If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses
  // the State object instead of creating a new State object.

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final _todoList = <ToDo>{};
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const SecondRoute()),
      // );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SecondRoute()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My ToDo List'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: widget.todos.map((ToDo todo) {
          return ToDoListItem(
            todo: todo,
            // inList: _todoList.contains(todo),
            // onListChanged: _handleToDoChanged,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Shopping App',
    home: ToDoList(
      todos: [
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
        ToDo(title: 'Get Chicken', description: 'Need more', date: 'tomorrow'),
      ],
    ),
  ));
}
