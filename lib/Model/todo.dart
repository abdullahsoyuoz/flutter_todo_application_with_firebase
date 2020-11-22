import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String content;
  bool isCompleted;
  Timestamp time;
  String uid;

  Todo(this.content, this.isCompleted, this.time, this.uid);
  Todo.without();

  static Todo fromMap(var map) {
    Todo item = Todo.without();
    item.content = map["content"];
    item.isCompleted = map["isCompleted"];
    item.time = map["time"];
    item.uid = map["uid"];

    return item;
  }

  static Map<String, dynamic> toMap(Todo item) {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["content"] = item.content;
    map["isCompleted"] = item.isCompleted;
    map["time"] = item.time;
    map["uid"] = item.uid;

    return map;
  }
}
