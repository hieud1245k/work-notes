import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:worknotes/constant/Constant.dart';
import 'package:worknotes/service/AuthenticationService.dart';
import 'package:worknotes/views/register/register_view.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
  Widget okButton;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
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
            fit: BoxFit.fill,
          ),
        ),
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
                        // ignore: deprecated_member_use
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
                      // ignore: deprecated_member_use
                      RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          // ignore: deprecated_member_use
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Row(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  Text("Login..."),
                                ],
                              ),
                            ),
                          );
                          context
                              .read<AuthenticationService>()
                              .signIn(email: email, password: password)
                              .then((value) {
                            if (value != Constant.SIGN_IN_SUCCESS) {
                              passwordController.text = "";
                              // ignore: deprecated_member_use
                              _scaffoldKey.currentState.hideCurrentSnackBar();
                              showAlertDialog(context, value);
                            }
                          });
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
