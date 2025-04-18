import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DaftarAnggotaPage extends StatelessWidget {
  const DaftarAnggotaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FF),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "asset/bg.png",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    "asset/logo.png",
                    width: 100,
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Daftar Anggota",
                    style: GoogleFonts.rubikMonoOne(
                      fontSize: 22,
                      color: const Color(0xFF0E316B),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildAnggotaItem(
                  image: "asset/ayas.jpg",
                  nama: "Laras Ayodya Sari",
                  nim: "123220081",
                  email: "larasayodya04@gmail.com",
                ),
                _buildAnggotaItem(
                  image: "asset/virda.jpg",
                  nama: "Virda Stefany A.M",
                  nim: "123220132",
                  email: "amel.virda.17@gmail.com",
                ),
                _buildAnggotaItem(
                  image: "asset/dhea.jpg",
                  nama: "Rolly Dhea Venesia Sibuea",
                  nim: "123220134",
                  email: "ddea8524@gmail.com",
                ),
                _buildAnggotaItem(
                  image: "asset/faiza.jpg",
                  nama: "Faiza Nur Rafida",
                  nim: "123220159",
                  email: "faizanurafida@gmail.com",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnggotaItem({
    required String image,
    required String nama,
    required String nim,
    required String email,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7FF),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E316B),
                    fontSize: 16,
                  ),
                ),
                Text(nim),
                Text(email),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
