import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas3_tpm/pages/cekbilangan.dart';
import 'package:tugas3_tpm/pages/daftar_anggota.dart';
import 'login.dart';
import '../pages/rekomendasi_list.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.inriaSansTextTheme().apply(
          bodyColor: const Color.fromARGB(255, 14, 49, 107),
        ),
      ),
      home: DaftarAnggotaPage(),
    );
  }
}
