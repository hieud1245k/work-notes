import 'package:worknotes/model/Time.dart';

class WorkModel {
  String key;
  String title;
  String content;
  bool isCheck = false;
  bool isFavorite = false;
  Time createdDate = Time();
  Time modifiedDate = Time();
  bool isDelete = false;

  WorkModel(this.title, {this.key});

  WorkModel.fromJson(Map<String, dynamic> json, dynamic key)
      : key = key,
        title = json["title"],
        content = json["content"],
        createdDate = Time.fromJson(json["createdDate"]),
        modifiedDate = Time.fromJson(json["modifiedDate"]),
        isCheck = json["isCheck"],
        isFavorite = json["isFavorite"],
        isDelete = json["isDelete"];
  
  toJson() {
    return {
      "title": title,
      "content": content,
      "createdDate": createdDate.toJson(),
      "isCheck": isCheck,
      "modifiedDate": modifiedDate.toJson(),
      "isFavorite": isFavorite,
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
