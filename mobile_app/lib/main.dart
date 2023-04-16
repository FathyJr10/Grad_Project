// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:mobile_app/auth.dart';
import 'package:mobile_app/colors.dart';
import 'package:mobile_app/pages/app_screen.dart';
import 'package:mobile_app/pages/home.dart';
import 'package:mobile_app/pages/welcome_page.dart';
import 'pages/login.dart';
import 'pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/my_medical_records.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'my_medical_records',
        theme: ThemeData(
          primarySwatch: primary,
        ),

        //home: const WelcomePage(),
        //initialRoute: '/auth',
        routes: {
          '/': (context) => const AppScreen(),
          'login': (context) => const Login(),
          'signup': (context) => const SignUp(),
          'profile': (context) => const WelcomePage(),
          'my_medical_records': (context) => const My_Medical_Records(),
        });
  }
}
