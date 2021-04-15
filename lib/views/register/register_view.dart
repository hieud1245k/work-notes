import 'package:flutter/material.dart';
import 'package:worknotes/views/login/login_view.dart';
import 'package:worknotes/widgets/navigation_bar/navigation_bar.dart';
import 'package:worknotes/service/AuthenticationService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {}

class RegisterView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm password',
                        ),
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
                              Navigator.pop(context);
                            },
                            child: Text('Back'),
                            elevation: 5.0,
                          ),
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          onPressed: () async {
                            if (emailController.text.isEmpty)
                            {
                              showAlertDialog(context, "Please enter Email.");
                            }
                            else if (passwordController.text.isEmpty)
                            {
                              showAlertDialog(context, "Please enter Password.");
                            }
                            else if (confirmPasswordController.text.isEmpty)
                            {
                              showAlertDialog(context, "Please enter ConfirmPassword.");
                            }
                            else if (passwordController.text ==
                                confirmPasswordController.text) {
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: emailController.text.trim(),
                                            password: passwordController.text.trim());
                                Navigator.pop(context);
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  showAlertDialog(context, "The password provided is too weak.");
                                } else if (e.code == 'email-already-in-use') {
                                  showAlertDialog(context, "The account already exists for that email.");
                                }
                              } catch (e) {
                                showAlertDialog(context, e);
                              }
                            } else {
                              showAlertDialog(context, "Password and ConfirmPassword must same.");
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

  showAlertDialog(BuildContext context, String contend) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      textColor: Colors.redAccent,
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text(contend),
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
