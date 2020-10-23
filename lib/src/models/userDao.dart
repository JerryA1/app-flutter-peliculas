import 'dart:convert';

class UserDAO{
  String username;
  String pwduser;

  UserDAO({this.username, this.pwduser});
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