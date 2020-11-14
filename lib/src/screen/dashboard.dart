import 'dart:io';
import 'package:flutter/material.dart';
import 'package:practica2/src/api/movies.dart';
import 'package:practica2/src/assets/configuration.dart';
import 'package:practica2/src/database/database_helper.dart';
import 'package:practica2/src/models/userDao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  SharedPreferences loginData;
  String useremail;
  String tokenSesion;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      useremail = loginData.getString('useremail');
      tokenSesion = loginData.getString('token');
    });
  }
  
  @override
  Widget build(BuildContext context) {
    DataBaseHelper _database = DataBaseHelper();
    Future<UserDAO> _objUser = _database.getUsuario('15030141@itcelaya.edu.mx');

    ApiMovies apiMovie = ApiMovies();
    apiMovie.getTrending();

    return Container(      
      child: Scaffold(        
        appBar: AppBar(
          backgroundColor: Configuration.colorApp,
          title: Text('Peliculas'),
        ),
        drawer: Drawer(
          child: FutureBuilder(
                      future: _objUser,
                      builder: (BuildContext context, AsyncSnapshot<UserDAO> snapshot){
                        return ListView(
                          children: <Widget>[
                            UserAccountsDrawerHeader(
                              decoration: BoxDecoration(
                                color: Configuration.colorApp
                              ),
                              currentAccountPicture: snapshot.data == null 
                                ? CircleAvatar(backgroundImage: NetworkImage('https://villasmilindovillas.com/wp-content/uploads/2020/01/Profile.png'),)
                                : ClipOval(child: Image.file(File(snapshot.data.foto), fit: BoxFit.cover,)),
                              accountName: snapshot.data == null
                               ? Text('Invitado')
                               : Text('${snapshot.data.nomUser} ${snapshot.data.apepUser}'), 
                              accountEmail: snapshot.data == null
                              ? Text('Invitado@itcelaya.edu.mx')
                              :Text('${snapshot.data.emailUser}'),
                              onDetailsPressed: (){
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/profile');
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.trending_up, color: Configuration.colorItem,),
                              title: Text('Trending'),
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/trending');
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.search, color: Configuration.colorItem,),
                              title: Text('Search'),
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/search');
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.favorite, color: Configuration.colorItem,),
                              title: Text('Favorites'),
                              onTap: (){
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/favorites');
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.exit_to_app, color: Configuration.colorItem,),
                              title: Text('Sign out'),
                              onTap: (){
                                print(tokenSesion);
                                loginData.setBool('login', true);
                                loginData.setString('useremail', '');
                                loginData.setString('token', '');
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/login');
                              },
                            )
                          ],
                        );
                      }
                      
          ),
        ),
      ),
    );
  }
}