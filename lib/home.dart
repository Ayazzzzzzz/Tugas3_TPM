import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Color.fromARGB(255, 14, 49, 107),
      ),
      body: const Center(
        child: Text(
          'Welcome to Home!',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
