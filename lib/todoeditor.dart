import 'package:flutter/material.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/todo.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a ToDo"),
      ),
      body: const Center(
        child: ToDoForm(),
      ),
    );
  }
}

// Create a Form widget.
class ToDoForm extends StatefulWidget {
  const ToDoForm({Key? key}) : super(key: key);

  @override
  ToDoFormState createState() {
    return ToDoFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ToDoFormState extends State<ToDoForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleNameController = TextEditingController();
  TextEditingController descriptionNameController = TextEditingController();
  TextEditingController dateNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: titleNameController,
            // The validator receives the text that the user has entered.
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
          TextFormField(
            controller: descriptionNameController,
            // The validator receives the text that the user has entered.
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
          TextFormField(
            controller: dateNameController,
            // The validator receives the text that the user has entered.
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
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
                Navigator.pop(
                    context,
                    ToDo(
                        title: titleNameController.text.toString(),
                        description: descriptionNameController.text.toString(),
                        date: dateNameController.text.toString()));
              },
              child: const Text('Save to reminders'),
            ),
          ),
        ],
      ),
    );
  }
}
