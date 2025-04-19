import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas3_tpm/home.dart';
import 'package:tugas3_tpm/pages/cekbilangan.dart';
import 'package:tugas3_tpm/pages/daftar_anggota.dart';
import 'package:tugas3_tpm/pages/help.dart';
import 'login.dart';
import '../pages/rekomendasi_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // WAJIB kalau pakai async di main
  final prefs = await SharedPreferences.getInstance();
  bool isLogin = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLogin: isLogin));
}

class MyApp extends StatelessWidget {
  final bool isLogin; // Tambahkan ini biar bisa nerima status login

  const MyApp(
      {super.key, required this.isLogin}); // Constructor-nya juga harus tau

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.inriaSansTextTheme().apply(
          bodyColor: const Color.fromARGB(255, 14, 49, 107),
        ),
      ),
      home: isLogin ? const Home() : const Login(),
    );
  }
}
