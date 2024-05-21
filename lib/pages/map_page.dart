import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:travely/components/constans.dart';
import 'package:travely/components/filter_search.dart';
import 'package:travely/components/slide_menu.dart';

class MapPage extends StatefulWidget {
  final Function(int) onItemTapped;

  MapPage({required this.onItemTapped});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;
  TextEditingController _locationController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  LatLng sourceLocation = LatLng(0.0, 0.0);
  LatLng destinationLocation = LatLng(0.0, 0.0);
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse(); // Assuming you have this class
  Timer? _debounce;
  double latitude = 49.8401193;
  double longitude = 24.0245918;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> points = [];
  List<String> selectedFilters = [];
  double radius = 1500;
  List<List<LatLng>> routes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(onItemTapped: widget.onItemTapped), // Pass the callback function here
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (controller) {
              _controller = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 14.0,
            ),
            markers: markers,
            polylines: polylines,
          ),
          Positioned(
            top: 30,
            right: 15,
            left: 15,
            height: 55,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(80)),
                color: Color(0xFFFFFFFF),
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    splashColor: Colors.grey,
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        hintText: "Search...",
                      ),
                      onChanged: (value) {
                        _onLocationChanged();
                      },
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/images/filter.svg",
                      height: 30,
                    ),
                    onPressed: () => _openFilterModal(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text('RD'),
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

void _openFilterModal() {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return FilterSearch(
            onFilterChanged: (filters, newRadius, selectedSourceLocation,
                selectedDestinationLocation) {
              setState(() {
                selectedFilters = filters;
                radius = newRadius;
                sourceLocation = selectedSourceLocation;
                destinationLocation = selectedDestinationLocation;
              });
            },
            initialFilters: selectedFilters,
            initialRadius: radius,
            sourceLocation: sourceLocation,
            destinationLocation: destinationLocation,
            onApplyFilters: () {
              Navigator.pop(context);
              // Call the necessary functions after applying filters
              getNearbyPlaces();
              _generateRoutes();
              _showRoutesBottomSheet();

              // Close the filter dialog
              
            },
          );
        },
      );
    },
  );
}

  Future<void> _generateRoutes() async {
    routes.clear();
    for (int i = 0; i < 5; i++) {
      List<LatLng> route = [];
      if (!(sourceLocation.latitude == 0 && sourceLocation.longitude == 0)) {
        route.add(sourceLocation);
      }
      for (int j = 0; j < 8; j++) {
        int randomIndex = Random().nextInt(points.length);
        route.add(points[randomIndex]);
      }
      if (!(sourceLocation.latitude == 0.0 &&
          sourceLocation.longitude == 0.0)) {
        route.add(destinationLocation);
      }

      routes.add(route);
    }
  }

void _showRoutesBottomSheet() {
  showModalBottomSheet(
    context: context,
    isDismissible: true, // Enable swiping up to dismiss the bottom sheet
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Routes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: routes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('Route ${index + 1}'),
                            onTap: () {
                              _showRoute(routes[index]);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}



  void _showRoute(List<LatLng> route) {
  setState(() {
    markers.clear();
    polylines.clear();

    // Add markers for each point in the route
    for (int i = 0; i < route.length; i++) {
      markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: route[i],
        infoWindow: InfoWindow(title: 'Point ${i + 1}'),
      ));
    }

    // Generate excursion road using _findExcursionRoad
    _findExcursionRoad(route).then((excursionRoad) {
      // Add polyline for excursion road
      polylines.add(Polyline(
        polylineId: PolylineId('excursionRoad'),
        points: excursionRoad,
        color: Colors.blue,
        width: 5,
      ));
    });
  });
}

Future<List<LatLng>> _findExcursionRoad(List<LatLng> points) async {
  List<LatLng> excursionRoad = [];
  for (int i = 0; i < points.length; i++) {
    LatLng origin = points[i];
    LatLng destination = points[(i + 1) % points.length];
    List<LatLng> segmentPoints = await _getDirections(origin, destination);
    excursionRoad.addAll(segmentPoints);
  }
  return excursionRoad;
}

  Future<void> getresponse() async {
    List<String> placeTypes = selectedFilters;
    String typesParameter = placeTypes.join('|');
    print(
        'getresponse() | radius: $radius / sourceLocation: $sourceLocation/ destinationLocation: $destinationLocation/ filters $selectedFilters');

    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            latitude.toString() +
            ',' +
            longitude.toString() +
            '&radius=' +
            radius.toString() +
            '&types=' +
            typesParameter +
            '&key=' +
            google_api_key);

    var response = await http.post(url);
    nearbyPlacesResponse.clearResults();
    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});
  }

  List<LatLng> getNearbyPlaces() {
    longitude = sourceLocation.longitude;
    latitude = sourceLocation.latitude;

    getresponse();

    for (var result in nearbyPlacesResponse.results!) {
      double? lat = result.geometry?.location?.lat;
      double? lng = result.geometry?.location?.lng;
      if (lat != null && lng != null) {
        points.add(LatLng(lat, lng));
      }
    }
    return points;
  }

  Future<void> drawExcursionRoad(List<LatLng> points) async {
    List<LatLng> excursionRoad = await _findExcursionRoad(points);
    setState(() {
      polylines.add(Polyline(
        polylineId: PolylineId('excursionRoad'),
        points: excursionRoad,
        color: Colors.blue,
        width: 5,
      ));
    });
  }

  
  Future<List<LatLng>> _getDirections(LatLng origin, LatLng destination) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=walking&key=$google_api_key';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      List<LatLng> points = _decodePolyline(
          decodedResponse['routes'][0]['overview_polyline']['points']);
      return points;
    } else {
      throw Exception('Failed to get directions');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _onLocationChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        latitude = _locationController.text.isEmpty
            ? latitude
            : double.parse(_locationController.text.split(',')[0]);
        longitude = _locationController.text.isEmpty
            ? longitude
            : double.parse(_locationController.text.split(',')[1]);
      });
    });
  }
}

class NearbyPlacesResponse {
  List<Results>? results;
  NearbyPlacesResponse({this.results});

  NearbyPlacesResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }
  void clearResults() {
    results?.clear();
  }
}

class Results {
  Geometry? geometry;

  Results({this.geometry});

  Results.fromJson(Map<String, dynamic> json) {
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
  }
}

class Geometry {
  Location? location;

  Geometry({this.location});

  Geometry.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }
}
