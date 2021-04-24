import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:worknotes/model/Time.dart';

class WorkModel {
  String key;
  String title;
  String content;
  // Time createdDate = Time();
  // Time modifiedDate = Time();
  bool isDelete = false;

  WorkModel(this.title, {this.key});


  WorkModel.fromJson(Map<String, dynamic> json, dynamic key)
      : key = key,
        title = json["title"],
        content = json["content"],
        // createdDate = json["createdDate"],
        // modifiedDate = json["ModifiedDate"],
        isDelete = json["isDelete"];
  
  toJson() {
    return {
      "title": title,
      "content": content,
      // "createdDate": createdDate.toJson(),
      // "ModifiedDate": modifiedDate.toJson(),
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
