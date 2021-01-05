import 'package:flutter/material.dart';
import 'package:practica2/src/api/movies.dart';
import 'package:practica2/src/database/database_helper.dart';
import 'package:practica2/src/models/cast.dart';
import 'package:practica2/src/models/movieVideo.dart';
import 'package:practica2/src/models/trending.dart';
import 'package:practica2/src/screen/dashboard.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:expandable/expandable.dart';

class DetailMovie extends StatefulWidget {
  DetailMovie({Key key}) : super(key: key);

  @override
  _DetailMovieState createState() => _DetailMovieState();
}

class _DetailMovieState extends State<DetailMovie> {
  DataBaseHelper _database;
  ApiMovies apiMovies;
  String videoURL = "https://www.youtube.com/watch?v=sfM7_JLk-84";
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _database = DataBaseHelper();
    apiMovies = ApiMovies();
  }

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie: ${movie['title']}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MovieDetailHeader(pelicula: movie, screen: screenWidth),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Storyline(pelicula: movie),
            ),
            // PhotoScroller(movie.photoUrls),
            SizedBox(height: 20.0),
            ActorScroller(movie_id: movie['id']),
            SizedBox(height: 50.0),
          ],
        ),
      )
    );
  }

  Widget MovieDetailHeader({pelicula, screen}){
    Future<Result> _objMovie = _database.getMovie(pelicula['id']);

    var numericRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.star,
              color: Colors.amberAccent[400],
            ),
            Text(
              '${pelicula['voteAverage']}',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.deepOrangeAccent,
                fontSize: 20.0
              ),
            ),
          ]
        ),
        SizedBox(height: 4.0),
        Text(
          'Ratings',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );

    final favBtn = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Color.fromRGBO(255, 255, 255, 1),
      child: Row( // Add a Row Widget for placing objects.
        mainAxisAlignment: MainAxisAlignment.center, // Center the Widgets.
        mainAxisSize: MainAxisSize.max, // Use all of width in RaisedButton.
        children: <Widget>[
          Icon(
            Icons.favorite_border,
            color: Colors.blueAccent,
          ),
        ],
      ),     
      onPressed: (){
        _objMovie.then((result) {
          // print(result);
          if (result != null) {
            print('Eliminar fav');
            _database.eliminar(pelicula['id'], 'tbl_favorites').then((rows) => {
              print('$rows')
            });
            
          } else{
            print('Añadir fav');
            Result movieFav = Result(
              id: pelicula['id'],
              popularity: pelicula['popularity'],
              voteCount: pelicula['voteCount'],
              posterPath: pelicula['posterPath'],
              backdropPath: pelicula['backdropPath'],
              title: pelicula['title'],
              voteAverage: pelicula['voteAverage'],
              overview: pelicula['overview'],
              releaseDate: pelicula['releaseDate']
            );
            // print(movieFav.toJSON());
            _database.insertar(movieFav.toJSON(), 'tbl_favorites').then((rows) => {
              print('$rows')
            });
          }
          setState(() {
            
          });
        });

        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (BuildContext context) => Dashboard()), 
          ModalRoute.withName('/login')
        );
        
        // print('Guardar fav');
      }
    );

    var favorites = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: <Widget>[
            favBtn
          ]
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 4.0),
          child:
            FutureBuilder(
              future: getTextFav(_objMovie),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.hasData){
                  return Text('${snapshot.data}');
                }
                return Container();
              },
            ) 
          // Text(
          //   '${textFav}',
          //   style: TextStyle(color: Colors.black54),
          // ),
        ),
      ],
    );

  var movieInformation = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '${pelicula['title']}',
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(height: 8.0),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          numericRating,
          SizedBox(width: 16.0),
          favorites,
        ],
      ),
      SizedBox(height: 12.0),
      // Row(children: _buildCategoryChips()),
    ],
  );

  return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 140.0),
          child: Stack(
            children: <Widget>[
              ExpandableNotifier(  // <-- Provides ExpandableController to its children
                child: Column(
                  children: [
                    Expandable(           // <-- Driven by ExpandableController from ExpandableNotifier
                      collapsed: ExpandableButton(  // <-- Expands when tapped on the cover photo
                        child: ClipPath(
                          clipper: ArcClipper(),
                          child: Image.network('https://image.tmdb.org/t/p/w500${pelicula['backdropPath']}', width: screen, height: 230.0, fit: BoxFit.cover),
                        ),
                      ),
                      expanded: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: [
                          FutureBuilder(
                            future: apiMovies.getVideos(pelicula['id']),
                            builder: (BuildContext context, AsyncSnapshot<List<ResultMovie>> snapshot){
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text("Has error in request :c"),
                                );
                              } else if(snapshot.connectionState == ConnectionState.done){
                                return _listVideos(snapshot.data);
                              } else{
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }
                          ),
                          ExpandableButton(       // <-- Collapses when tapped on
                            child: Text("Back to poster", style: TextStyle(color: Colors.redAccent)),
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
              ),
              
            ]
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             Material(
                borderRadius: BorderRadius.circular(4.0),
                elevation: 2.0,
                child: Image.network('https://image.tmdb.org/t/p/w500${pelicula['posterPath']}', fit: BoxFit.cover, width: 120.0, height: 170.0),
              ),
              SizedBox(width: 16.0),
              Expanded(child: movieInformation),
            ],
          ),
        ),
      ],
    );
  }

  Widget Storyline({pelicula}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Story line',
          style: TextStyle(
            fontSize: 18.0
          )
        ),
        SizedBox(height: 8.0),
        Text(
          '${pelicula['overview']}',
          style: TextStyle(
            color: Colors.black45,
            fontSize: 16.0,
          ),
        ),
        
      ],
    );
  }

  Widget ActorScroller ({movie_id}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Actors',
            style: TextStyle(
              fontSize: 18.0
            ),
          ),
        ),
        FutureBuilder(
         future: apiMovies.getCastMovie(movie_id),
         builder: (BuildContext context, AsyncSnapshot<List<CastElement>> snapshot){
           if (snapshot.hasError) {
             return Center(
               child: Text("Has error in request :c"),
             );
           } else if(snapshot.connectionState == ConnectionState.done){
             return _listCast(snapshot.data);
           } else{
             return Center(
               child: CircularProgressIndicator(),
             );
           }
         }
       ),
      ],
    );
  }

  Widget _listVideos(List<ResultMovie> videos){
    return SizedBox.fromSize(
      size: const Size.fromHeight(250.0),
      child: ListView.builder(
        itemCount: 1,
        // padding: const EdgeInsets.only(top: 12.0, left: 20.0),
        itemBuilder: (context, index){
          ResultMovie movie_videos = videos[index];
          return _buildYtVideo(movie_videos);
        }
      ),
    );
  }

  Widget _buildYtVideo(ResultMovie movie_video) {
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(movie_video.key),
        flags: YoutubePlayerFlags(
          autoPlay: false
        ),
    );
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          aspectRatio:16/9,

          showVideoProgressIndicator: true,
        ),
      builder:(context,player){
          return Column(
          children: <Widget>[
          player
          ],
          );
      },
    );
  }

  Widget _listCast(List<CastElement> actors){
    return SizedBox.fromSize(
      size: const Size.fromHeight(120.0),
      child: ListView.builder(
        itemCount: actors.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(top: 12.0, left: 20.0),
        itemBuilder: (context, index){
          CastElement casting = actors[index];
          return _buildActor(casting);
        }
      ),
    );
  }

  Widget _buildActor(CastElement actor) {
    var imgActor = actor.profilePath == null
    ? CircleAvatar(backgroundImage: AssetImage('assets/avatar_photo.png'), radius: 40.0,)
    : CircleAvatar(backgroundImage: NetworkImage('https://image.tmdb.org/t/p/w500/${actor.profilePath}'), radius: 40.0,);
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          imgActor,
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(actor.name),
          ),
        ],
      ),
    );
  }
}

Future<dynamic> getTextFav(_objMovie) {
  var txt = _objMovie.then((result) {
    if (result != null) {
      return 'Eliminar de favoritos';
    } else {
      return 'Añadir a favoritos';
    }
  });
  return txt;
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}