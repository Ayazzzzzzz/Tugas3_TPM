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

  DateTime? _birthDateTime;
  String _resultUmur = '';
  bool _showResultUmur = false;

  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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


  void _pickBirthDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 0, minute: 0),
      );

      if (time != null) {
        setState(() {
          _birthDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          _calculateAge();
        });
      }
    }
  }

  void _calculateAge() {
    if (_birthDateTime == null) return;

    final now = DateTime.now();
    Duration diff = now.difference(_birthDateTime!);

    int days = diff.inDays;
    int years = days ~/ 365;
    int remainingDays = days % 365;
    int months = remainingDays ~/ 30;
    int finalDays = remainingDays % 30;

    setState(() {
      _resultUmur = '''
Usiamu adalah:
$years Tahun, $months Bulan, dan $finalDays Hari
      ''';
      _showResultUmur = true;
      _animationController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 247, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 247, 255),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 14, 49, 107)),
          onPressed: () => Navigator.pop(context),
        ),
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
          Align(
            alignment: Alignment(0, -0.6),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Container(
                    child: Image.asset("asset/logo.png"),
                    alignment: Alignment.centerRight,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'KONVERSI WAKTU',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubikMonoOne(
                      fontSize: 28,
                      color: Color.fromARGB(255, 14, 49, 107),
                    ),
                  ),
                  SizedBox(height: 20),
                  TabBar(
                    controller: _tabController,
                    labelColor: Color.fromARGB(255, 14, 49, 107),
                    indicatorColor: Color.fromARGB(255, 255, 221, 77),
                    tabs: [
                      Tab(text: "Konversi Tahun"),
                      Tab(text: "Hitung Usia"),
                    ],
                  ),
                  SizedBox(
                    height: 480,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildKonversiTahunTab(),
                        _buildHitungUsiaTab(),
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
              labelText: 'Contoh: 2 atau 2,5',
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

  Widget _buildHitungUsiaTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20),
        Text(
          'Pilih tanggal:',
          style: GoogleFonts.inriaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 14, 49, 107),
          ),
        ),
        SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _pickBirthDateTime,
          icon: Icon(Icons.cake),
          label: Text('Pilih Tanggal'),
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
        _showResultUmur
            ? FadeTransition(
          opacity: _animation,
          child: _buildResultCard(_resultUmur),
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

/// ✅ Custom formatter untuk angka ribuan + koma desimal (1.234,5)
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
