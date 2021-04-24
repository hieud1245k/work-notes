import 'dart:collection';

import 'package:worknotes/model/WorkModel.dart';

class UserModel {
  String name;
  DateTime birthday;
  String phoneNumber;
  HashMap<String, WorkModel> works;
}
