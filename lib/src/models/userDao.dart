import 'dart:convert';

class UserDAO{
  String username;
  String pwduser;
  
  int id;
  String nomUser;
  String apepUser;
  String apemUser;
  String telUser;
  String emailUser;
  String foto;

  UserDAO({this.id, this.username, this.pwduser, this.nomUser, this.apepUser, this.apemUser, this.telUser, this.emailUser, this.foto});
  factory UserDAO.fromJSON(Map<String, dynamic> map){
    return UserDAO(
      id: map['id'],
      nomUser: map['nomUser'],
      apepUser: map['apepUser'],
      apemUser: map['apemUser'],
      telUser: map['telUser'],
      emailUser: map['emailUser'],
      foto: map['foto'],
      username: map['username'],
      pwduser: map['pwduser']
    );
  }

  Map<String, dynamic> toJSON(){
    return {
      "username": username,
      "pwduser": pwduser
    };
  }

  String userToJSON(){
    final mapUser = this.toJSON();
    return json.encode(mapUser);
  }
}