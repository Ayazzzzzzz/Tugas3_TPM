import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FE),
      body: Stack(
        children: [
          // Gelombang kuning di bawah (background)
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "asset/bg.png",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          // Konten Utama
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'asset/logo.png',
                      height: 60,
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Center(
                    child: Text(
                      'Cek Bilangan Yuk!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003C9D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => cekJenisBilangan(_controller.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003C9D),
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
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      'Jenis Bilangan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFC107),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
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
                  const SizedBox(
                      height: 100), // Spasi agar konten tidak ketutupan bg
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
