import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:worknotes/model/WorkModel.dart';
import 'package:worknotes/views/home/work_view_detail.dart';
import 'package:worknotes/widgets/navigation_bar/navigation_bar.dart';

List<WorkModel> works = [];

class HomeView extends StatefulWidget {

  HomeView({Key key, @required works}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeView> {
  DatabaseRef dbRef;

  final TextEditingController _textFieldController = TextEditingController();

  final FirebaseDatabaseWeb _database = FirebaseDatabaseWeb.instance;

  // ignore: deprecated_member_use
  FirebaseAuth firebaseUser = FirebaseAuth.instance;

  bool isCheckAddNote = false;
  ValueNotifier<List<WorkModel>> _workNotifier;

  @override
  void initState() {
    super.initState();
    _workNotifier = ValueNotifier([]);
    var id = firebaseUser.currentUser.uid;
    dbRef = _database.reference().child(id).child('works');
    dbRef.onChildAdded.listen((event) {
      if (isCheckAddNote) {
        setState(() {
          isCheckAddNote = false;
          var model = WorkModel.fromJson(event.value, event.key);
          works.add(model);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WorkViewDetail(),
                  settings: RouteSettings(
                    arguments: model,
                  )));
        });
      }
    });
    getValue();
  }

  void getValue() {
    works.clear();
    dbRef.once().then((value) {
      works.clear();
      Map<dynamic, dynamic> resultList = value.value;
      resultList.forEach((key, value) {
        var model = WorkModel.fromJson(value , key);
        works.add(model);
        _workNotifier.value = works;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: ValueListenableBuilder<List<WorkModel>>(
            valueListenable: _workNotifier,
            builder: (context, works, child) {
              return GridView.count(
                crossAxisCount: 5,
                children: List.generate(works.length, (index) {
                  return GestureDetector(
                    onTap: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkViewDetail(),
                              settings: RouteSettings(
                                arguments: works[index],
                              ))).then((value) {
                                setState(() {
                        getValue();
                                });
                      });
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
              );
            },
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
                setState(() {
                  isCheckAddNote = true;
                });
                Navigator.pop(context);
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
