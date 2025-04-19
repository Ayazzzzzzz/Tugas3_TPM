import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:tugas3_tpm/pages/stopwatch.dart';
import 'package:tugas3_tpm/pages/cekbilangan.dart';
import 'package:tugas3_tpm/pages/lbs_tracking.dart';
import 'package:tugas3_tpm/pages/konversi_waktu.dart';
import 'package:tugas3_tpm/pages/rekomendasi_list.dart';


class Home extends StatelessWidget {
  const Home({super.key});

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
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF0E316B),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
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
                            MaterialPageRoute(builder: (context) => const StopwatchPage()),
                          );
                        }),

                        buildMenuButton("Cek bilangan", "asset/Numbers.png", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CekBilangan()),
                          );
                        }),

                        buildMenuButton("Tracking LBS", "asset/Map.png", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LBSTrackingPage()),
                          );
                        }),

                        buildMenuButton("Konversi Tahun", "asset/Timetable.png", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => KonversiWaktuPage()),
                          );
                        }),

                        buildMenuButton("Rekomendasi", "asset/Advice.png", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RekomendasiList()),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Bantuan'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Keluar'),
        ],
      ),
    );
  }
}
