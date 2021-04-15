import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:worknotes/service/AuthenticationService.dart';
import 'package:worknotes/views/home/home_view.dart';
import 'package:worknotes/views/register/register_view.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

Future<void> main() async {}

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: SizedBox(
          height: 80,
          width: 150,
          child: Image.asset('assets/logo.png'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 130),
          child: Container(
            child: Column(
              children: [
                Image.asset('assets/logo.png'),
                Container(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                      onChanged: (text) {},
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              icon: Icon(_isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterView()));
                          },
                          child: Text('Register'),
                          elevation: 5.0,
                        ),
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        onPressed: () {

                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          if(checkAccount(email, password)) {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Row(children: <Widget>[
                                CircularProgressIndicator(),
                                Text("Login..."),
                              ],
                              ),
                              ),
                            );

                            context.read<AuthenticationService>().signIn(
                                email: email,
                                password: password);
                          }
                        },
                        child: Text('Login'),
                        elevation: 5.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkAccount(String email, String password) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    if(email.isEmpty) {
      showDialog(context: context, builder: (_) => AlertDialog(
        title: Text("Notice!"),
        content: Text("Email is required?"),
        actions: [
          okButton
        ],
      ));
      return false;
    }

    if(password.isEmpty) {
      showDialog(context: context, builder: (_) =>  AlertDialog(
        title: Text("Notice!"),
        content: Text("Password is required?"),
        actions: [
          okButton
        ],
      ));
      return false;
    }

    if(password.length <= 4 || password.length >= 16) {
      showDialog(context: context, builder: (_) =>  AlertDialog(
        title: Text("Notice!"),
        content: Text("Password must be greater than 4 and least than 16 characters?"),
        actions: [
          okButton
        ],
      ));

      return false;
    }
    return true;
  }
}
