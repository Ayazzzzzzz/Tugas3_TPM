import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  const StopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StopwatchPage(),
    );
  }
}

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  late Stopwatch _stopwatch;
  Timer? _timer;
  List<LapTime> _lapTimes = [];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  void _startStopwatch() {
    _stopwatch.start();
    _startTimer();
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    _lapTimes.clear();
    _stopStopwatch();
    setState(() {});
  }

  void _addLap() {
    final current = _stopwatch.elapsed;
    final lapTime = _lapTimes.isEmpty ? current : current - _lapTimes.last.totalTime;
    setState(() {
      _lapTimes.add(LapTime(
        lapNumber: _lapTimes.length + 1,
        lapTime: lapTime,
        totalTime: current,
      ));
    });
  }

  String _format(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes % 60);
    final seconds = twoDigits(d.inSeconds % 60);
    final ms = (d.inMilliseconds % 1000).toString().padLeft(3, '0').substring(0, 2);

    return "$hours:$minutes:$seconds.$ms";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF2F7FF);
    const darkBlue = Color(0xFF0A2E5C);
    const blue = Color(0xFF0B47A1);
    const yellow = Color(0xFFFFCE63);
    const softRed = Color(0xFFE36D6D);

    final elapsed = _stopwatch.elapsed;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background ombak di bawah
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
                        icon: Icon(Icons.arrow_back, color: darkBlue),
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
                    'Detik Dalam Diam',
                    style: GoogleFonts.rubikMonoOne(
                      fontSize: 27,
                      color: darkBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Waktu utama
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: _format(elapsed).split('.')[0],
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                        children: [
                          TextSpan(
                            text: ".${_format(elapsed).split('.')[1]}",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.normal,
                              color: darkBlue,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol kontrol
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(
                        label: "Putaran",
                        color: darkBlue,
                        onPressed: _stopwatch.isRunning ? _addLap : null,
                      ),
                      const SizedBox(width: 12),
                      _buildButton(
                        label: _stopwatch.isRunning ? "Berhenti" : "Mulai",
                        color: _stopwatch.isRunning ? softRed : blue,
                        onPressed: _stopwatch.isRunning ? _stopStopwatch : _startStopwatch,
                      ),
                      const SizedBox(width: 12),
                      _buildButton(
                        label: "Reset",
                        color: yellow,
                        textColor: darkBlue,
                        onPressed: _resetStopwatch,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(thickness: 1),

                  // Daftar putaran
                  Expanded(
                    child: ListView.builder(
                      itemCount: _lapTimes.length,
                      itemBuilder: (context, index) {
                        final lap = _lapTimes[_lapTimes.length - 1 - index];
                        return ListTile(
                          dense: true,
                          title: Text(
                            "Putaran ${lap.lapNumber.toString().padLeft(2, '0')}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Waktu lap: ${_format(lap.lapTime)}"),
                              Text("Keseluruhan: ${_format(lap.totalTime)}"),
                            ],
                          ),
                        );
                      },
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


  Widget _buildButton({
    required String label,
    required Color color,
    VoidCallback? onPressed,
    Color textColor = Colors.white,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        elevation: 4,
      ),
      child: Text(label),
    );
  }
}

class LapTime {
  final int lapNumber;
  final Duration lapTime;
  final Duration totalTime;

  LapTime({
    required this.lapNumber,
    required this.lapTime,
    required this.totalTime,
  });
}
