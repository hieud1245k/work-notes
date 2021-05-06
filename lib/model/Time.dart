import 'package:firebase_database/firebase_database.dart';

class Time {
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

  Time.fromJson(Map<String, dynamic> json)
        :day = json["day"],
        month = json["month"],
        year = json["year"],
        hour = json["hour"],
        min = json["min"],
        second = json["second"];

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
