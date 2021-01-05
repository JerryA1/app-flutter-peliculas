import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:practica2/src/models/trending.dart';
import 'package:practica2/src/models/cast.dart';
import 'package:practica2/src/models/movieVideo.dart';

class ApiMovies{
  final String URL_TRENDING = "https://api.themoviedb.org/3/movie/popular?api_key=c558588392b60d32d4d79e7c8b6f14df&language=en-US&page=1";
  Client http = Client();

  Future<List<Result>> getTrending() async{
    final response = await http.get(URL_TRENDING);
    if (response.statusCode == 200) {
      var movies = jsonDecode(response.body)['results'] as List;
      List<Result> listMovies = movies.map((movie) => Result.fromJSON(movie)).toList();
      // print(movies);
      return listMovies;
    } else{
      return null;
    }
  }

  Future<List<CastElement>> getCastMovie(int movie_id) async{
     final response = await http.get('https://api.themoviedb.org/3/movie/${movie_id}/credits?api_key=c558588392b60d32d4d79e7c8b6f14df&language=en-US');
     if (response.statusCode == 200){
       var cast = jsonDecode(response.body)['cast'] as List;
       List<CastElement> listCast = cast.map((movieCast) => CastElement.fromJSON(movieCast)).toList();
      //  print(listCast);
       return listCast;
     } else {
       return null;
     }
  }

  Future<List<ResultMovie>> getVideos(int movie_id) async{
    final response = await http.get('https://api.themoviedb.org/3/movie/${movie_id}/videos?api_key=c558588392b60d32d4d79e7c8b6f14df&language=en-US');
     if (response.statusCode == 200){
       var cast = jsonDecode(response.body)['results'] as List;
       List<ResultMovie> listVideos = cast.map((movieVideo) => ResultMovie.fromJSON(movieVideo)).toList();
      //  print(listVideos);
       return listVideos;
     } else {
       return null;
     }
  }
}