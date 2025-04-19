import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/site_list.dart';

class RekomendasiList extends StatefulWidget {
  const RekomendasiList({super.key});

  @override
  State<RekomendasiList> createState() => _RekomendasiListState();
}

class _RekomendasiListState extends State<RekomendasiList> {
  List<bool> favoriteStatus = [];

  @override
  void initState() {
    super.initState();
    favoriteStatus = List.generate(learningSites.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0A2E5C);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 242, 247, 255),
      body: Stack(
        children: [
          // background gelombang kuning
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // 🔙 Tombol back + logo
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: darkBlue),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Image.asset(
                        "asset/logo.png",
                        width: 80,
                        height: 80,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Judul halaman
                  Text(
                    "Situs Belajar Flutter & Dart",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubikMonoOne(
                      fontSize: 22,
                      color: const Color(0xFF0E316B),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: learningSites.length,
                      itemBuilder: (context, index) {
                        final site = learningSites[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: Image.network(
                                  site.imageUrl,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color:
                                      Color(0xFFCDDBF2), // Warna latar keterangan
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(16),
                                  ),
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 2.0, 12.0, 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            site.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0E316B),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              favoriteStatus[index] =
                                                  !favoriteStatus[index];
                                            });
                                          },
                                          icon: Icon(
                                            favoriteStatus[index]
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: favoriteStatus[index]
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      site.description,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    const SizedBox(height: 8),
                                    Center(
                                      child: Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _handleLaunch(site.link);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF0B409C),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 56, vertical: 6),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 2,
                                            tapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                            minimumSize: Size.zero,
                                          ),
                                          child: Text(
                                            "Go To Website",
                                            style: GoogleFonts.rubikMonoOne(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w100,
                                              color: const Color(0xFFCDDBF2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _handleLaunch(String url) async {
    final uri = Uri.parse(url);
    final success = await _safeLaunchUrl(uri);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal membuka tautan.")),
      );
    }
  }

  Future<bool> _safeLaunchUrl(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    } else {
      return false;
    }
  }
}
