import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas3_tpm/home.dart';
import 'package:tugas3_tpm/pages/daftar_anggota.dart';
import 'package:tugas3_tpm/pages/help.dart';
import 'package:tugas3_tpm/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarAnggotaPage extends StatefulWidget {
  const DaftarAnggotaPage({super.key});

  @override
  State<DaftarAnggotaPage> createState() => _DaftarAnggotaPageState();
}

class _DaftarAnggotaPageState extends State<DaftarAnggotaPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) async {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HelpMenu()),
        );
        break;
      case 3:
        _showLogoutDialog(context);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('isLoggedIn');
                await prefs.remove('userEmail');
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }


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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      "asset/logo.png",
                      height: 60,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Daftar Anggota",
                      style: GoogleFonts.rubikMonoOne(
                        fontSize: 22,
                        color: Color(0xFF0E316B),
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0E316B),
        selectedItemColor: const Color(0xFFF9C851),
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'asset/icon_home.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 0 ? const Color(0xFFF9C851) : Colors.white70,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'asset/icon_profile.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 1 ? const Color(0xFFF9C851) : Colors.white70,
            ),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'asset/icon_help.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 2 ? const Color(0xFFF9C851) : Colors.white70,
            ),
            label: 'Bantuan',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'asset/icon_logout.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 3 ? const Color(0xFFF9C851) : Colors.white70,
            ),
            label: 'Keluar',
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text("🆔 "),
                    Text(nim),
                  ],
                ),
                Row(
                  children: [
                    const Text("📧 "),
                    Expanded(child: Text(email, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
