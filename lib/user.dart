import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todo/login.dart';

import 'Data/loginData.dart';

class UserProvider with ChangeNotifier {
  String _userID = LoginData.getLoggedUserID();
  String _userEmail = LoginData.getLoggedUserEmail();
  String _userImage = LoginData.getLoggedUserImage();
  String _userName = LoginData.getLoggedUserName();
  String _userMotive = 'Motive';

  String get userID => _userID;
  String get userEmail => _userEmail;
  String get userImage => _userImage;
  String get userName => _userName;
  String get userMotive => _userMotive;

  void setUserID(String userID) {
    _userID = userID;
    notifyListeners();
  }

  void setUserEmail(String userEmail) {
    _userEmail = userEmail;
    notifyListeners();
  }

  void setUserImage(String userImage) {
    _userImage = userImage;
    notifyListeners();
  }

  void setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  void setUserMotive(String userMotive) {
    _userMotive = userMotive;
    notifyListeners();
  }

  Future<void> setUserInfo() async {
    final data = await FirebaseDatabase.instance.ref().child('users').child(_userID).once();
    final Map<dynamic, dynamic> userInfo = data.snapshot.value as Map<dynamic, dynamic>;
    print(userInfo);
    _userName = userInfo['userName'];
    _userMotive = userInfo['motive'];
  }



}