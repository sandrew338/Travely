import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:travely/components/constans.dart';
import 'package:travely/components/filter_search.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;

  TextEditingController _locationController =
      TextEditingController(); // Define location controller
  TextEditingController _destinationController =
      TextEditingController(); // Define destination controller

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
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
                    onPressed: () {},
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
        return FilterSearch(
          onFilterChanged: (filters, newRadius) {
            setState(() {
              selectedFilters = filters;
              radius = newRadius;
            });
            Navigator.pop(context); // Close the modal
            
            // After getting nearby places, generate routes and show bottom sheet
              getNearbyPlaces();
             _generateRoutes();
             _showRoutesBottomSheet(); 
          },
          initialFilters: selectedFilters,
          initialRadius: radius,
        );
      },
    );
  }
  void _generateRoutes() {
  // Clear previous routes
  routes.clear();
  
  // Generate 5 routes
  for (int i = 0; i < 5; i++) {
    List<LatLng> route = [];
    // Randomly select 10 points from the nearby places
    for (int j = 0; j < 10; j++) {
      int randomIndex = Random().nextInt(points.length);
      route.add(points[randomIndex]);
    }
    routes.add(route);
  }
}
  void _showRoutesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Routes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: routes.length,
                  itemBuilder: (context, index) {
                    // Build each route item here
                    return ListTile(
                      title: Text('Route ${index + 1}'),
                      onTap: () {
                        _showRoute(routes[index]); // Show the selected route on map
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRoute(List<LatLng> route) {
    setState(() {
      markers.clear();
      polylines.clear();
      for (int i = 0; i < route.length; i++) {
        markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: route[i],
          infoWindow:InfoWindow(title: 'Point ${i + 1}'),
        ));
      }
      polylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: route,
        color: Colors.blue,
        width: 5,
      ));
    });
  }

  Future<void> getresponse() async {
    List<String> placeTypes = selectedFilters;
    String typesParameter = placeTypes.join('|');
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

    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});
  }

  List<LatLng> getNearbyPlaces() {
  markers.clear();
  polylines.clear();
  getresponse(); // Assuming getresponse() is a synchronous method

  
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

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      points.add(LatLng(latitude, longitude));
    }
    return points;
  }

  void _onLocationChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_locationController.text.isNotEmpty) {
        _getSuggestions(_locationController.text, true);
      }
    });
  }

  void _onDestinationChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_destinationController.text.isNotEmpty) {
        _getSuggestions(_destinationController.text, false);
      }
    });
  }

  void _getSuggestions(String text, bool isLocation) {
    // Implement your suggestions logic here
  }
}

class NearbyPlacesResponse {
  List<NearbyPlace>? results;

  NearbyPlacesResponse({this.results});

  NearbyPlacesResponse.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results!.add(NearbyPlace.fromJson(v));
      });
    }
  }
}

class NearbyPlace {
  Geometry? geometry;

  NearbyPlace({this.geometry});

  NearbyPlace.fromJson(Map<String, dynamic> json) {
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





