import 'dart:io';
import 'package:flutter/material.dart';
import 'package:practica2/src/database/database_helper.dart';
import 'package:practica2/src/models/trending.dart';
import 'package:practica2/src/views/card_trending.dart';

class Favorites extends StatefulWidget {
  Favorites({Key key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  DataBaseHelper _database;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _database = DataBaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    // DataBaseHelper _database = DataBaseHelper();
    // Future<Result> _objFavs = _database.getFavs();

    return Scaffold(
       appBar: AppBar(
         title: Text('Favorites'),
       ),
       body: FutureBuilder(
         future: _database.getFavs(),
         builder: (BuildContext context, AsyncSnapshot<List<Result>> snapshot){
           if (snapshot.hasError) {
             return Center(
               child: Text("Has error in request :c"),
             );
           } else if(snapshot.connectionState == ConnectionState.done){
             return _listTrending(snapshot.data);
           } else{
             return Center(
               child: CircularProgressIndicator(),
             );
           }
         }
       ),
    );
  }

  Widget _listTrending(List<Result> movies){
  return ListView.builder(
    itemBuilder: (context, index){
      Result trending = movies[index];
      return CardTrending(trending: trending);
    },
    itemCount: movies.length,
  );
}
}