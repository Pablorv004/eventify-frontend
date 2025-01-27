import 'package:eventify/providers/event_provider.dart';
import 'package:eventify/widgets/dialogs/_show_marker_event_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentLocation;
  bool _isLoading = true;
  bool _permissionDenied = false;
  List<Marker> _eventMarkers = [];
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _initializeLocationAndLoadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/no-filter-events-background-image.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Widgets inside SingleChildScrollView
          Padding(
            padding: const EdgeInsets.only(top: 120, bottom: 70),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_permissionDenied)
                    Center(
                      child: AlertDialog(
                        title: const Text('Location Permission Denied'),
                        content: const Text('Location permissions are not granted. Please enable them in the settings.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    )
                  else
                    createMapWidget(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center createMapWidget(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FlutterMap(
            options: MapOptions(
              initialCenter: _currentLocation ?? const LatLng(36.512521, -6.278430),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: [
                  // User location marker
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  // Event markers
                  ..._eventMarkers,
                ],
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeLocationAndLoadMarkers() async {
    Location location = Location();
    await location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );
    await _fetchUserLocation(location);

    if (_currentLocation != null) {
      // ignore: use_build_context_synchronously
      final eventProvider = context.read<EventProvider>();
      await eventProvider.fetchEventsWithinRadius(_currentLocation!, 2.0);

      if (mounted) {
        setState(() {
          _eventMarkers = eventProvider.eventListByRadius.map((event) {
            return Marker(
              point: LatLng(event.latitude!, event.longitude!),
              child: Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    showMarkerEventDialogInfo(context, event, (LatLng eventLocation, String travelMode) {
                      _drawRouteToEvent(eventLocation, travelMode);
                    });
                  },
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
              ),
            );
          }).toList();
        });
      }
    }
  }

  Future<void> _fetchUserLocation(Location location) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        if (mounted) {
          setState(() {
            _permissionDenied = true;
            _isLoading = false;
          });
        }
        return;
      }
    }

    final userLocation = await location.getLocation();
    if (mounted) {
      setState(() {
        _currentLocation = LatLng(userLocation.latitude!, userLocation.longitude!);
        _isLoading = false;
      });
    }
  }

  Future<void> _drawRouteToEvent(LatLng eventLocation, String travelMode) async {
    var apiKey = dotenv.env['ORS_KEY'];
    final start = '${_currentLocation!.longitude},${_currentLocation!.latitude}';
    final end = '${eventLocation.longitude},${eventLocation.latitude}';
    final url = 'https://api.openrouteservice.org/v2/directions/$travelMode?api_key=$apiKey&start=$start&end=$end';

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates = data['features'][0]['geometry']['coordinates'];
      final summary = data['features'][0]['properties']['summary'];
      final distance = (summary['distance'] / 1000).toStringAsFixed(2); // in km
      final duration = (summary['duration'] / 60).toStringAsFixed(0); // in minutes

      setState(() {
        _routePoints = coordinates.map<LatLng>((coord) => LatLng(coord[1], coord[0])).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Distance: $distance km, Duration: $duration minutes'),
          backgroundColor: Colors.blue,
          duration: const Duration(days: 1),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } else {
      // Handle error
    }
  }
}
