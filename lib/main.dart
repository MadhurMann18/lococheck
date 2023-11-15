import 'package:flutter/material.dart';
import 'package:newloco/login.dart';
import 'package:newloco/register.dart';



void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'login': (context) => Mylogin(),
      'register': (context) => MyRegister()
    },
  ));
}