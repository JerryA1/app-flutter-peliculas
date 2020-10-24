import 'package:flutter/material.dart';
import 'package:practica2/src/assets/configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  SharedPreferences loginData;
  String username;
  String tokenSesion;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      username = loginData.getString('username');
      tokenSesion = loginData.getString('token');
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(      
      child: Scaffold(        
        appBar: AppBar(
          backgroundColor: Configuration.colorApp,
          title: Text('Peliculas'),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Configuration.colorApp
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage('https://villasmilindovillas.com/wp-content/uploads/2020/01/Profile.png'),
                ),
                accountName: Text('Jerry Almanza'), 
                accountEmail: Text('$username'),
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
                  loginData.setString('username', '');
                  loginData.setString('token', '');
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}