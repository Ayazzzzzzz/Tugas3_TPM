import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class KonversiWaktuPage extends StatefulWidget {
  @override
  _KonversiWaktuPageState createState() => _KonversiWaktuPageState();
}

class _KonversiWaktuPageState extends State<KonversiWaktuPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  String _resultKonversi = '';
  bool _showResultKonversi = false;

  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this); // Hanya 1 tab
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _convertTime() {
    if (_formKey.currentState!.validate()) {
      String rawInput = _controller.text.replaceAll('.', '').replaceAll(',', '.');
      double years = double.parse(rawInput);

      int fullYears = years.floor();
      double fractionalYear = years - fullYears;

      int startYear = 0;
      int leapYears = 0;

      for (int i = startYear; i < fullYears; i++) {
        if ((i % 4 == 0 && i % 100 != 0) || (i % 400 == 0)) {
          leapYears++;
        }
      }

      int normalYears = fullYears - leapYears;

      int nextYear = fullYears;
      bool isNextLeap = (nextYear % 4 == 0 && nextYear % 100 != 0) || (nextYear % 400 == 0);
      double fractionalDays = fractionalYear * (isNextLeap ? 366 : 365);

      double totalDays = (leapYears * 366) + (normalYears * 365) + fractionalDays;
      double hours = totalDays * 24;
      double minutes = hours * 60;
      double seconds = minutes * 60;

      final formatter = NumberFormat('#,###.##', 'id_ID');

      setState(() {
        _resultKonversi = '''
${formatter.format(years)} Tahun
= ${formatter.format(totalDays)} Hari
= ${formatter.format(hours)} Jam
= ${formatter.format(minutes)} Menit
= ${formatter.format(seconds)} Detik
        ''';
        _showResultKonversi = true;
        _animationController.forward(from: 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF0A2E5C);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 242, 247, 255),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
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
                  Text(
                    'KONVERSI WAKTU',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubikMonoOne(
                      fontSize: 22,
                      color: Color.fromARGB(255, 14, 49, 107),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TabBar(
                    controller: _tabController,
                    labelColor: const Color.fromARGB(255, 14, 49, 107),
                    indicatorColor: const Color.fromARGB(255, 255, 221, 77),
                    tabs: const [
                      Tab(text: "Konversi Tahun"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildKonversiTahunTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKonversiTahunTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20),
        Text(
          'Masukkan jumlah tahun:',
          style: GoogleFonts.inriaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 14, 49, 107),
          ),
        ),
        SizedBox(height: 12),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              CustomThousandCommaFormatter(),
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: 'Contoh: 4',
              labelStyle: TextStyle(color: Color.fromARGB(255, 14, 49, 107)),
              prefixIcon: Icon(Icons.calendar_today, color: Color.fromARGB(255, 14, 49, 107)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tahun tidak boleh kosong';
              }
              String raw = value.replaceAll('.', '').replaceAll(',', '.');
              if (double.tryParse(raw) == null) {
                return 'Masukkan angka yang valid';
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _convertTime,
          icon: Icon(Icons.access_time),
          label: Text('Konversi'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 14, 49, 107),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: GoogleFonts.rubikMonoOne(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        SizedBox(height: 30),
        _showResultKonversi
            ? FadeTransition(
          opacity: _animation,
          child: _buildResultCard(_resultKonversi),
        )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildResultCard(String result) {
    return Card(
      color: Color.fromARGB(255, 255, 221, 77),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          result,
          style: GoogleFonts.inriaSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CustomThousandCommaFormatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat("#,###", "id_ID");

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // Pisahkan bilangan bulat dan desimal
    List<String> parts = text.split(',');

    // Bersihkan bagian bilangan bulat
    String intPart = parts[0].replaceAll('.', '').replaceAll(RegExp(r'[^0-9]'), '');

    if (intPart.isEmpty) return newValue;

    String newText = formatter.format(int.parse(intPart));

    if (parts.length > 1) {
      newText += ',' + parts[1].replaceAll(RegExp(r'[^0-9]'), '');
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
