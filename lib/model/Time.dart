import 'package:firebase_database/firebase_database.dart';

class Time {
  String key;
  int year;
  int month;
  int day;
  int hour;
  int min;
  int second;

  Time() {
    DateTime dt = DateTime.now();
    year = dt.year;
    month = dt.month;
    day = dt.day;
    hour = dt.hour;
    min = dt.minute;
    second = dt.second;
  }

  Time.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        year = snapshot.value["title"],
        month = snapshot.value["content"],
        day = snapshot.value["createdDate"],
        hour = snapshot.value["ModifiedDate"],
        min = snapshot.value["isDelete"],
        second = snapshot.value["isDelete"];

  toJson() {
    return {
      "year": year,
      "month": month,
      "day": day,
      "hour": hour,
      "min": min,
      "second": second
    };
  }
}
