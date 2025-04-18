import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpMenu extends StatelessWidget {
  const HelpMenu({super.key});

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

                  // Judul di tengah dengan Google Font
                  Center(
                    child: Text(
                      'Panduan Penggunaan Aplikasi',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubikMonoOne(
                        color: Colors.black87,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ExpansionTile(
                    title: const Text("🔐 Login"),
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
                    title: const Text("🏠 Halaman Utama"),
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
                    title: const Text("⭐ Favorite"),
                    children: const [
                      ListTile(
                        title: Text("Gunakan fitur ini untuk menyimpan halaman favorit dari situs atau menu lain."),
                      ),
                    ],
                  ),

                  ExpansionTile(
                    title: const Text("📱 Bottom Navigation Bar"),
                    children: const [
                      ListTile(title: Text("1. Beranda - Kembali ke halaman utama.")),
                      ListTile(title: Text("2. Daftar Anggota - Tampilkan informasi anggota tim pembuat aplikasi.")),
                      ListTile(title: Text("3. Bantuan - Menampilkan halaman ini.")),
                      ListTile(title: Text("4. Logout - Keluar dari akun dan menghapus session.")),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    "💡 Tips Penggunaan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
    );
  }
}
