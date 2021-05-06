import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:worknotes/constant.dart';
import 'package:worknotes/model/WorkModel.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import 'package:worknotes/service/AuthenticationService.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class WorkViewDetail extends StatefulWidget {
  @override
  _WorkViewDetailState createState() {
    return _WorkViewDetailState();
  }
}

class _WorkViewDetailState extends State<WorkViewDetail> {
  DatabaseRef dbRef;

  WorkModel workModel;

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final FirebaseDatabaseWeb _database = FirebaseDatabaseWeb.instance;

  // ignore: deprecated_member_use
  FirebaseAuth firebaseUser = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    var id = firebaseUser.currentUser.uid;
    dbRef = _database.reference().child(id).child('works');
  }

  @override
  Widget build(BuildContext context) {
    workModel = ModalRoute.of(context).settings.arguments;

    if (workModel.content != null && workModel.content.isNotEmpty) _contentController.text = workModel.content.toString();
    _titleController.text = workModel.title.toString();

    return Scaffold(
      appBar: AppBar(
        title: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              SizedBox(
                height: 80,
                width: 150,
                child: Image.asset('assets/logo.png'),
              ),
              Spacer(),
              // Container(
              //   margin: EdgeInsets.only(right: 40, top: 15, bottom: 15),
              //   child: FlatButton(
              //     onPressed: () {
              //       context.read<AuthenticationService>().signOut();
              //       Navigator.pop(context);
              //     },
              //     child: Text(
              //       'Log Out',
              //       style: TextStyle(fontSize: kTextSize, color: kTextColor),
              //     ),
              //   ),
              //   decoration: BoxDecoration(
              //     color: Colors.white60.withOpacity(0.1),
              //     borderRadius: BorderRadius.circular(5),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 70, left: 70, bottom: 10),
            child: Stack(children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 15, left: 35),
                        padding: EdgeInsets.all(6),
                        height: 40,
                        child: Text(
                          workModel.title.toString(),
                          style: TextStyle(color: kTitleColor, fontSize: kTitleSize, fontWeight: FontWeight.bold),
                        ),
                        decoration:
                            BoxDecoration(color: kBoxColor, borderRadius: BorderRadius.circular(kBoderRadius / 2), boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 5),
                          )
                        ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 25, top: 10, left: 20),
                        child: FlatButton(
                          padding: const EdgeInsets.all(0.0),
                          minWidth: 5,
                          color: Colors.grey.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 25,
                            color: Colors.black87.withOpacity(0.6),
                          ),
                          onPressed: () {
                            _editTitleDialog(context, _titleController);
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(25, 3, 0, 3),
                    child: Text(
                      workModel.createdDate.day.toString() +
                          " - " +
                          workModel.createdDate.month.toString() +
                          " - " +
                          workModel.createdDate.year.toString() +
                          ", " +
                          workModel.createdDate.hour.toString() +
                          ": " +
                          workModel.createdDate.min.toString(),
                      style: TextStyle(color: Colors.black54, fontStyle: FontStyle.italic, fontSize: kTitleSize * 2 / 3),
                    ),
                  ),
                  Card(
                    color: kBoxColor,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _contentController,
                          style: TextStyle(fontSize: kTextSize, color: kTextColor),
                          maxLines: 20,
                          decoration: InputDecoration.collapsed(hintText: "Empty Content"),
                        ),
                      ),
                      decoration: BoxDecoration(color: kBoxColor, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 4),
                        )
                      ]),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 35, 45, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: RaisedButton(
                        onPressed: () {
                          dbRef
                              .child(workModel.key)
                              .child('content')
                              .set(_contentController.text.toString().trim())
                              .catchError((onError) {});
                          Toast.show(
                            "Update content success!",
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM,
                          );
                        },
                        child: Text('Save'),
                      ),
                      decoration: BoxDecoration(color: kBoxColor, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 5),
                        )
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: RaisedButton(
                        onPressed: () {
                          _deleteWorkDialog(context);
                        },
                        child: Text('Delete'),
                      ),
                      decoration: BoxDecoration(color: kBoxColor, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 5),
                        )
                      ]),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }


  //----------------------------------------------------------------------------------------------------------------------//
  //_deleteWorkDialog
  //----------------------------------------------------------------------------------------------------------------------//
  Future<void> _deleteWorkDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Notice',
            style: TextStyle(color: Colors.red),
          ),
          content: Text("Are you sure you want to delete this work note?"),
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
                dbRef.child(workModel.key).remove();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  //----------------------------------------------------------------------------------------------------------------------//
  //_editTitleDialog
  //----------------------------------------------------------------------------------------------------------------------//
  Future<void> _editTitleDialog(BuildContext context, TextEditingController title) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Title',
            style: TextStyle(color: kTitleColor, fontSize: kTitleSize, fontWeight: FontWeight.bold),
          ),
          content: Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            height: 50,
            width: 400,
            child: TextField(
              controller: title,
              style: TextStyle(fontSize: kTextSize, color: kTextColor),
              decoration: InputDecoration.collapsed(hintText: "Enter Title Content"),
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
              child: Text('SAVE'),
              onPressed: () {
                dbRef.child(workModel.key).child("title").set(title.text.toString().trim()).then((value) {
                  setState(() {
                    workModel.title = title.text.toString().trim();
                  });
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
