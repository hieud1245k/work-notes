import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WorkViewDetail extends StatefulWidget {
  @override
  _WorkViewDetailState createState() => _WorkViewDetailState();
}

class _WorkViewDetailState extends State<WorkViewDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBar(
          automaticallyImplyLeading: false,
          title: SizedBox(
            height: 80,
            width: 150,
            child: Image.asset('assets/logo.png'),
          ),
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
          padding: const EdgeInsets.all(100),
          child: Column(
            children: <Widget>[
              Text(
                'Hộp thoại',
                style: TextStyle(color: Colors.red, fontSize: 30),),
              Card(
                  color: Colors.grey,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      maxLines: 20,
                      decoration: InputDecoration.collapsed(
                          hintText: "Enter your text here"),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
