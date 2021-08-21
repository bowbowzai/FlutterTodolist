
class Task {
  final String title;
  final String desc;
  final int id;
  Task({required this.title, required this.desc, this.id = 0});

  Map<String, dynamic> toMap() {
    return {  
      'title': title,
      'desc': desc
    };
  }
}