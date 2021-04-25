import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worknotes/constant.dart';
import 'package:worknotes/service/AuthenticationService.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavigationBar> {
  final FirebaseDatabaseWeb _database = FirebaseDatabaseWeb.instance;

  FirebaseAuth firebaseUser = FirebaseAuth.instance;

  DatabaseRef dbRef;

  String name = "";

  ValueNotifier<String> _workNotifier = ValueNotifier("");

  @override
  void initState() {
    super.initState();
    var id = firebaseUser.currentUser.uid;
    dbRef = _database.reference().child(id).child('name');
    dbRef.once().then((value) {
      name = value.value;
      _workNotifier.value = name;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: kBarColor,
      child: Row(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 80,
                width: 150,
                child: Image.asset('assets/logo.png'),
              ),
            ],
          ),
          Spacer(),
          ValueListenableBuilder<String>(
              valueListenable: _workNotifier,
              builder: (context, works, child) {
                return Text(
                  "Hello, " + name,
                  style:
                  TextStyle(color: kTextColor, fontSize: kTextSize),
                );
              }),
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text(
              'Log Out',
              style: TextStyle(fontSize: kTextSize, color: kTextColor),
            ),
          ),
        ],
      ),
    );
  }
}

