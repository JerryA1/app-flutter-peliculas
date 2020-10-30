import 'dart:io';

import 'package:flutter/material.dart';
import 'package:practica2/src/assets/configuration.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
    TextEditingController nameController = TextEditingController()..text = 'Gerardo Almanza';
    TextEditingController emailController = TextEditingController()..text = '15030141@itcelaya.edu.mx';
    TextEditingController telController = TextEditingController()..text = '4111525280';

    final picker = ImagePicker();
    String imagePath = "";
  

    final txtName = TextFormField(
      keyboardType: TextInputType.emailAddress,
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

    final txtEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.white,
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
      keyboardType: TextInputType.emailAddress,
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
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
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
        imagePath = pickedFile.path;
        setState(() {
          
        });
      },
    );
    
    final imgFinal = imagePath == "" 
      ? CircleAvatar(
          radius: 70,
          backgroundImage: NetworkImage('https://villasmilindovillas.com/wp-content/uploads/2020/01/Profile.png'),
        )
      : ClipOval(
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover
          )
        );
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
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0,0 ,50),
          child: Stack(
            children: <Widget>[
              imgFinal,
              Positioned(bottom: 1, right: 1 ,child: Container(
                height: 40, width: 40,
                child: photoBtn,
              ))
            ],
          ),
        ),
        Expanded(child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Configuration.colorBackProfile
          ),
          child: Column(
            children: <Widget>[              
               Card(
                color: Configuration.colorBackProfile,
                margin: EdgeInsets.all(30.0),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(height: 25,),
                        txtName,
                        SizedBox(height: 26,),
                        txtEmail,
                        SizedBox(height: 26,),
                        txtTel,
                        SizedBox(height: 45,),
                        saveBtn
                      ],
                  ),
                ),
              ),              
            ],
          ),
        ))
      ],
    );
  }
}