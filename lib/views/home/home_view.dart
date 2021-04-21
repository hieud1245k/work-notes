import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:worknotes/model/WorkModel.dart';
import 'package:worknotes/views/home/work_view_detail.dart';
import 'package:worknotes/widgets/navigation_bar/navigation_bar.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeView> {
  List<WorkModel> works = [];
  DatabaseRef dbRef;

  final TextEditingController _textFieldController = TextEditingController();

  final FirebaseDatabaseWeb _database = FirebaseDatabaseWeb.instance;

  // ignore: deprecated_member_use
  FirebaseAuth firebaseUser = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  T cast<T>(x) => x is T ? x : null;

  @override
  Widget build(BuildContext context) {

    var id = firebaseUser.currentUser.uid;
    dbRef = _database.reference().child(id).child('works');
    dbRef.onChildAdded.listen((event) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WorkViewDetail()));
    });

    WorkModel model1 = WorkModel("title");
    WorkModel model2 = WorkModel("title1");

    works.add(model1);
    works.add(model2);

    dbRef.once().then((value) {
      Map<dynamic, dynamic> resultList = value.value;
      print(resultList);
      print(resultList.values);
      print(resultList.keys);

      resultList.forEach((key, value) {
        print(key);
        print(value);

        var model = cast<WorkModel>(value);
        print(model.title);
      });

    });

    return Scaffold(
      appBar: AppBar(
        title: NavigationBar(),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 100, right: 100, left: 100, bottom: 100),
          child: GridView.count(
            crossAxisCount: 5,
            children: List.generate(works.length, (index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkViewDetail()));
                },
                child: Container(
                  child: Card(
                    color: Colors.grey,
                    child: Center(
                        child: Text(
                      works[index].title,
                      style: TextStyle(fontSize: 28),
                    )),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },
        tooltip: 'Add Work',
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add your work'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter your work title"),
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            // ignore: deprecated_member_use
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                WorkModel workModel =
                    WorkModel(_textFieldController.text.trim());

                dbRef.push().set(workModel.toJson());
              },
            ),
          ],
        );
      },
    );
  }
}
