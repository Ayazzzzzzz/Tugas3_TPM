import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginfe/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.inriaSansTextTheme().apply(
          bodyColor: const Color.fromARGB(255, 14, 49, 107),
        ),
      ),
      home: Login(),
    );
  }
}
