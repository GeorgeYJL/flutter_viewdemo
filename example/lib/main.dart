import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_viewdemo/flutter_viewdemo.dart';
import 'package:flutter_viewdemo/NativeGLWidget.dart';
import 'package:flutter_viewdemo_example/demo.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home:  MyHome()
      home: demoPage(),
    );
  }
}
class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          height: 50,
          width: 100,
          color: Colors.green,
        ),

        NativeGLWidget(300, 300)
      ],),
    );
  }
}