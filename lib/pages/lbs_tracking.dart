import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LBSTrackingPage extends StatefulWidget {
  const LBSTrackingPage({super.key});

  @override
  State<LBSTrackingPage> createState() => _LBSTrackingPageState();
}

class _LBSTrackingPageState extends State<LBSTrackingPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition; // GPS
  Position? _lbsPosition; // LBS disimulasikan
  double? _distanceInMeters;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi tidak aktif');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Izin lokasi ditolak permanen');
    }

    // ✅ GPS: Akurasi tinggi
    Position gps = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // ✅ LBS: Akurasi rendah
    Position lbs = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    double distance = Geolocator.distanceBetween(
      gps.latitude,
      gps.longitude,
      lbs.latitude,
      lbs.longitude,
    );

    setState(() {
      _currentPosition = gps;
      _lbsPosition = lbs;
      _distanceInMeters = distance;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(gps.latitude, gps.longitude),
      16,
    ));
  }


  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF2F7FF);
    const darkBlue = Color(0xFF0A2E5C);
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 242, 247, 255),
      body: Stack(
        children: [
          // background ombak kuning
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
                    'LBS Tracking',
                    style: GoogleFonts.rubikMonoOne(
                      fontSize: 26,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ✅ FIXED Google Map
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: screenHeight * 0.35,
                      child: _currentPosition == null
                          ? const Center(child: CircularProgressIndicator())
                          : GoogleMap(
                        onMapCreated: (controller) =>
                        _mapController = controller,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          ),
                          zoom: 16,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        markers: {
                          Marker(
                            markerId: const MarkerId('gpsLocation'),
                            position: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            infoWindow: const InfoWindow(title: 'Lokasi GPS'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueBlue),
                          ),
                          if (_lbsPosition != null)
                            Marker(
                              markerId: const MarkerId('lbsLocation'),
                              position: LatLng(
                                _lbsPosition!.latitude,
                                _lbsPosition!.longitude,
                              ),
                              infoWindow: const InfoWindow(
                                  title: 'Lokasi LBS (estimasi)'),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueOrange),
                            ),
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ✅ SCROLLABLE INFO
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 16),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_currentPosition != null)
                                Text(
                                  "📍 Lokasi GPS (akurasi tinggi):\nLatitude: ${_currentPosition!
                                      .latitude.toStringAsFixed(5)}, "
                                      "Longitude: ${_currentPosition!.longitude
                                      .toStringAsFixed(5)}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              const SizedBox(height: 8),
                              if (_lbsPosition != null)
                                Text(
                                  "📍 Lokasi LBS (estimasi kasar):\nLatitude: ${_lbsPosition!
                                      .latitude.toStringAsFixed(5)}, "
                                      "Longitude: ${_lbsPosition!.longitude
                                      .toStringAsFixed(5)}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              const SizedBox(height: 8),
                              if (_distanceInMeters != null)
                                Text(
                                  "📏 Selisih lokasi GPS dan LBS: ${_distanceInMeters!
                                      .toStringAsFixed(2)} meter",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              const SizedBox(height: 8),
                              const Divider(),
                              const Text(
                                "* GPS = posisi berdasarkan satelit (akurasi tinggi)",
                                style: TextStyle(
                                    fontSize: 13, fontStyle: FontStyle.italic),
                              ),
                              const Text(
                                "* LBS = posisi estimasi via sinyal seluler/WiFi",
                                style: TextStyle(
                                    fontSize: 13, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
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
}

