import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../user.dart';

class LoginData {
  String email;
  String password;

  LoginData(this.email, this.password);

  Future<bool> loginUser (BuildContext context) async {
    // Firebase Authentication
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserID(FirebaseAuth.instance.currentUser!.uid);
      userProvider.setUserEmail(FirebaseAuth.instance.currentUser!.email!);
      userProvider.setUserImage(FirebaseAuth.instance.currentUser!.photoURL ?? '');
      userProvider.setUserInfo();
      return true;
    }catch(e){
      return false;
    }

  }

  toJSON (){
    return {
      'email': email,
      'password': password,
    };
  }

  static getQuery() async {
    User user = await LoginData.getLoggedUser();
    if (user == null) {
      return;
    }
    String uid = user.uid;
    return FirebaseDatabase.instance
        .ref()
        .child('todos')
        .child(uid);
  }

  static bool logoutUser (BuildContext context){
    FirebaseAuth.instance.signOut();
    if (FirebaseAuth.instance.currentUser == null){
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserID(" ");
      userProvider.setUserEmail("");
      userProvider.setUserImage('');

      return true;
    }
    else{
      return false;
    }
  }

  static getLoggedUser (){
    return FirebaseAuth.instance.currentUser;
  }
  static getLoggedUserID (){
    if (FirebaseAuth.instance.currentUser == null){
      return "";
    }
    else{
      return FirebaseAuth.instance.currentUser!.uid;
    }
  }

  static bool isLogged (){
    if (FirebaseAuth.instance.currentUser == null){
      return false;
    }
    else{
      final UserProvider userProvider = UserProvider();
      userProvider.setUserID(FirebaseAuth.instance.currentUser!.uid);
      return true;
    }
  }

  static createEmptyLoginData (){
    return LoginData('', '');
    // return LoginData('', '');
  }

  static String getLoggedUserEmail() {
    return FirebaseAuth.instance.currentUser!.email!;
  }

  static String getLoggedUserImage() {
    return FirebaseAuth.instance.currentUser!.photoURL ?? '';
  }

  static String getLoggedUserName() {
    return FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('userName')
        .toString();
  }

  static String getLoggedUserMotive() {
    return FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('motive')
        .toString();
  }
}
