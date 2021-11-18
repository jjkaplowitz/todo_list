/* MIDN Josh Kaplowitz + MIDN Sean Chen
* Creates todo constructor for the todo app.
*/

/// ToDo class
/// Title is the main name for todo
/// Description is some details about the todo
/// Date is time when user wants todo done
class ToDo {
  const ToDo({
    required this.title,
    required this.description,
    required this.date,
  });

  final String title;
  final String description;
  final String date;
}
