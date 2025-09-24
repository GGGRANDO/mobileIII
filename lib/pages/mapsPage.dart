import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../services/themeProvider.dart';
import '../routes.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  static const LatLng _upfLatLng = LatLng(-28.232667, -52.381083);

  final MapController _mapController = MapController();

  void _recenter() {
    _mapController.move(_upfLatLng, 18); 
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa (OpenStreetMap)'),
        backgroundColor: theme.appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.home),
        ),
        actions: [
          IconButton(
            tooltip: 'Centralizar na UPF',
            icon: const Icon(Icons.center_focus_strong),
            onPressed: _recenter,
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: _upfLatLng,
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'login',
          ),

          MarkerLayer(
            markers: const [
              Marker(
                point: _upfLatLng,
                width: 48,
                height: 48,
                child: Icon(
                  Icons.location_on,
                  size: 48,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    '© OpenStreetMap contributors (tem que por são mimizento)',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _recenter,
        icon: const Icon(Icons.place),
        label: const Text('Recentralizar'),
      ),
    );
  }
}
