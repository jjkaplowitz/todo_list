/* MIDN Josh Kaplowitz + MIDN Sean Chen
* ToDo editor allows user to create and edit
* todos.
*/

import 'package:flutter/material.dart';
import 'package:todo_list/todo.dart';

/// ToDoEditor class
/// Creates the form to allow user to add or edit a todo
class ToDoEditor extends StatelessWidget {
  const ToDoEditor({Key? key, required this.todo}) : super(key: key);
  final ToDo todo;

  /// Builds main widget UI for form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a ToDo"),
      ),
      body: Center(
        child: ToDoForm(
          todo: todo,
        ),
      ),
    );
  }
}

/// ToDoForm class
/// Creates the form widget that will update the main listview in the todos
class ToDoForm extends StatefulWidget {
  const ToDoForm({Key? key, required this.todo}) : super(key: key);
  final ToDo todo;

  /// Text controllers push data back to main list view
  @override
  // ignore: no_logic_in_create_state
  ToDoFormState createState() {
    TextEditingController titleNameController =
        TextEditingController(text: todo.title);
    TextEditingController descriptionNameController =
        TextEditingController(text: todo.description);
    TextEditingController dateNameController =
        TextEditingController(text: todo.date);

    return ToDoFormState(
        todo: todo,
        title: titleNameController,
        description: descriptionNameController,
        date: dateNameController);
  }
}

/// ToDoFormState class
/// Creates the basic form state for the todoeditor
class ToDoFormState extends State<ToDoForm> {
  final _formKey = GlobalKey<FormState>();
  final ToDo todo;
  final TextEditingController title, description, date;
  ToDoFormState(
      {required this.todo,
      required this.title,
      required this.description,
      required this.date});

  /// This is main UI widget for the form
  /// Includes the input textfield for the title, description and date
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Textfield for the title
          /// Data required
          TextFormField(
            controller: title,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),

          /// Textfield for the description
          /// Data required
          TextFormField(
            controller: description,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
          ),

          /// Textfield for the date
          /// Data required
          TextFormField(
            controller: date,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a due date';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: 'Due date',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              /// When button pressed, return to main list and push data back
              /// If no data inputted then a warning will be displayed
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(
                      context,
                      ToDo(
                          title: title.text.toString(),
                          description: description.text.toString(),
                          date: date.text.toString()));
                }
              },
              child: const Center(child: Text('Save to todos')),
            ),
          ),
        ],
      ),
    );
  }
}
