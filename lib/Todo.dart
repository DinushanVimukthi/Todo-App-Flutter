
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/login.dart';

import 'Data/loginData.dart';




class Todo {
  late String? title;
  late String description;
  late bool isDone;
  late String? key;

  Todo({
    required this.title,
    required this.description,
    required this.isDone,
    required this.key,
  });

  static createEmptyTodo() {
    return Todo(
      title: '',
      description: '',
      isDone: false,
      key: UniqueKey().toString(),
    );
  }

  Object toJson() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  static addNewTodo(Todo todo) async{
    User user = await LoginData.getLoggedUser();
    if (user == null) {
      return;
    }
    String uid = user.uid;

    FirebaseDatabase.instance
        .ref()
        .child('todos')
        .child(uid)
        .push()
        .set(todo.toJson());
  }

  static updateTodo (Todo todo) async {
    User user = await LoginData.getLoggedUser();
    if (user == null) {
      return;
    }
    String uid = user.uid;
    FirebaseDatabase.instance
        .ref()
        .child('todos')
        .child(uid)
        .child(todo.key!)
        .set(todo.toJson());
  }

  static deleteTodo (Todo todo) async {
    User user = await LoginData.getLoggedUser();
    if (user == null) {
      return;
    }
    String uid = user.uid;
    FirebaseDatabase.instance
        .ref()
        .child('todos')
        .child(uid)
        .child(todo.key!)
        .remove();
  }

  static Todo fromSnapshot(DataSnapshot snapshot) {
    Map data = snapshot.value as Map;
    return Todo(
      title: data['title'],
      description: data['description'],
      isDone: data['isDone'],
      key: snapshot.key,
    );
  }


}