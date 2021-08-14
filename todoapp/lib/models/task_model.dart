// data - task models

class Task {
  int? id;
  String title;
  DateTime date;
  String priority;
  int status;

  Task(
      {required this.title,
      required this.date,
      required this.priority,
      required this.status});
  Task.withId(
      {required this.id,
      required this.title,
      required this.date,
      required this.priority,
      required this.status});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();

    // ignore: unnecessary_null_comparison
    if (id != null) {
      map["id"] = id;
    }

    map["title"] = title;
    map["date"] = date.toIso8601String();
    map["priority"] = priority;
    map["status"] = status;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
        id: map["id"],
        title: map["title"],
        date: DateTime.parse(map["date"]),
        priority: map["priority"],
        status: map["status"]);
  }
}
