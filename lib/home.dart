import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:tugas3_tpm/pages/stopwatch.dart';
import 'package:tugas3_tpm/pages/cekbilangan.dart';
import 'package:tugas3_tpm/pages/lbs_tracking.dart';
import 'package:tugas3_tpm/pages/konversi_waktu.dart';
import 'package:tugas3_tpm/pages/rekomendasi_list.dart';
import 'package:tugas3_tpm/pages/help.dart';
import 'package:tugas3_tpm/pages/daftar_anggota.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        // Halaman Home, tetap di sini
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DaftarAnggotaPage()),
        );
        break;
      case 2:
        Navigator.push(
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

  Widget buildMenuButton(String title, String assetPath, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        color: Colors.transparent,
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        shadowColor: Colors.black.withOpacity(0.2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.yellow.withOpacity(0.2),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFBCCBE3),
              borderRadius: BorderRadius.circular(16),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              children: [
                Image.asset(assetPath, width: 36, height: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inriaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF640D0D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset("asset/logo.png", height: 60),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "HOME",
                    style: GoogleFonts.rubikMonoOne(
                      fontSize: 24,
                      color: const Color(0xFF0E316B),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildMenuButton("Stopwatch", "asset/Stopwatch.png", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StopwatchPage()),
                          );
                        }),
                        buildMenuButton("Cek bilangan", "asset/Numbers.png",
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CekBilangan()),
                          );
                        }),
                        buildMenuButton("Tracking LBS", "asset/Map.png", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LBSTrackingPage()),
                          );
                        }),
                        buildMenuButton("Konversi Tahun", "asset/Timetable.png",
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KonversiWaktuPage()),
                          );
                        }),
                        buildMenuButton("Rekomendasi", "asset/Advice.png", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RekomendasiList()),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
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
        elevation: 8,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'asset/icon_home.png',
              color: _selectedIndex == 0
                  ? const Color(0xFFF9C851)
                  : Colors.white70,
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'asset/icon_profile.png',
              color: _selectedIndex == 1
                  ? const Color(0xFFF9C851)
                  : Colors.white70,
              width: 24,
              height: 24,
            ),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'asset/icon_help.png',
              color: _selectedIndex == 2
                  ? const Color(0xFFF9C851)
                  : Colors.white70,
              width: 24,
              height: 24,
            ),
            label: 'Bantuan',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'asset/icon_logout.png',
              color: _selectedIndex == 3
                  ? const Color(0xFFF9C851)
                  : Colors.white70,
              width: 24,
              height: 24,
            ),
            label: 'Keluar',
          ),
        ],
      ),
    );
  }
}
