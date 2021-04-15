import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:worknotes/service/AuthenticationService.dart';
import 'package:worknotes/views/home/home_view.dart';
import 'package:worknotes/views/register/register_view.dart';
import 'package:provider/provider.dart';

Future<void> main() async {

}

class LoginView extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
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
                          log('username'+ emailController.text.trim());
                          log('pwd' + passwordController.text.trim());
                          context.read<AuthenticationService>().signIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim()
                          );
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
}
