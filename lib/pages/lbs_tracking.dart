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

  LocationAccuracy _selectedAccuracy = LocationAccuracy.high;
  final Map<String, LocationAccuracy> accuracyOptions = {
    'Low': LocationAccuracy.low,
    'Medium': LocationAccuracy.medium,
    'High': LocationAccuracy.high,
  };

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  Future<void> _initializeTracking() async {
    await _getInitialGPSPosition();
    await _updateLBSPosition();
  }

  Future<void> _getInitialGPSPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi tidak aktif');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Izin lokasi ditolak permanen');
    }

    Position gps = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: false,
    );

    setState(() {
      _currentPosition = gps;
    });
  }

  Future<void> _updateLBSPosition() async {
    if (_currentPosition == null) return;

    Position lbs = await Geolocator.getCurrentPosition(
      desiredAccuracy: _selectedAccuracy,
      forceAndroidLocationManager: true,
    );

    double distance = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      lbs.latitude,
      lbs.longitude,
    );

    setState(() {
      _lbsPosition = lbs;
      _distanceInMeters = distance;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      16,
    ));
  }

  Future<void> _refreshPositions() async {
    await _initializeTracking();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF2F7FF);
    const darkBlue = Color(0xFF0A2E5C);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
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
                    'LBS Tracking',
                    style: GoogleFonts.rubikMonoOne(
                      fontSize: 26,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tingkat Akurasi:",
                        style: TextStyle(fontSize: 16),
                      ),
                      DropdownButton<LocationAccuracy>(
                        value: _selectedAccuracy,
                        items: accuracyOptions.entries.map((entry) {
                          return DropdownMenuItem<LocationAccuracy>(
                            value: entry.value,
                            child: Text(entry.key),
                          );
                        }).toList(),
                        onChanged: (newAccuracy) async {
                          if (newAccuracy != null) {
                            _selectedAccuracy = newAccuracy;
                            await _updateLBSPosition();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: screenHeight * 0.35,
                      child: _currentPosition == null
                          ? const Center(child: CircularProgressIndicator())
                          : GoogleMap(
                        onMapCreated: (controller) => _mapController = controller,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          ),
                          zoom: 16,
                        ),
                        myLocationEnabled: false,
                        myLocationButtonEnabled: true,
                        markers: {
                          Marker(
                            markerId: const MarkerId('gpsLocation'),
                            position: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            infoWindow: const InfoWindow(title: 'Lokasi GPS'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                          ),
                          if (_lbsPosition != null)
                            Marker(
                              markerId: const MarkerId('lbsLocation'),
                              position: LatLng(
                                _lbsPosition!.latitude,
                                _lbsPosition!.longitude,
                              ),
                              infoWindow: const InfoWindow(title: 'Lokasi LBS (estimasi)'),
                              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                            ),
                        },
                        polylines: _lbsPosition == null
                            ? {}
                            : {
                          Polyline(
                            polylineId: const PolylineId('distanceLine'),
                            color: Colors.green.shade700,
                            width: 4,
                            points: [
                              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                              LatLng(_lbsPosition!.latitude, _lbsPosition!.longitude),
                            ],
                          ),
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_currentPosition != null && _lbsPosition != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.location_pin, color: Colors.blue, size: 20),
                              SizedBox(width: 4),
                              Text("GPS", style: TextStyle(fontSize: 14)),
                              SizedBox(width: 16),
                              Icon(Icons.location_pin, color: Colors.orange, size: 20),
                              SizedBox(width: 4),
                              Text("LBS", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Garis hijau menunjukkan jarak antara GPS dan LBS",
                            style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshPositions,
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
                                    "📍 Lokasi GPS (akurasi tinggi):\nLatitude: ${_currentPosition!.latitude.toStringAsFixed(5)}, "
                                        "Longitude: ${_currentPosition!.longitude.toStringAsFixed(5)}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                const SizedBox(height: 8),
                                if (_lbsPosition != null)
                                  Text(
                                    "📍 Lokasi LBS (estimasi kasar):\nLatitude: ${_lbsPosition!.latitude.toStringAsFixed(5)}, "
                                        "Longitude: ${_lbsPosition!.longitude.toStringAsFixed(5)}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                const SizedBox(height: 8),
                                if (_distanceInMeters != null)
                                  Text(
                                    "📏 Selisih lokasi GPS dan LBS: ${_distanceInMeters!.toStringAsFixed(2)} meter",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                const SizedBox(height: 8),
                                const Divider(),
                                const Text(
                                  "* GPS = posisi berdasarkan satelit (akurasi tinggi)",
                                  style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                                ),
                                const Text(
                                  "* LBS = posisi estimasi via sinyal seluler/WiFi",
                                  style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
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
            ),
          ),
        ],
      ),
    );
  }
}
