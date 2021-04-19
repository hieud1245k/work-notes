import 'package:flutter/material.dart';
import 'package:worknotes/service/AuthenticationService.dart';
import 'package:worknotes/views/login/login_view.dart';
import 'package:provider/provider.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({Key key}) : super(key: key);

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
              padding: const EdgeInsets.only(
                  right: 50
              ),
              alignment: Alignment.centerRight,
              child: RaisedButton(
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                },
                child: Text('Return Login'),
                elevation: 5.0,
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
