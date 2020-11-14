import 'package:flutter/material.dart';
import 'package:practica2/src/api/movies.dart';
import 'package:practica2/src/models/trending.dart';
import 'package:practica2/src/views/card_trending.dart';

class Trending extends StatefulWidget {
  Trending({Key key}) : super(key: key);

  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  ApiMovies apiMovies;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiMovies = ApiMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text('Trending Movies c:'),
       ),
       body: FutureBuilder(
         future: apiMovies.getTrending(),
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