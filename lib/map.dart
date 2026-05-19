import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'api_keys.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("University Campus Map"),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(1.8640209, 103.0895188),
          initialZoom: 17.0,
          minZoom: 15.0,
          maxZoom: 19.0,
        ),
        children: [
          TileLayer(
            //urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            //subdomains: ['a', 'b', 'c'],
            urlTemplate: "https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$mapTilerApiKey",
            userAgentPackageName: 'com.example.unibike',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(1.8640209, 103.0895188),
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                '© MapTiler © OpenStreetMap Contributors',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.zoom_in),
            onPressed: () {
              _mapController.move(
                _mapController.camera.center, 
                _mapController.camera.zoom + 1
              );
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            child: Icon(Icons.zoom_out),
            onPressed: () {
              _mapController.move(
                _mapController.camera.center, 
                _mapController.camera.zoom - 1
              );
            },
          ),
        ],
      ),
    );
  }
}