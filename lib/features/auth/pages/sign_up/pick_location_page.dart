import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:free_map/free_map.dart';
class PickLocationPage extends StatefulWidget {
  const PickLocationPage({super.key});

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  final MapController _mapController = MapController();
  LatLng? _selectedPosition;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _selectedPosition = LatLng(position.latitude, position.longitude);
      });
      Future.delayed(Duration(milliseconds: 500),() {
        _mapController.move(_selectedPosition!, 15);
      },);
    }
  }

  void _onTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      _selectedPosition = latlng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختيار الموقع'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_selectedPosition != null) {
                Navigator.pop(context, _selectedPosition);
              }
            },
          )
        ],
      ),
      body: _selectedPosition == null
          ? const Center(child: CircularProgressIndicator())
          : FmMap(
        mapController: _mapController,
        mapOptions: MapOptions(
          initialCenter: _selectedPosition!,
          initialZoom: 15,
          onTap: _onTap,
        ),
        markers: [
          Marker(
            point: _selectedPosition!,
            width: 40,
            height: 40,
            child: const Icon(Icons.location_pin,
                color: Colors.red, size: 40),
          ),
        ],
      ),
    );
  }
}
