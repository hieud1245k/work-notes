import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worknotes/constant/Constant.dart';
import 'package:worknotes/service/AuthenticationService.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class RegisterView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterViewPage();
  }
}

class _RegisterViewPage extends State<RegisterView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  var _isObscure = true;

  @override
  void initState() {
    super.initState();
  }

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
                  fit: BoxFit.fill)),
          child: Center(
            child: Container(
              child: Column(
                children: [
                  Image.asset('assets/logo.png'),
                  Container(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: nickNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nick Name',
                        ),
                        onChanged: (text) {},
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
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
                  Container(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextField(
                        controller: confirmPasswordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Confirm Password',
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
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Back'),
                            elevation: 5.0,
                          ),
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            if (nickNameController.text.trim().isEmpty) {
                              showAlertDialog(context, "Nick name is required!");
                            } else if (!emailController.text
                                .toString()
                                .trim()
                                .isValidEmail()) {
                              showAlertDialog(context, "Email format is incorrect!");
                            } else if (passwordController.text !=
                                confirmPasswordController.text) {
                              showAlertDialog(context,
                                  "Password and ConfirmPassword must same.");
                            } else {
                              // ignore: deprecated_member_use
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: <Widget>[
                                      CircularProgressIndicator(),
                                      Text("Register..."),
                                    ],
                                  ),
                                ),
                              );

                              context
                                  .read<AuthenticationService>()
                                  .signUp(
                                      email: emailController.text.toString(),
                                      password:
                                          passwordController.text.toString())
                                  .then((value) {
                                if (value != Constant.SIGN_UP_SUCCESS) {
                                  passwordController.text = "";
                                  confirmPasswordController.text = "";
                                  // ignore: deprecated_member_use
                                  _scaffoldKey.currentState
                                      // ignore: deprecated_member_use
                                      .hideCurrentSnackBar();
                                  showAlertDialog(context, value);
                                } else {
                                  var id =
                                      FirebaseAuth.instance.currentUser.uid;
                                  FirebaseDatabaseWeb.instance
                                      .reference()
                                      .child(id)
                                      .child("name")
                                      .set(nickNameController.text.toString());
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                          child: Text('Register'),
                          elevation: 5.0,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  showAlertDialog(BuildContext context, String content) {
    // ignore: deprecated_member_use
    Widget okButton = FlatButton(
      child: Text("OK"),
      textColor: Colors.redAccent,
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text(content),
      backgroundColor: Color.fromARGB(220, 117, 218, 255),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
