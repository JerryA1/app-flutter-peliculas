import 'package:flutter/material.dart';
import 'package:practica2/src/screen/favorites.dart';
import 'package:practica2/src/screen/login.dart';
import 'package:practica2/src/screen/profile.dart';
import 'package:practica2/src/screen/search.dart';
import 'package:practica2/src/screen/trending.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/trending': (BuildContext context) => Trending(),
        '/search': (BuildContext context) => Search(),
        '/favorites': (BuildContext context) => Favorites(),
        '/profile': (BuildContext context) => Profile(),
        '/login': (BuildContext context) => Login(),
      },
      home: Login(),
    );
  }
}