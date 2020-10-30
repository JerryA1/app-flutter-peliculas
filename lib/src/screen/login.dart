import 'package:flutter/material.dart';
import 'package:practica2/src/api/login.dart';
import 'package:practica2/src/models/userDao.dart';
import 'package:practica2/src/screen/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ApiLogin httpLogin = ApiLogin();
  bool isValidating = false; //Variable para controlar la visualizacion del indicador del progreso

  TextEditingController txtUserController = TextEditingController();
  TextEditingController txtPwdController = TextEditingController();
  SharedPreferences loginData;
  bool newuser;
  bool isCheckedStayLogin = false;
  var resultHolder = 'Checkbox is UN-CHECKED';

  @override
  void initState(){
    super.initState();
    checkAlreadyLogin();
  }

  void checkAlreadyLogin() async {
    loginData = await SharedPreferences.getInstance();
    newuser = (loginData.getBool('login') ?? true);
    // print(newuser);
    if (newuser == false) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtUserController.dispose();
    txtPwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    final txtEmail = TextFormField(
      controller: txtUserController,
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
      controller: txtPwdController,
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
      onPressed: () async{
        // if (username != '' && password != '') {
          // print('Successfull');
          // loginData.setBool('login', false);
          // loginData.setString('username', txtUserController.text);
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => MyDashboard()));
        // }
        UserDAO objUser = UserDAO(username: txtUserController.text, pwduser: txtPwdController.text);
        httpLogin.validateUser(objUser).then((token){
          print(token);
          if(token != null){
            isValidating = true;
            //Validar si se mantiene la sesión iniciada o no
             if (isCheckedStayLogin) {
              print('Stay login');
              loginData.setBool('login', false);
            } else {
              print('No stay login');
              loginData.setBool('login', true);
            }
            loginData.setString('username', txtUserController.text);
            loginData.setString('token', token);
            Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
          } else{
            showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text('Error:'),
                  content: Text('Credentials are incorrect'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Close'),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                );
              }
            );
          }
        });
      }
    );

    final logo = Image.network('http://itcelaya.edu.mx/jornadabioquimica/wp-content/uploads/2019/07/LOGO-ITC-843x1024.png', width: 150, height: 150,);
    
    
    void toggleCheckbox(bool value) {
      if(isCheckedStayLogin == false){
        // Put your code here which you want to execute on CheckBox Checked event.
        setState(() {
          isCheckedStayLogin = true;
          resultHolder = 'Checkbox is CHECKED';
        });
      } else{
        // Put your code here which you want to execute on CheckBox Un-Checked event.
        setState(() {
          isCheckedStayLogin = false;
          resultHolder = 'Checkbox is UN-CHECKED';
        });
      }
    }
    final staySignInCheck = Checkbox(
      value: isCheckedStayLogin,
      onChanged: (value){toggleCheckbox(value);},
      activeColor: Colors.pink,
      checkColor: Colors.white,
      tristate: false,
    );

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
                  loginBtn,
                  SizedBox(height: 10,),
                  Row(
                    children:[
                      staySignInCheck,
                      // Text('$resultHolder')
                      Text('Recordarme')
                    ]
                  ),
                  
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
           child: isValidating ? CircularProgressIndicator() : Container(),
         )
       ],
    );
  }
}