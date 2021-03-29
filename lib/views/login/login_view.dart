import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 130
      ),
      child: Container(
        child: Column(
          children: [
            Image.asset('assets/logo.png'),
            Container(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  onChanged: (text) {
                  },
                ),
              ),
            ),
            Container(
              width: 300,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20
                  ),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 30
                    ),
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text('Register'),
                      elevation: 5.0,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text('Login'),
                    elevation: 5.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
