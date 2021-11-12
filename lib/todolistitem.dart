import 'package:flutter/material.dart';
import 'todo.dart';

typedef ListChangedCallback = Function(ToDo todo, bool inList);

class ToDoListItem extends StatelessWidget {
  const ToDoListItem({
    Key? key,
    required this.todo,
    // required this.inList,
    // required this.onListChanged,
  }) : super(key: key);

  final ToDo todo;
  // final bool inList;
  // final ListChangedCallback onListChanged;

  // Color _getColor(BuildContext context) {
  //   // The theme depends on the BuildContext because different
  //   // parts of the tree can have different themes.
  //   // The BuildContext indicates where the build is
  //   // taking place and therefore which theme to use.

  //   return inList //
  //       ? Colors.black54
  //       : Theme.of(context).primaryColor;
  // }

  // TextStyle? _getTextStyle(BuildContext context) {
  //   if (!inList) return null;

  //   return const TextStyle(
  //     color: Colors.black54,
  //     decoration: TextDecoration.lineThrough,
  //   );
  // }

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
              backgroundColor: Colors.blue,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            todo.title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            todo.description,
            style: const TextStyle(fontSize: 12.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            todo.date,
            style: const TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
