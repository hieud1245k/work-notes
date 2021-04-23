import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              _NarBarItem("Home"),
            ],
          ),
          Spacer(),
          Container(
            padding: const EdgeInsets.only(right: 50),
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                ValueListenableBuilder<String>(
                    valueListenable: _workNotifier,
                    builder: (context, works, child) {
                  return Text("Xin chào, " + name);
                }),
                // ignore: deprecated_member_use
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20
                  ),
                  child: FlatButton(
                    onPressed: () {
                      context.read<AuthenticationService>().signOut();
                    },
                    child: Text('Logout' , style:  TextStyle(fontSize: 18, color: Colors.black),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NarBarItem extends StatelessWidget {
  final String title;

  const _NarBarItem(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 18),
    );
  }
}
