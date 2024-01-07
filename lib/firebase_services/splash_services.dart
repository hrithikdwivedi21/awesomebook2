import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funbook/screens/MainScreen.dart';
import 'package:funbook/screens/login.dart';
import 'dart:async';
class SplashService{
  void isLogin(BuildContext context){
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    if(user != null) {
      Timer(const Duration(seconds: 3), () =>
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen()))
      );
    }else{
      Timer(const Duration(seconds: 3), () =>
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginInsta()))
      );
    }
  }
}