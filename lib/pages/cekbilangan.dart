import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class CekBilangan extends StatefulWidget {
  const CekBilangan({super.key});

  @override
  State<CekBilangan> createState() => _CekBilanganState();
}

class _CekBilanganState extends State<CekBilangan> {
  final TextEditingController _controller = TextEditingController();
  List<String> jenisBilangan = [];

  final formatter = NumberFormat("#,##0.########");

  void cekJenisBilangan(String formattedInput) {
    String plainInput = formattedInput.replaceAll(',', '');
    final double? number = double.tryParse(plainInput);

    if (number == null) {
      setState(() {
        jenisBilangan = ['Input tidak valid'];
      });
      return;
    }

    List<String> jenis = [];

    if (number % 1 != 0) {
      jenis.add('Desimal');
    } else {
      int intNumber = number.toInt();
      jenis.add('Bulat');

      if (intNumber > 1 && isPrima(intNumber)) {
        jenis.add('Prima');
      }

      if (intNumber >= 0) {
        jenis.add('Cacah');
      }

      if (intNumber > 0) {
        jenis.add('Positif');
      } else if (intNumber < 0) {
        jenis.add('Negatif');
      } else {
        jenis.add('Nol');
      }
    }

    setState(() {
      jenisBilangan = jenis;
    });
  }

  bool isPrima(int n) {
    if (n <= 1) return false;
    for (int i = 2; i <= n ~/ 2; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  void onChanged(String value) {
    String newValue = value.replaceAll(',', '');
    if (newValue.isEmpty) return;

    double? number = double.tryParse(newValue);
    if (number == null) return;

    String newFormatted = formatter.format(number);

    // Jika user sedang mengetik titik di akhir (misal 3.), tetap izinkan
    if (value.endsWith('.') && !newFormatted.contains('.')) {
      newFormatted += '.';
    }

    // Hanya update jika berbeda
    if (newFormatted != value) {
      _controller.value = TextEditingValue(
        text: newFormatted,
        selection: TextSelection.collapsed(offset: newFormatted.length),
      );
    }
  }

  final Map<String, Color> warnaJenis = {
    'Desimal': Colors.blue.shade700,
    'Bulat': Colors.grey.shade400,
    'Cacah': Colors.grey.shade600,
    'Positif': Colors.green.shade200,
    'Negatif': Colors.red.shade300,
    'Prima': Colors.purple.shade200,
    'Nol': Colors.orange,
    'Input tidak valid': Colors.red.shade500,
  };

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF2F7FF);
    const darkBlue = Color(0xFF0A2E5C);
    const yellow = Color(0xFFFFC107);

    return Scaffold(
      resizeToAvoidBottomInset: false, // <- ini biar gelombang gak naik
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background gelombang kuning di bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "asset/bg.png",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          // Konten utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  // Bar atas: tombol back & logo
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
                    'Cek Bilangan Yuk!',
                    style: GoogleFonts.rubikMonoOne(
                      fontSize: 26,
                      color: darkBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Kolom input
                  TextField(
                    controller: _controller,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      hintText: 'Masukkan bilangan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol cek
                  ElevatedButton(
                    onPressed: () => cekJenisBilangan(_controller.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                    ),
                    child: const Text(
                      'Cek',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Judul hasil
                  const Text(
                    'Jenis Bilangan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: yellow,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Hasil jenis bilangan
                  Expanded(
                    child: SingleChildScrollView(
                      child: Align(
                        alignment: Alignment.center,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 12,
                          children: jenisBilangan.map((jenis) {
                            return ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 140,
                                maxWidth: 160,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: warnaJenis[jenis] ?? Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    jenis,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40), // biar gak mentok
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
