import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/header_section.dart';
import '../widgets/image_carousel.dart';
import '../widgets/action_button.dart';
import '../widgets/navigation_bar.dart' as custom_nav;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MapController _mapController;
  late YoutubePlayerController _videoController;
  final LatLng _campusLocation = LatLng(1.8640316599968476, 103.08943299016023);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    //initialize video controller
    _videoController = YoutubePlayerController(
      initialVideoId: 'pISGyWVee88', 
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
   );
   /*WidgetsBinding.instance.addPostFrameCallback((_) {
    _recenterMap(); // Center the map once the widget is built
  });*/
  }

  void _recenterMap() {
    _mapController.move(_campusLocation, 16.0);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const HeaderSection(),
              const ImageCarousel(),
              const SizedBox(height: 36),
              const Text(
                'Ready to take a ride?',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const ActionButton(),
              const SizedBox(height: 20),
              const Text(
                'UTHM Parit Raja Map',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _campusLocation,
                          initialZoom: 16.0,
                          minZoom: 10.0,
                          maxZoom: 18.0,
                        ),
                        children: [
                          TileLayer(
                            //urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            //subdomains: ['a', 'b', 'c'],
                            urlTemplate: "https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=Pebs1VO28jPqw8YoANcH",
                            userAgentPackageName: 'com.example.unibike',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _campusLocation,
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    right: 16,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: _recenterMap,
                      child: Icon(Icons.center_focus_strong),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Rent a bike to tour the campus!',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: _videoController != null
                    ? YoutubePlayer(
                        controller: _videoController,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blueAccent,
                      )
                    : CircularProgressIndicator(),
              ),
              const SizedBox(height: 39),
            ],
          ),
        ),
      ),
      bottomNavigationBar: custom_nav.NavigationBar(
        currentIndex: 0,
        onTabSelected: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/booking');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/notification');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ), 
    );
  }
}