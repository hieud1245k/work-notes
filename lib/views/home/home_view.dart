import 'dart:html';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:worknotes/constant.dart';
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

  final _saved = <WorkModel>{};

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
                  ))).then((value) {
            setState(() {
              getValue();
            });
          });
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
        var model = WorkModel.fromJson(value, key);
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
        actions: [
          Container(
            margin: EdgeInsets.only(right: 40),
            child: IconButton(
              icon: Icon(
                Icons.check_box,
                color: Colors.black87,
              ),
              onPressed: _pushSaved,
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: kBackgroundColor),
        child: ValueListenableBuilder<List<WorkModel>>(
          valueListenable: _workNotifier,
          builder: (context, value, child) {
            return ListView.builder(
                itemCount: works.length,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, i) {
                  return _buildRow(works[i]);
                });
          },
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

  Widget _buildRow(WorkModel work) {
    return Column(
      children: [
        ListTile(
          title: Container(
            margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            decoration: BoxDecoration(
                color: kBoxColor,
                borderRadius: BorderRadius.circular(kBoderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 10),
                  )
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        work.title,
                        style: TextStyle(
                            color: kTitleColor,
                            fontSize: kTitleSize,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          work.createdDate.toString(),
                          style: TextStyle(
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                              fontSize: kTitleSize * 2 / 3),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 25),
                  child: FlatButton(
                    padding: const EdgeInsets.all(0.0),
                    minWidth: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      work.isCheck ? Icons.check_box : Icons.check_box_outlined,
                      color: work.isCheck ? Colors.black45 : Colors.black26,
                      size: 30,
                    ),
                    onPressed: () {
                      dbRef
                          .child(work.key)
                          .child("isCheck")
                          .set(!work.isCheck)
                          .then((value) {
                        setState(() {
                          work.isCheck = !work.isCheck;
                        });
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WorkViewDetail(),
                    settings: RouteSettings(
                      arguments: work,
                    ))).then((value) {
              setState(() {
                getValue();
              });
            });
          },
        ),
        Divider(),
      ],
    );
  }

  void _pushSaved() {
    works.forEach((element) {
      if (element.isCheck) _saved.add(element);
    });
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _saved.map(
        (WorkModel work) {
          return ListTile(
            title: Container(
              margin: const EdgeInsets.fromLTRB(20, 15, 20, 5),
              decoration: BoxDecoration(
                  color: kBoxColor,
                  borderRadius: BorderRadius.circular(kBoderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 10),
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          work.title,
                          style: TextStyle(
                              color: kTitleColor,
                              fontSize: kTitleSize,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Text(
                            work.createdDate.toString(),
                            style: TextStyle(
                                color: Colors.black54,
                                fontStyle: FontStyle.italic,
                                fontSize: kTitleSize * 2 / 3),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WorkViewDetail(),
                      settings: RouteSettings(
                        arguments: work,
                      ))).then((value) {
                setState(() {
                  getValue();
                });
              });
            },
          );
        },
      );
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 0),
                child: SizedBox(
                  height: 80,
                  width: 150,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
            ],
          ),
          titleTextStyle: TextStyle(color: kTitleColor, fontSize: kTitleSize),
          backgroundColor: kBarColor,
        ),
        body: ListView(
          children: divided,
        ),
      );
    }));
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add your work',
            style: TextStyle(
                fontSize: kTitleSize,
                color: kTitleColor,
                fontWeight: FontWeight.bold),
          ),
          content: Container(
            child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter your work title"),
              style: TextStyle(fontSize: kTextSize, color: kTextColor),
            ),
            decoration: BoxDecoration(color: kBoxColor, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 5),
              )
            ]),
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
