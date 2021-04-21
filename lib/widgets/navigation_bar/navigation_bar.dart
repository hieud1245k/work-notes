import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worknotes/FirebaseCustom.dart';
import 'package:worknotes/service/AuthenticationService.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavigationBar> {
  FirebaseAuth firebaseUser = FirebaseAuth.instance;
  String name = "";
  var database = fire.database;

  @override
  Widget build(BuildContext context) {
    @override
    Widget build(BuildContext context) {
      return Container(
        height: 100,
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 80,
              width: 150,
              child: Image.asset('assets/logo.png'),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _NarBarItem("Home"),
              ],
            ),
            // ignore: deprecated_member_use
            Container(
              padding: const EdgeInsets.only(right: 50),
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  FlatButton(
                    onPressed: () {
                      context.read<AuthenticationService>().signOut();
                    },
                    child: Text('Return Login'),
                  ),
                  Text("Xin chào " + name),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<String> getValueA() async {
    var id = firebaseUser.currentUser.uid;

    database.ref(id).onValue.listen((event) {
      var datasnapshot = event.snapshot;

      String n = datasnapshot.child("name").val();

      setState(() {
        name = n;
      });
    });
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
