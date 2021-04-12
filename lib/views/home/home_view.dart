import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:worknotes/views/home/work_view_detail.dart';
import 'package:worknotes/widgets/navigation_bar/navigation_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: NavigationBar(),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 100, right: 100, left: 100, bottom: 100),
          child: GridView.count(
            crossAxisCount: 5,
            children: List.generate(20, (index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkViewDetail()));
                },
                child: Container(
                  child: Card(
                    color: Colors.grey,
                    child: Center(
                        child: Text(
                      'Tên hộp thoại $index',
                      style: TextStyle(fontSize: 28),
                    )),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },
        tooltip: 'Add Work',
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

TextEditingController _textFieldController = TextEditingController();

Future<void> _displayTextInputDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add your work'),
        content: TextField(
          controller: _textFieldController,
          decoration: InputDecoration(hintText: "Enter your work title"),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              print(_textFieldController.text);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}