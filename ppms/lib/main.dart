import 'package:flutter/material.dart';
import 'package:ppms/auth/login.dart';
import 'package:ppms/auth/register.dart';
import 'package:ppms/admin/adminhome.dart';
import 'admin/listofstudents.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/students',
    routes: {
      '/login': (context) => Login(),
      '/sign_up': (context) => Register(),
      '/admin/home': (context) => AdminHomePage(),
      '/students': (context) => PaginatedDataTableDemo(),
    },
  ));
}
