/* MIDN Josh Kaplowitz + MIDN Sean Chen
* ToDo List for iOS, Android and Web
* Creates an interactive ToDo list that allows a user to add,
* delete, edit and cross out todos. User can set a date for completion,
* description and title.
*/

/// Imports
import 'package:flutter/material.dart';
import 'todo.dart';
import 'todoeditor.dart';
import 'package:todo_list/todo.dart';
import 'dart:math';

/// Keeps track of current and finished todos
List<ToDo> inProgressTodos = [];
List<ToDo> completedTodos = [];
late _ToDoListState state;

/// MAIN
///
/// Runs app starting on the first tab of the tab bar
///
///
///
///
///
///
///
///
main() {
  runApp(const MaterialApp(
    home: ToDoTabBar(selectedTab: 0),
  ));
}

///
///
///
///
///
///
///
///
///
///

/// ToDoList class
/// Holds the list of todos and creates the changeable state
class ToDoList extends StatefulWidget {
  ToDoList({this.todos, Key? key}) : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var todos;

  @override
  _ToDoListState createState() => _ToDoListState();
}

/// ToDoListState
/// Refreshes the screen on change
class _ToDoListState extends State<ToDoList> {
  final _todoList = <ToDo>{};

  /// Refresh screen after adding todo
  void _refresh() {
    _awaitReturnValueFromSecondScreen(context);
  }

  /// Gets value from second screen
  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ToDoEditor(
              todo: ToDo(title: "", description: "", date: "")),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      if (result != null) inProgressTodos.add(result);
    });
  }

  /// Changes value for editing a todo and refreshes screen
  void _awaitReturnValueFromSecondScreenUpdate(
      BuildContext context, ToDo todo) async {
    /// Start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ToDoEditor(
            todo: todo,
          ),
        ));

    if (result != null) {
      inProgressTodos.add(result);
      inProgressTodos.remove(todo);
    }

    /// Refresh screen
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ToDoTabBar(selectedTab: 0)));
  }

  /// Builds the UI widget for main list
  /// Holds all the todolistitems and floating action button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: widget.todos.map<Widget>((ToDo todo) {
          return ToDoListItem(
            todo: todo,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// ToDoBar class
/// Creates the main tab bar UI with two tabs
/// Tab 1: In progress todos
/// Tab 2: Completed todos
class ToDoTabBar extends StatelessWidget {
  final int selectedTab;
  const ToDoTabBar({required this.selectedTab, Key? key}) : super(key: key);

  /// Builds widget UI for todotabbar
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

/// ToDoListItem Class
/// Creates the custom list displayed in the listview
/// Stores a todo with an avatar photo that holds the first letter of the
/// todo title.
class ToDoListItem extends StatelessWidget {
  const ToDoListItem({
    Key? key,
    required this.todo,
  }) : super(key: key);
  final ToDo todo;

  /// Will change the color to a random one or black it out
  /// if the todo is completed
  Color _getColor(BuildContext context, ToDo todo) {
    if (completedTodos.contains(todo)) {
      return Colors.black54;
    } else {
      return Colors.primaries[Random().nextInt(Colors.primaries.length)];
    }
  }

  /// Creates UI widget for the todolistitem
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

/// Private description class used to display the description
/// of the todos
class _ToDoDescription extends StatelessWidget {
  const _ToDoDescription({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final ToDo todo;

  /// Custom textstyle for the todo title
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

  /// Custom textstyle for the todo description
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

  /// Custom textstyle for the todo date
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

  /// Creates UI widget for the todo
  /// Includes the title, description and date
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

        /// Will delete the todo on longpress
        onLongPress: () {
          if (completedTodos.contains(todo)) {
            completedTodos.remove(todo);
          }
          if (inProgressTodos.contains(todo)) {
            inProgressTodos.remove(todo);
          }

          /// Refresh screen
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

          /// Notify user on delete
          final snackBar = SnackBar(
            content: const Text("Deleted"),
            action: SnackBarAction(
              label: "Done",
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },

        /// Double tap will allow edit
        onDoubleTap: () {
          /// Notify user on edit
          final snackBar = SnackBar(
            content: const Text("Edited"),
            action: SnackBarAction(
              label: "Done",
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          _ToDoListState d = _ToDoListState();
          d._awaitReturnValueFromSecondScreenUpdate(context, todo);
        },
      ),
    );
  }
}
