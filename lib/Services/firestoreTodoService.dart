import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Model/todo.dart';
import 'package:todo_app/Services/firestoreAuthService.dart';

class TodoService with ChangeNotifier, DiagnosticableTreeMixin {
  //  --------------------------------------------------------------------------- INIT

  List<Todo> currentList = [];
  List<Todo> fetchingList = [];
  List<Todo> queryResultList = [];

  CollectionReference getCollection() {
    return FirebaseFirestore.instance.collection("todos");
  }

  String generateDocPath(Todo item) {
    return firebaseAuthService.auth.currentUser.uid + "${item.content}";
  }

  //  --------------------------------------------------------------------------- GET

  Future<void> fetchData({bool isQuery = false}) async {
    if (isQuery == false) {
      fetchingList = [];
      var data = await getCollection()
          .where("uid", isEqualTo: firebaseAuthService.auth.currentUser.uid)
          .orderBy('time', descending: true)
          .get();
      data.docs.toList().forEach((element) async {
        fetchingList.add(Todo.fromMap(element));
      });
      syncListFromFetch();
    }
    notifyListeners();
    print("fetching...");
  }

  // Stream<QuerySnapshot> getDataStream() {
  //   return getCollection()
  //       .where("uid", isEqualTo: firebaseAuthService.auth.currentUser.uid)
  //       .orderBy('time', descending: false)
  //       .orderBy('content', descending: false)
  //       .snapshots();
  // }

  // Future<QuerySnapshot> getDataFuture() async {
  //   return getCollection()
  //       .where('uid', isEqualTo: firebaseAuthService.auth.currentUser.uid)
  //       .orderBy("content", descending: false)
  //       .get();
  // }
  // TODO:

  //  --------------------------------------------------------------------------- CRUD

  void create(Todo item, BuildContext context) {
    getCollection()
        .doc(generateDocPath(item))
        .set(Todo.toMap(item))
        .whenComplete(() {})
        .catchError((onError) => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).accentColor,
                  content: Text("$onError"),
                );
              },
            ));
    fetchData();
    notifyListeners();
  }

  void update(Todo item, Todo newItem, BuildContext context) {
    getCollection()
        .doc(generateDocPath(item))
        .update(Todo.toMap(newItem))
        .whenComplete(() {})
        .catchError((onError) => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).accentColor,
                  content: Text("$onError"),
                );
              },
            ));
    fetchData();
    notifyListeners();
  }

  void updateIsComplete(Todo item, BuildContext context) {
    getCollection()
        .doc(generateDocPath(item))
        .update({"isCompleted": !item.isCompleted}).catchError(
            (onError) => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Theme.of(context).accentColor,
                      content: Text("$onError"),
                    );
                  },
                ));
    fetchData();
    notifyListeners();
  }

  void remove(Todo item, BuildContext context) {
    getCollection()
        .doc(generateDocPath(item))
        .delete()
        .catchError((onError) => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Theme.of(context).accentColor,
                  content: Text("$onError"),
                );
              },
            ));
    fetchData();
    notifyListeners();
  }

  //  --------------------------------------------------------------------------- UTIL

  void syncListFromFetch() {
    currentList = fetchingList;
  }
}

final todoService = TodoService();
