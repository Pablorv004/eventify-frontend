import 'dart:math';

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
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    _initializeLocationAndLoadMarkers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    scaffoldMessenger.hideCurrentSnackBar();
    super.dispose();
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
                  if (_permissionDenied)
                    const Center(
                      child: Text(
                        'Location permissions are not granted.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else if (_isLoading)
                    const Center(child: CircularProgressIndicator())
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
                        Icons.location_history_sharp,
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

    // Configurar precisión e intervalo de ubicación
    await location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    // Verificar si el servicio de ubicación está habilitado
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _permissionDenied = true;
        });
        _showPermissionDeniedDialog();
        return;
      }
    }

    // Verificar permisos de ubicación
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _permissionDenied = true;
        });
        _showPermissionDeniedDialog();
        return;
      }
    }

    // Intentar obtener la ubicación del usuario solo si los permisos fueron concedidos
    try {
      final userLocation = await location.getLocation();

      if (mounted) {
        setState(() {
          Map<String, int> locationCount = {};
          _eventMarkers = eventProvider.eventListByRadius.map((event) {
        String key = '${event.latitude!},${event.longitude!}';
        if (locationCount.containsKey(key)) {
          locationCount[key] = locationCount[key]! + 1;
        } else {
          locationCount[key] = 0;
        }

        int count = locationCount[key]!;
        double angle = count * (360 / (locationCount[key]! + 1));
        double offsetDistance = 0.0001;
        double offsetLat = offsetDistance * cos(angle * pi / 180);
        double offsetLng = offsetDistance * sin(angle * pi / 180);

        return Marker(
          point: LatLng(event.latitude! + offsetLat, event.longitude! + offsetLng),
          child: GestureDetector(
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
        );
          }).toList();
        });
      }
    } on Exception catch (e) {
      debugPrint('Error fetching location: $e');
      _handleLocationError();
    }
  }

  void _handleLocationError() {
    setState(() {
      _isLoading = false;
    });

    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Error obtaining location. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _setEventMarkers(EventProvider eventProvider) {
    Map<String, int> locationCount = {};
    _eventMarkers = eventProvider.eventListByRadius.map((event) {
      String key = '${event.latitude!},${event.longitude!}';
      if (locationCount.containsKey(key)) {
        locationCount[key] = locationCount[key]! + 1;
      } else {
        locationCount[key] = 0;
      }

      double offset = locationCount[key]! * 0.0002;
      return Marker(
        point: LatLng(event.latitude! + offset, event.longitude! + offset),
        child: GestureDetector(
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
      );
    }).toList();
  }

  Future<void> _fetchUserLocation(Location location) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _permissionDenied = true;
        });
        _showPermissionDeniedDialog();
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _permissionDenied = true;
        });
        _showPermissionDeniedDialog();
        return;
      }
    }

    try {
      final userLocation = await location.getLocation();
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(userLocation.latitude!, userLocation.longitude!);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error fetching location: $e');
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      useRootNavigator: true, // Importante para asegurar el contexto correcto
      builder: (context) {
        return AlertDialog(
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
        );
      },
    );
  }

  Future<void> _drawRouteToEvent(LatLng eventLocation, String travelMode) async {
    var apiKey = dotenv.env['ORS_KEY'];
    final start = '${_currentLocation!.longitude},${_currentLocation!.latitude}';
    final end = '${eventLocation.longitude},${eventLocation.latitude}';
    final url = 'https://api.openrouteservice.org/v2/directions/$travelMode?api_key=$apiKey&start=$start&end=$end';

    scaffoldMessenger.hideCurrentSnackBar();

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

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Distance: $distance km, Duration: $duration minutes'),
          backgroundColor: Colors.blue,
          duration: const Duration(days: 1),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              scaffoldMessenger.hideCurrentSnackBar();
              setState(() {
                _routePoints.clear();
              });
            },
          ),
        ),
      );
    } else {
      // Handle error
    }
  }
}
