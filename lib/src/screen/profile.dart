import 'dart:io';

import 'package:flutter/material.dart';
import 'package:practica2/src/assets/configuration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practica2/src/database/database_helper.dart';
import 'package:practica2/src/models/userDao.dart';
import 'package:practica2/src/screen/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences loginData;
  String emailDataLogin;

  DataBaseHelper _database;
  final picker = ImagePicker();
  String imagePath = "";

  @override
  void initState() {
    super.initState();
    initial();
    _database = DataBaseHelper();
  }
  
  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      emailDataLogin = loginData.getString('useremail');
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
        body: profileView(),
        resizeToAvoidBottomPadding: false 
      ),
    );
  }

  Widget profileView() {
    TextEditingController nameController = TextEditingController()..text = '';
    TextEditingController emailController = TextEditingController()..text = '$emailDataLogin';
    TextEditingController telController = TextEditingController()..text = '';
    TextEditingController apController = TextEditingController()..text = '';
    TextEditingController amController = TextEditingController()..text = '';
    bool _isEnable = false;
    Future<UserDAO> _objUser = _database.getUsuario(emailDataLogin);

    final txtName = TextFormField(
      keyboardType: TextInputType.text,
      cursorColor: Colors.white,
      style: TextStyle(fontSize: 16.0, color: Color(0xFFbdc6cf)),
      controller: nameController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelText: 'Nombre',
        hintText: 'Introduce tu nombre',
        labelStyle: TextStyle(
          color: Colors.white
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 4)
      ),
    );

    final txtAp = TextFormField(
      keyboardType: TextInputType.text,
      cursorColor: Colors.white,
      style: TextStyle(fontSize: 16.0, color: Color(0xFFbdc6cf)),
      controller: apController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelText: 'Appelido paterno',
        hintText: 'Primer apellido',
        labelStyle: TextStyle(
          color: Colors.white
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 4)
      ),
    );

    final txtAm = TextFormField(
      keyboardType: TextInputType.text,
      cursorColor: Colors.white,
      style: TextStyle(fontSize: 16.0, color: Color(0xFFbdc6cf)),
      controller: amController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelText: 'Apellido materno',
        hintText: 'Segundo apellido',
        labelStyle: TextStyle(
          color: Colors.white
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 4)
      ),
    );

    final txtEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.white,
      enabled: _isEnable,
      style: TextStyle(fontSize: 16.0, color: Color(0xFFbdc6cf)),
      controller: emailController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelText: 'Email',
        hintText: 'Introduce tu email',
        labelStyle: TextStyle(
          color: Colors.white
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 4)
      ),
    );

    final txtTel = TextFormField(
      keyboardType: TextInputType.number,
      cursorColor: Colors.white,
      style: TextStyle(fontSize: 16.0, color: Color(0xFFbdc6cf)),
      controller: telController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelText: 'Telefono',
        hintText: 'Introduce tu telefono',
        labelStyle: TextStyle(
          color: Colors.white
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 4)
      ),
    );

    final saveBtn = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Color.fromRGBO(255, 255, 255, 1), // Color pinkAccent
      child: Row( // Add a Row Widget for placing objects.
        mainAxisAlignment: MainAxisAlignment.center, // Center the Widgets.
        mainAxisSize: MainAxisSize.max, // Use all of width in RaisedButton.
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0), // Give to the text some space.
            child: Text(
              "Enviar",
              style: TextStyle(
                fontSize: 18, // 18pt in font.
                color: Colors.black, // You can ommit it if you use textColor in RaisedButton.
              ),
            ),
          ),
          Icon(
            Icons.send, // Send Icon. (Papper Plane Icon)
            color: Colors.black, // White Color. You can ommit it too if you use textColor property on RaisedButton.
            size: 18, // 18 pt, same as text.
          ),
        ],
      ),     
      onPressed: (){
        _objUser.then((result) {
          //print(result.id);
          if (result != null) {
            print('Actualizar');
            UserDAO user = UserDAO(
              id: result.id,
              nomUser: nameController.text,
              apepUser: apController.text,
              apemUser: amController.text,
              telUser: telController.text,
              emailUser: emailController.text,
              foto: imagePath
            );
            _database.actualizar(user.toJSON(), 'tbl_perfil').then((rows) => {
              print('$rows')
            });
          } else{
            print('Insertar');
            UserDAO user = UserDAO(
              nomUser: nameController.text,
              apepUser: apController.text,
              apemUser: amController.text,
              telUser: telController.text,
              emailUser: emailController.text,
              foto: imagePath
            );
            _database.insertar(user.toJSON(), 'tbl_perfil').then((rows) => {
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
        
        print('Guardar perfil');
      }
    );

    final photoBtn = RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),              
      color: Configuration.colorAddPhoto,
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
          ),
        ],
      ),
      onPressed: () async{
        final pickedFile = await picker.getImage(source: ImageSource.camera);
        imagePath = pickedFile != null ? pickedFile.path : "";
        print(imagePath);
        setState(() {
          
        });
      },
    );
    
    final imgFinal = imagePath == "" 
      ? CircleAvatar(radius: 70, backgroundImage: NetworkImage('https://villasmilindovillas.com/wp-content/uploads/2020/01/Profile.png'))
      : ClipOval(child: Image.file(File(imagePath), fit: BoxFit.cover, width: 130,),);
    var _avatarPic = imgFinal;
    return FutureBuilder(
      future: _objUser,
       builder: (BuildContext context, AsyncSnapshot<UserDAO> snapshot){
        final _newValueName = snapshot.data == null
        ? ''
        : snapshot.data.nomUser;
        nameController.value = TextEditingValue(
          text: _newValueName,
          selection: TextSelection.fromPosition(
            TextPosition(offset: _newValueName.length),
          ),
        );

        final _newValueAp = snapshot.data == null
        ? ''
        : snapshot.data.apepUser;
        apController.value = TextEditingValue(
          text: _newValueAp,
          selection: TextSelection.fromPosition(
            TextPosition(offset: _newValueAp.length),
          ),
        );

        final _newValueAm = snapshot.data == null
        ? ''
        : snapshot.data.apemUser;
        amController.value = TextEditingValue(
          text: _newValueAm,
          selection: TextSelection.fromPosition(
            TextPosition(offset: _newValueAm.length),
          ),
        );

        final _newValueTel = snapshot.data == null
        ? ''
        : snapshot.data.telUser;
        telController.value = TextEditingValue(
          text: _newValueTel,
          selection: TextSelection.fromPosition(
            TextPosition(offset: _newValueTel.length),
          ),
        );

        // print(imagePath);
        
        if (snapshot.data != null && imagePath == "") {
          _avatarPic = ClipOval(child: Image.file(File(snapshot.data.foto), fit: BoxFit.cover, width: 130,));
          imagePath = snapshot.data.foto;
        }

       
        return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Container(height: 50, width: 50 ,child: Icon(Icons.arrow_back_ios, size: 24,color: Colors.black54,), decoration: BoxDecoration(border: Border.all(color: Colors.black54), borderRadius: BorderRadius.all(Radius.circular(10))),),
                Text('Profiles details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Container(height: 24,width: 24)
              ],
            ),
          ),
          SizedBox(
            height: 180,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0,0 ,50),
              child: Stack(
                children: <Widget>[
                  _avatarPic,
                  Positioned(bottom: 1, right: 1 ,child: Container(
                    height: 40, width: 40,
                    child: photoBtn,
                  ))
                ],
              ),
            ),
          ),
          Expanded(child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: Configuration.colorBackProfile
            ),
            child: Column(
              children: <Widget>[              
                 Expanded(
                  child: Card(
                    color: Configuration.colorBackProfile,
                    margin: EdgeInsets.all(20.0),
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            SizedBox(height: 5,),
                            txtName,
                            SizedBox(height: 26,),
                            txtAp,
                            SizedBox(height: 26,),
                            txtAm,
                            SizedBox(height: 26,),
                            txtEmail,
                            SizedBox(height: 26,),
                            txtTel,
                            SizedBox(height: 35,),
                            saveBtn
                          ],
                      ),
                    ),
                  ),
                ),              
              ],
            ),
          ))
        ],
      );
      }
    );
  }
}