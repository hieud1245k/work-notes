import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:worknotes/model/Time.dart';

class WorkModel {
  String key;
  String title;
  String content;
  Time createdDate = Time();
  Time modifiedDate = Time();
  bool isDelete = false;

  WorkModel(this.title);

  WorkModel.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value["title"],
        content = snapshot.value["content"],
        createdDate = snapshot.value["createdDate"],
        modifiedDate = snapshot.value["ModifiedDate"],
        isDelete = snapshot.value["isDelete"];

  toJson() {
    return {
      "title": title,
      "content": content,
      "createdDate": createdDate.toJson(),
      "ModifiedDate": modifiedDate.toJson(),
      "isDelete": isDelete
    };
  }
}

dynamic myEncode(dynamic item) {
  if (item is DateTime) {
    return item.toIso8601String();
  }
  return item;
}
