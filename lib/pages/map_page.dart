import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travely/components/constans.dart';
import 'package:travely/model/nearby_response.dart';
import 'package:flutter_svg/svg.dart';

class FilterSearch extends StatefulWidget {
  final Function(List<String>, double) onFilterChanged;
  final Function() showRoutesModal;

  const FilterSearch(
      {super.key,
      required this.onFilterChanged,
      required this.showRoutesModal});

  @override
  _FilterSearchState createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  double _currentSliderValue = 1.5;
  final Map<String, bool> _filters = {
    "art gallery": false,
    "museum": false,
    "store": false,
    "church": false,
    "cafe": false,
    "zoo": false,
    "park": false,
    "gym": false,
    "aquarium": false,
  };

  void _applyFilters() {
    List<String> selectedFilters = _filters.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    widget.onFilterChanged(selectedFilters, _currentSliderValue * 1000);
    widget.showRoutesModal(); // Викликаємо функцію showRoutesModal через widget
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 235, 238, 235),
              labelText: 'Enter your location',
              labelStyle: const TextStyle(color: Color(0xFF1C1C1C)),
              prefixIcon: SvgPicture.asset(
                "assets/images/location1.svg",
                height: 30,
                fit: BoxFit.scaleDown,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 235, 238, 235),
              labelText: 'Destination (optional)',
              labelStyle: const TextStyle(color: Color(0xFF1C1C1C)),
              prefixIcon: SvgPicture.asset(
                "assets/images/right_arrow.svg",
                height: 30,
                fit: BoxFit.scaleDown,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'Radius',
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1C1C1C),
                height: 1.495,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          StatefulBuilder(
            builder: (context, state) => Column(
              children: [
                Slider(
                  value: _currentSliderValue,
                  min: 0.0,
                  max: 20.0,
                  divisions: 40,
                  activeColor: const Color(0xFF1C1C1C),
                  label: "${_currentSliderValue.toStringAsFixed(1)} km",
                  onChanged: (val) {
                    state(() {
                      _currentSliderValue = val;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        '${_currentSliderValue.toStringAsFixed(1)} km',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'Select type',
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1C1C1C),
                height: 1.495,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: _filters.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                activeColor: const Color(0xFF1C1C1C),
                checkColor: Colors.white,
                value: _filters[key],
                onChanged: (bool? value) {
                  setState(() {
                    _filters[key] = value!;
                  });
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  _applyFilters();
                  //widget.onFilterChanged([], 0.0);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF1C1C1C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('OK'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onFilterChanged([], 0.0);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('CANCEL'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  String apiKey = google_api_key; // Replace with your Google API key
  double latitude = 49.8401193;
  double longitude = 24.0245918;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  List<String> selectedFilters = [];
  double radius = 1000;

  void _showRoutesModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: 5, // Assuming you have a list of 5 routes
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Route ${index + 1}'),
                onTap: () {
                  _showRoutePoints(index); // Show points for the selected route
                },
              );
            },
          ),
        );
      },
    );
  }

  void _showRoutePoints(int routeIndex) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        // Assuming you have a list of points for each route
        List<LatLng> routePoints = []; // Fetch points for the selected route

        // Print route points for debugging
        print('Route Points: $routePoints');

        if (routePoints.isEmpty) {
          return const Center(
            child: Text('No points found for this route.'),
          );
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: routePoints.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Point ${index + 1}'),
                onTap: () {
                  // Handle tapping on a point if needed
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Search'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _openFilterModal(),
          ),
        ],
      ),
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
            top: 80,
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
                  const Expanded(
                    child: TextField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        hintText: "Search...",
                      ),
                    ),
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
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterSearch(
          onFilterChanged: (filters, newRadius) {
            setState(() {
              selectedFilters = filters;
              radius = newRadius;
            });
            getNearbyPlaces();
            Navigator.pop(context); // Close the modal
          },
          showRoutesModal: _showRoutesModal, // Передаємо посилання на функцію
        );
      },
    );
  }

  Future<void> getresponse() async {
    List<String> placeTypes = selectedFilters;
    String typesParameter = placeTypes.join('|');
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&types=$typesParameter&key=$apiKey');

    var response = await http.post(url);

    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});
  }

  void getNearbyPlaces() async {
    markers.clear();
    polylines.clear();
    await getresponse();

    List<LatLng> points = [];
    for (var result in nearbyPlacesResponse.results!) {
      double? lat = result.geometry?.location?.lat;
      double? lng = result.geometry?.location?.lng;
      if (lat != null && lng != null) {
        points.add(LatLng(lat, lng));
      }
    }

    for (int i = 0; i < points.length; i++) {
      LatLng point = points[i];
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: 'Point ${i + 1}'),
      ));
    }
    await drawExcursionRoad(points);
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
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude}&mode=walking&key=$apiKey';

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
}
