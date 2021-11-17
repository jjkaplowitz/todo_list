import 'package:flutter/material.dart';
import 'todo.dart';
import 'todoeditor.dart';
import 'package:todo_list/todo.dart';
import 'dart:math';
import 'readandwrite.dart';

List<ToDo> inProgressTodos = [];
List<ToDo> completedTodos = [];
late _ToDoListState state;
ToDosStorage storage = ToDosStorage();

class ToDoList extends StatefulWidget {
  ToDoList({this.todos, Key? key}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var todos;

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final _todoList = <ToDo>{};

  void _incrementCounter() {
    _awaitReturnValueFromSecondScreen(context);
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SecondRoute(
              todo: ToDo(title: "", description: "", date: "")),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      inProgressTodos.add(result);
    });
  }

  void _awaitReturnValueFromSecondScreenUpdate(
      BuildContext context, ToDo todo) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondRoute(
            todo: todo,
          ),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    // setState(() {
    inProgressTodos.add(result);
    // });

    storage.writeToDos('inProgress', inProgressTodos);
    storage.writeToDos('completed', completedTodos);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ToDoTabBar(selectedTab: 0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: widget.todos.map<Widget>((ToDo todo) {
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

Future<void> main() async {
  inProgressTodos = await storage.readToDos('inProgress');
  completedTodos = await storage.readToDos('completed');

  for (var todo in completedTodos) {
    print(todo.title);
  }
  print("here");

  runApp(const MaterialApp(
    home: ToDoTabBar(selectedTab: 0),
  ));
}

class ToDoTabBar extends StatelessWidget {
  final int selectedTab;
  const ToDoTabBar({required this.selectedTab, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: selectedTab,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'In progress',
                ),
                Tab(
                  text: 'Completed',
                ),
              ],
            ),
            title: Text(
              'My ToDos',
              style: TextStyle(
                fontSize: 30,
                fontStyle: FontStyle.italic,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = Colors.white,
              ),
            ),
          ),
          body: TabBarView(
            children: [
              ToDoList(
                todos: inProgressTodos,
              ),
              ToDoList(
                todos: completedTodos,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef ListChangedCallback = Function(ToDo todo, bool inList);

class ToDoListItem extends StatelessWidget {
  const ToDoListItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final ToDo todo;

  Color _getColor(BuildContext context, ToDo todo) {
    if (completedTodos.contains(todo)) {
      return Colors.black54;
    } else {
      return Colors.primaries[Random().nextInt(Colors.primaries.length)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: CircleAvatar(
              backgroundColor: _getColor(context, todo),
              child: Text(todo.title[0]),
            ),
          ),
          Expanded(
            flex: 4,
            child: _ToDoDescription(
              todo: todo,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToDoDescription extends StatelessWidget {
  const _ToDoDescription({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final ToDo todo;

  TextStyle? _getTextStyleTitle(BuildContext context, ToDo todo) {
    if (!completedTodos.contains(todo)) {
      return TextStyle(
        fontSize: 20,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.primaries[Random().nextInt(Colors.primaries.length)],
      );
    }

    return const TextStyle(
        color: Colors.black54, decoration: TextDecoration.lineThrough);
  }

  TextStyle? _getTextStyleDescription(BuildContext context, ToDo todo) {
    if (!completedTodos.contains(todo)) {
      return const TextStyle(
        fontSize: 15,
        fontStyle: FontStyle.italic,
      );
    }

    return const TextStyle(
        color: Colors.black54, decoration: TextDecoration.lineThrough);
  }

  TextStyle? _getTextStyleDate(BuildContext context, ToDo todo) {
    if (!completedTodos.contains(todo)) {
      return const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      );
    }

    return const TextStyle(
        color: Colors.black54, decoration: TextDecoration.lineThrough);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(todo.title, style: _getTextStyleTitle(context, todo)),
            const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
            Text(
              todo.description,
              style: _getTextStyleDescription(context, todo),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
            Text(todo.date, style: _getTextStyleDate(context, todo)),
          ],
        ),
        onTap: () {
          if (completedTodos.contains(todo)) {
            inProgressTodos.add(todo);
            completedTodos.remove(todo);

            storage.writeToDos('inProgress', inProgressTodos);
            storage.writeToDos('completed', completedTodos);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ToDoTabBar(selectedTab: 0)));
          } else if (inProgressTodos.contains(todo)) {
            completedTodos.add(todo);
            inProgressTodos.remove(todo);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ToDoTabBar(selectedTab: 1)));
          }
        },
        onLongPress: () {
          if (completedTodos.contains(todo)) {
            completedTodos.remove(todo);
          }
          if (inProgressTodos.contains(todo)) {
            inProgressTodos.remove(todo);
          }

          storage.writeToDos('inProgress', inProgressTodos);
          storage.writeToDos('completed', completedTodos);

          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const ToDoTabBar(selectedTab: 0))
          //         );

          Navigator.push(
              context,
              PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return const ToDoTabBar(selectedTab: 0);
                  },
                  transitionsBuilder:
                      (___, Animation<double> animation, ____, Widget child) {
                    return FadeTransition(
                      opacity: animation,
                      child: RotationTransition(
                        turns: Tween<double>(begin: 0.5, end: 1.0)
                            .animate(animation),
                        child: child,
                      ),
                    );
                  }));

          final snackBar = SnackBar(
            content: const Text("Deleted"),
            action: SnackBarAction(
              label: "Can't undo",
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        onDoubleTap: () {
          final snackBar = SnackBar(
            content: const Text("Edited"),
            action: SnackBarAction(
              label: "Can't undo",
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          _ToDoListState d = _ToDoListState();
          d._awaitReturnValueFromSecondScreenUpdate(context, todo);
          inProgressTodos.remove(todo);

          storage.writeToDos('inProgress', inProgressTodos);
          storage.writeToDos('completed', completedTodos);
        },
      ),
    );
  }
}
