import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:worknotes/model/WorkModel.dart';
import 'package:toast/toast.dart';

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

    workModel = ModalRoute
        .of(context)
        .settings
        .arguments;

    if (workModel.content != null && workModel.content.isNotEmpty)
      _contentController.text = workModel.content.toString();

    return Scaffold(
      appBar: AppBar(
        title: AppBar(
          automaticallyImplyLeading: false,
          title: SizedBox(
            height: 80,
            width: 150,
            child: Image.asset('assets/logo.png'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 100, right: 100, left: 100, bottom: 100),
            child: Stack(children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    workModel.title.toString(),
                    style: TextStyle(color: Colors.red, fontSize: 30),
                  ),
                  Card(
                      color: Colors.grey,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _contentController,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          maxLines: 20,
                          decoration: InputDecoration.collapsed(
                              hintText: "Enter your text here"),
                        ),
                      ))
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ignore: deprecated_member_use
                    RaisedButton(
                      onPressed: () {
                        dbRef
                            .child(workModel.key)
                            .child('content')
                            .set(_contentController.text.toString().trim()).catchError((onError) {
                        });
                        Toast.show("Update content success!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                      },
                      child: Text('Save'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () {

                          _displayTextInputDialog(context);


                        },
                        child: Text('Delete'),
                      ),
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

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notice'),
          content: Text("Are you sure you want to delele this work note?"),
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
                dbRef
                    .child(workModel.key).remove();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
