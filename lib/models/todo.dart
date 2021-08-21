class TodoList {
  final int id;
  final String title;
  final int isDone;
  final int taskID;
  TodoList({this.id = 0, required this.title, required this.isDone, required this.taskID});

  Map<String, dynamic> toMap() {
    return {  
      'title': title,
      'isDone': isDone,
      'taskID': taskID
    };
  }
}