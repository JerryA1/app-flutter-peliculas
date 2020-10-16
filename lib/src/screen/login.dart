import 'package:flutter/material.dart';
import 'package:practica2/src/screen/dashboard.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final txtEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),          
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5)
      ),
    );

    final txtPass = TextFormField(
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5)
      ),
    );

    final loginBtn = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text('Entrar', style: TextStyle(color: Colors.white),),
      color: Colors.lightBlue,
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    );

    final logo = Image.network('http://itcelaya.edu.mx/jornadabioquimica/wp-content/uploads/2019/07/LOGO-ITC-843x1024.png', width: 150, height: 150,);

    return Stack(
       alignment: Alignment.bottomCenter,
       children: <Widget>[
         // Widget para cargar una imagen de fondo
         Container(
           decoration: BoxDecoration(
             image: DecorationImage(
               image: AssetImage('assets/background.jpg'),
               fit: BoxFit.fitHeight,
             )
           ),
         ),
         Card(
           color: Colors.white70,
           margin: EdgeInsets.all(30.0),
           elevation: 8.0,
           child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  txtEmail,
                  SizedBox(height: 10,),
                  txtPass,
                  SizedBox(height: 10,),
                  loginBtn
                ],
            ),
           ),
         ),
         Positioned(
           child: logo,
           top: 200
         ),
         Positioned(
           top: 380,
           child: CircularProgressIndicator(),
         )
       ],
    );
  }
}