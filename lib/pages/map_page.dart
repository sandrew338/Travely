// ignore_for_file: library_private_types_in_public_api

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
  List<Results> resultPoints  = [];
  late GoogleMapController _controller;
  TextEditingController _locationController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  LatLng sourceLocation = LatLng(0.0, 0.0);
  LatLng destinationLocation = LatLng(0.0, 0.0);
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
      drawer: SideMenu(onItemTapped: widget.onItemTapped),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (controller) {},
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
                      decoration: const InputDecoration(
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
                  const Padding(
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
                _generateRoutes().then((_) {
                  _showRoutesBottomSheet();
                });

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
      if (!(destinationLocation.latitude == 0.0 &&
          destinationLocation.longitude == 0.0)) {
        route.add(destinationLocation);
      }

      routes.add(route);
    }
  }

  void _showRoutesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Routes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: routes.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('Route ${index + 1}'),
                              onTap: () {
                                _showRoutePoints(routes[index], index);
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

  void _showRoutePoints(List<LatLng> route, int routeIndex) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Route Points',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: route.length,
                      itemBuilder: (context, index) {
                        String imageUrl = getPlacePhotoUrl(
                            resultPoints[index].photoReference);
                        return ListTile(
                          leading: imageUrl.isNotEmpty
                              ? Image.network(imageUrl,
                                  width: 50, height: 50, fit: BoxFit.cover)
                              : null,
                          title: Text(
                              resultPoints[index].name ?? 'Unnamed Place'),
                          onTap: () {
                            Navigator.pop(context);
                            _showRoute(route);
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
      },
    );
  }

  String getPlacePhotoUrl(String? photoReference) {
    if (photoReference == null || photoReference.isEmpty) return '';
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$google_api_key';
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
          polylineId: const PolylineId('excursionRoad'),
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

    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&types=$typesParameter&key=$google_api_key');

    var response = await http.post(url);
    nearbyPlacesResponse.clearResults();
    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    // Запит на отримання назв місць
    for (var result in nearbyPlacesResponse.results!) {
      if (result.name == null) {
        String placeId = result.placeId!;
        String placeDetailUrl =
            'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name&key=$google_api_key';
        var detailResponse = await http.get(Uri.parse(placeDetailUrl));
        var placeDetail = jsonDecode(detailResponse.body);
        result.name = placeDetail['result']['name'];
      }
    }

    setState(() {});
  }

  Future<void> getNearbyPlaces() async {
    longitude = sourceLocation.longitude;
    latitude = sourceLocation.latitude;

    await getresponse();

    for (var result in nearbyPlacesResponse.results!) {
      double? lat = result.geometry?.location?.lat;
      double? lng = result.geometry?.location?.lng;
      String? placeId = result.placeId;
      String? photoReference = result.photoReference;

      if (lat != null && lng != null && placeId != null) {
        Results place = Results(
          geometry: result.geometry,
          placeId: placeId,
          name: result.name,
          photoReference: photoReference,
        );
        await place.fetchPlaceDetails();
        points.add(LatLng(lat, lng));
        resultPoints.add(place);
      }
    }

    setState(() {});
  }

  Future<void> drawExcursionRoad(List<LatLng> points) async {
    List<LatLng> excursionRoad = await _findExcursionRoad(points);
    setState(() {
      polylines.add(Polyline(
        polylineId: const PolylineId('excursionRoad'),
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
  String? name;
  String? placeId;
  String? photoReference;

  Results({this.geometry, this.name, this.placeId, this.photoReference});

  Results.fromJson(Map<String, dynamic> json) {
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    name = json['name'];
    placeId = json['place_id'];
    if (json['photos'] != null && json['photos'].isNotEmpty) {
      photoReference = json['photos'][0]['photo_reference'];
    }
  }

  Future<void> fetchPlaceDetails() async {
    // Fetch additional details like photo, etc.
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
