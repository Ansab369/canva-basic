// ignore_for_file: prefer_const_constructors

import 'package:canva/screens/canvas_screen.dart';
import 'package:canva/screens/home_screen.dart';
import 'package:canva/screens/login_screeen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Canva',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/canvas': (context) => CanvasScreen(),
      },
    );
  }
}
