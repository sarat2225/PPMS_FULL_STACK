import 'package:flutter/material.dart';
import 'package:ppms/auth/login.dart';
import 'package:ppms/auth/register.dart';
import 'package:ppms/admin/adminhome.dart';
import 'package:ppms/student/studenthome.dart';
import 'package:ppms/admin/listofstudents.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      '/login': (context) => Login(),
      '/sign_up': (context) => Register(),
      '/admin/home': (context) => AdminHomePage(),
      '/student/home': (context) => StudentHome(),
      '/admin/listofstudents': (context) => MyDataTable(),
    },
  ));
}
