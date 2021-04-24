import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firebase.dart';


//Replace These Values With Yours
class FirebaseHelper  {
  static fb.Database initDatabase() {
    try {
      if (fb.apps.isEmpty) {
        fb.initializeApp(
            apiKey: "AIzaSyCtcA99Zw0wWVvcUX-hXORHHP55YOnJVVE",
            authDomain: "work-notes-2e24e.firebaseapp.com",
            databaseURL: "https://work-notes-2e24e-default-rtdb.firebaseio.com",
            projectId: "work-notes-2e24e",
            storageBucket: "work-notes-2e24e.appspot.com",
            messagingSenderId: "632265484002",
            appId: "1:632265484002:web:7784dea4fdd7b0492160bb",
            measurementId: "G-X67B53QYZE"
        );
      }
    } on fb.FirebaseJsNotLoadedException catch (e) {
      print(e);
    }
    return fb.database();
  }
}

class fire{
  static fb.Database database = FirebaseHelper.initDatabase();
}


Future<String> getOnce(fb.DatabaseReference AdsRef) async {
  String a;
  await AdsRef.once('value').then((value) => {a = value.snapshot.val()});
  return a;
}

Future<List> getList(fb.DatabaseReference AdsRef) async {
  List list = [""];
  await AdsRef.once('value').then((value) => {
    list = result(value.snapshot, list)
  });
  return list;
}

List result(DataSnapshot dp,List list){
  list.clear();
  dp.forEach((v) {
    list.add(v);
  });
  return list;
}

