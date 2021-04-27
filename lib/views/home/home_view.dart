import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
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

  //----------------------------------------------------------------------------------------------------------------------//
  //_getValue
  //----------------------------------------------------------------------------------------------------------------------//
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
              onPressed: _workCompleted,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 40),
            child: IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: Colors.black54,
              ),
              onPressed: _workFavorite,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 40),
            child: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.black54,
              ),
              // onPressed: ,
            ),
          ),
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
                  return _buildWorkRow(works[i]);
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addWorkDialog(context);
        },
        tooltip: 'Add Work',
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------------------------------------------------//
  //_buildWorkRow
  //----------------------------------------------------------------------------------------------------------------------//
  Widget _buildWorkRow(WorkModel work) {
    return Column(
      children: [
        ListTile(
          title: Container(
            margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            decoration: BoxDecoration(color: kBoxColor, borderRadius: BorderRadius.circular(kBoderRadius), boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 10),
              )
            ]),
            child: Row(
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
                            color: kTitleColor, fontSize: kTitleSize, fontWeight: FontWeight.bold,
                          decoration: work.isCheck ? TextDecoration.lineThrough : null,
                          decorationColor: Colors.black,
                          decorationStyle: TextDecorationStyle.wavy,
                          decorationThickness: 1.0,
                            ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          work.createdDate.toString(),
                          style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic, fontSize: kTitleSize * 2 / 3),
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),

                //------------------------------------------------------------------------------------------------------------//
                //_Check_Work_Completed
                //------------------------------------------------------------------------------------------------------------//
                Container(
                  margin: const EdgeInsets.only(right: 25),
                  child: FlatButton(
                    padding: const EdgeInsets.all(20),
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
                      dbRef.child(work.key).child("isCheck").set(!work.isCheck).then((value) {
                        setState(() {
                          work.isCheck = !work.isCheck;
                        });
                      });
                    },
                  ),
                ),


                //------------------------------------------------------------------------------------------------------------//
                //_Check_Work_Favorite
                //------------------------------------------------------------------------------------------------------------//
                Container(
                  margin: const EdgeInsets.only(right: 25),
                  child: FlatButton(
                    padding: const EdgeInsets.all(20),
                    minWidth: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      work.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: work.isFavorite ? Colors.redAccent.withOpacity(0.8) : null,
                      size: 30,
                    ),
                    onPressed: () {
                      dbRef.child(work.key).child("isFavorite").set(!work.isFavorite).then((value) {
                        setState(() {
                          work.isFavorite = !work.isFavorite;
                        });
                      });
                    },
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
        ),
        Divider(),
      ],
    );
  }

  //----------------------------------------------------------------------------------------------------------------------//
  //_workCompleted
  //----------------------------------------------------------------------------------------------------------------------//
  void _workCompleted() {
    final _listWorkCompleted = <WorkModel>{};
    works.forEach((element) {
      if (element.isCheck) _listWorkCompleted.add(element);
    });
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _listWorkCompleted.map(
        (WorkModel work) {
          return ListTile(
            title: Container(
              margin: const EdgeInsets.fromLTRB(20, 15, 20, 5),
              decoration: BoxDecoration(color: kBoxColor, borderRadius: BorderRadius.circular(kBoderRadius), boxShadow: [
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
                          style: TextStyle(color: kTitleColor, fontSize: kTitleSize, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Text(
                            work.createdDate.toString(),
                            style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic, fontSize: kTitleSize * 2 / 3),
                          ),
                        ),


                        //-----------------------------------------------------------------------------------------------------//
                        //_unTick_Work_Completed
                        //-----------------------------------------------------------------------------------------------------//
                        Container(
                          margin: const EdgeInsets.only(right: 25),
                          child: FlatButton(
                            padding: const EdgeInsets.all(20),
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
                              _unTickDialog(context, work);
                            },
                          ),
                        ),
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

//----------------------------------------------------------------------------------------------------------------------//
  //_workFavorite
  //----------------------------------------------------------------------------------------------------------------------//
  void _workFavorite() {
    final _listWorkFavorite = <WorkModel>{};
    works.forEach((element) {
      if (element.isFavorite) _listWorkFavorite.add(element);
    });
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _listWorkFavorite.map(
        (WorkModel work) {
          return ListTile(
            title: Container(
              margin: const EdgeInsets.fromLTRB(20, 15, 20, 5),
              decoration: BoxDecoration(color: kBoxColor, borderRadius: BorderRadius.circular(kBoderRadius), boxShadow: [
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
                          style: TextStyle(color: kTitleColor, fontSize: kTitleSize, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Text(
                            work.createdDate.toString(),
                            style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic, fontSize: kTitleSize * 2 / 3),
                          ),
                        ),


                        //-----------------------------------------------------------------------------------------------------//
                        //_unFavorite_Work
                        //-----------------------------------------------------------------------------------------------------//
                        Container(
                          margin: const EdgeInsets.only(right: 25),
                          child: FlatButton(
                            padding: const EdgeInsets.all(20),
                            minWidth: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              work.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: work.isFavorite ? Colors.redAccent.withOpacity(0.8) : null,
                              size: 30,
                            ),
                            onPressed: () {
                              _unFavoriteDialog(context, work);
                            },
                          ),
                        ),
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

  //----------------------------------------------------------------------------------------------------------------------//
  //_addWorkDialog
  //----------------------------------------------------------------------------------------------------------------------//
  Future<void> _addWorkDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add your work',
            style: TextStyle(fontSize: kTitleSize, color: Colors.blue),
          ),
          content: Container(
            child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter your work title", hintStyle: TextStyle(color: kHintTextColor)),
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
                WorkModel workModel = WorkModel(_textFieldController.text.trim());
                dbRef.push().set(workModel.toJson());
              },
            ),
          ],
        );
      },
    );
  }

  //----------------------------------------------------------------------------------------------------------------------//
  //_unFavoriteDialog
  //----------------------------------------------------------------------------------------------------------------------//
  Future<void> _unFavoriteDialog(BuildContext context, WorkModel work) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Notice',
            style: TextStyle(color: Colors.red),
          ),
          content: Text("Are you sure you want un-favorite this work?"),
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
                dbRef.child(work.key).child("isFavorite").set(!work.isFavorite).then((value) {
                  setState(() {
                    work.isFavorite = !work.isFavorite;
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }


  //----------------------------------------------------------------------------------------------------------------------//
  //_unTickDialog
  //----------------------------------------------------------------------------------------------------------------------//
  Future<void> _unTickDialog(BuildContext context, WorkModel work) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Notice',
            style: TextStyle(color: Colors.red),
          ),
          content: Text("Are you sure you want un-tick this work?"),
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
                dbRef.child(work.key).child("isCheck").set(!work.isCheck).then((value) {
                  setState(() {
                    work.isCheck = !work.isCheck;
                  });
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
