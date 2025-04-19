import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas3_tpm/home.dart';
import 'package:tugas3_tpm/pages/daftar_anggota.dart';
import 'package:tugas3_tpm/login.dart';

class HelpMenu extends StatefulWidget {
  const HelpMenu({super.key});

  @override
  State<HelpMenu> createState() => _HelpMenuState();
}

class _HelpMenuState extends State<HelpMenu> {
  int _selectedIndex = 2;

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DaftarAnggotaPage()),
        );
        break;
      case 2:
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
      backgroundColor: const Color(0xFFF5F8FE),
      body: Stack(
        children: [
          // Background bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "asset/bg.png",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Logo di kanan atas
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'asset/logo.png',
                      height: 60,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Judul
                  Center(
                    child: Text(
                      'Panduan Penggunaan Aplikasi',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubikMonoOne(
                        color: const Color(0xFF0E316B),
                        fontSize: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ExpansionTile(
                    leading: const Icon(Icons.login),
                    title: const Text("Login"),
                    children: const [
                      ListTile(
                        title: Text(
                          "Masukkan email dan password untuk login. "
                              "Setelah berhasil, Anda akan diarahkan ke halaman utama. "
                              "Session tetap aktif hingga Anda logout.",
                        ),
                      ),
                    ],
                  ),

                  ExpansionTile(
                    leading: const Icon(Icons.home),
                    title: const Text("Halaman Utama"),
                    children: const [
                      ListTile(title: Text("Terdiri dari 5 menu utama yang ditampilkan secara vertikal di tengah layar:")),
                      ListTile(title: Text("1. Stopwatch - Mulai, Berhenti, dan Reset stopwatch.")),
                      ListTile(title: Text("2. Jenis Bilangan - Masukkan angka untuk mengetahui jenis bilangan.")),
                      ListTile(title: Text("3. Tracking LBS - Menampilkan lokasi pengguna (aktifkan izin lokasi).")),
                      ListTile(title: Text("4. Konversi Waktu - Ubah tahun menjadi jam, menit, dan detik.")),
                      ListTile(title: Text("5. Daftar Situs - Tampilkan daftar situs dengan gambar dan link.")),
                    ],
                  ),

                  ExpansionTile(
                    leading: const Icon(Icons.favorite),
                    title: const Text("Favorite"),
                    children: const [
                      ListTile(
                        title: Text("Gunakan fitur ini untuk menyimpan halaman favorit dari situs atau menu lain."),
                      ),
                    ],
                  ),

                  ExpansionTile(
                    leading: const Icon(Icons.menu),
                    title: const Text("Bottom Navigation Bar"),
                    children: const [
                      ListTile(title: Text("1. Beranda - Kembali ke halaman utama.")),
                      ListTile(title: Text("2. Daftar Anggota - Tampilkan informasi anggota tim pembuat aplikasi.")),
                      ListTile(title: Text("3. Bantuan - Menampilkan halaman ini.")),
                      ListTile(title: Text("4. Logout - Keluar dari akun dan menghapus session.")),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Row(
                    children: const [
                      Icon(Icons.lightbulb),
                      SizedBox(width: 8),
                      Text(
                        "Tips Penggunaan",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text("• Pastikan koneksi internet stabil untuk fitur online."),
                  const Text("• Aktifkan izin lokasi untuk fitur Tracking LBS."),
                  const Text("• Gunakan versi aplikasi terbaru untuk pengalaman terbaik."),
                  const SizedBox(height: 40),
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
            label: 'Anggota',
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
}
