import 'package:flutter/material.dart';
import 'package:news_app/homepage.dart';

void main() => runApp(StartApp());

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "News App",
      home: HomePage(),
      theme: new ThemeData(primarySwatch: Colors.cyan),
      debugShowCheckedModeBanner: false,
    );
  }
}
