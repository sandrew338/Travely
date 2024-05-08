/*
// import 'package:flutter/material.dart';
// import 'package:travely/components/filter_search.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// //import 'package:google_maps/google_maps.dart';

// //import 'dart:ui' as ui;
// //import 'dart:html';

// //import 'package:web/src/dom/html.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   //final Completer<GoogleMapController> _controller = Completer();
//   static const LatLng _pGooglePlex = LatLng(49.8401193, 24.0245918);
//   static const LatLng _pGooglePlex1 = LatLng(49.800000, 24.0200000);
//   late List<Marker> list_of_markers;
//   @override

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//       Stack(
//         children: <Widget>[
//           // Replace this container with your Map widget
//           GoogleMap(
//               initialCameraPosition:
//                   CameraPosition(target: _pGooglePlex, zoom: 14.5),
//               markers: {

//               },
//                   ),
//           Positioned(
//             top: 30,
//             right: 15,
//             left: 15,
//             height: 55,
//             child: Container(
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(80)),
//                 color: Color(0xFFFFFFFF
// ),
//               ),
//               child: Row(
//                 children: <Widget>[
//                   IconButton(
//                     splashColor: Colors.grey,
//                     icon: const Icon(Icons.menu),
//                     onPressed: () {},
//                   ),
//                   const Expanded(
//                     child: TextField(
//                       cursorColor: Colors.black,
//                       keyboardType: TextInputType.text,
//                       textInputAction: TextInputAction.go,
//                       decoration: InputDecoration(
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(horizontal: 15),
//                           hintText: "Search..."),
//                     ),
//                   ),
//                   const FilterSearch(),
//                   const Padding(
//                     padding: EdgeInsets.only(right: 8.0),
//                     child: CircleAvatar(
//                       backgroundColor: Colors.deepPurple,
//                       child: Text('RD'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),

// //child: bottomAppBarContents,
//     );
//   }
// }

// /*Marker(
//                   markerId: MarkerId("source"),
//                   position: _pGooglePlex
//                 ),
//                 Marker(
//                   markerId: MarkerId("destination"),
//                   position: _pGooglePlex1
//                 ),*/
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travely/model/nearby_response.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:flutter/material.dart';
// import 'package:travely/components/filter_search.dart';

// //import 'package:google_maps/google_maps.dart';
class FilterSearch extends StatefulWidget {
  final VoidCallback onFilterPressed; // Callback function
  final VoidCallback
      fetchNearbyPlaces; // Callback function to fetch nearby places

  const FilterSearch({
    Key? key,
    required this.onFilterPressed,
    required this.fetchNearbyPlaces,
  }) : super(key: key);

  @override
  State<FilterSearch> createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  double _currentSliderValue = 0.01;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.grey,
      icon: SvgPicture.asset(
        "assets/images/filter.svg",
        height: 30,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: const EdgeInsets.all(10),
              child: Container(
                height: 380,
                width: 300,
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //where to go
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchBar(
                            leading: SvgPicture.asset(
                              "assets/images/location1.svg",
                              height: 30,
                            ),

                            trailing: <Widget>[
                              Tooltip(
                                  message: 'Enter origin location',
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text("map"),
                                  )),
                            ],
                            hintText: "Enter origin location",
                            //textStyle: MaterialStateProperty,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchBar(
                            leading: SvgPicture.asset(
                              "assets/images/right_arrow.svg",
                              height: 30,
                            ),
                            trailing: <Widget>[
                              Tooltip(
                                  message: '123',
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text("Enter"),
                                  )),
                            ],
                            hintText: '234',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Mileage'),
                    const SizedBox(height: 16.0),
                    // �������� �� �����
                    Slider(
                      value: _currentSliderValue,
                      min: 0,
                      max: 10,
                      divisions: 1000,
                      label: _currentSliderValue.toStringAsFixed(
                          2), // Show value with two decimal places
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Call the callback function to fetch nearby places data
                            widget.fetchNearbyPlaces();
                            // Call the callback function when OK is pressed
                            widget.onFilterPressed();
                          },
                          child: const Text('OK'),
                        ),
                        const SizedBox(width: 70.0),
                        ElevatedButton(
                          onPressed: () {
                            // Handle CANCEL button press
                          },
                          child: const Text('CANCEL'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;
  String apiKey = "AIzaSyBiGQanFXhjlQ5QLTqjrr7OTit6l4W5ZbA";
  
  double latitude = 49.8401193;
  double longitude = 24.0245918;
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
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
                  FilterSearch(
                    // Pass callback function to FilterSearch
                    onFilterPressed: getNearbyPlaces,
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

  void getNearbyPlaces() async {
    markers.clear();
    polylines.clear();

    // Extracting points from nearbyPlacesResponse
    List<LatLng> points = [];
    for (var result in nearbyPlacesResponse.results!) {
      double? lat = result.geometry?.location?.lat;
      double? lng = result.geometry?.location?.lng;
      if (lat != null && lng != null) {
        points.add(LatLng(lat, lng));
      }
    }

    // Add markers for each point
    for (var point in points) {
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
      ));
    }
    drawExcursionRoad(points);
  }

/*
  void getNearbyPlaces() async {
    markers.clear();
    polylines.clear();

    // Generate 10 points evenly spaced around a circle
    List<LatLng> points =
        generateCircularPoints(10, LatLng(49.8401193, 24.0245918), 0.005);

    for (var point in points) {
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
      ));
    }

    drawExcursionRoad(points);
  }*/
/*
  List<LatLng> generateCircularPoints(int count, LatLng center, double radius) {
    List<LatLng> points = [];
    double slice = 2 * pi / count;
    for (int i = 0; i < count; i++) {
      double angle = slice * i;
      double lat = center.latitude + radius * cos(angle);
      double lng = center.longitude + radius * sin(angle);
      points.add(LatLng(lat, lng));
    }
    return points;
   }
*/
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
      LatLng destination =
          points[(i + 1) % points.length]; // Connect back to the first point
      List<LatLng> segmentPoints = await _getDirections(origin, destination);
      excursionRoad.addAll(segmentPoints);
    }
    return excursionRoad;
  }

  Future<List<LatLng>> _getDirections(LatLng origin, LatLng destination) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=walking&key=$apiKey';

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

class SearchBar extends StatelessWidget {
  final String hintText;
  final Widget leading;
  final List<Widget> trailing;

  const SearchBar({
    Key? key,
    required this.hintText,
    required this.leading,
    required this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: leading,
          ),
          Expanded(
            child: TextField(
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                hintText: hintText,
              ),
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
*/
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travely/components/constans.dart';
import 'package:travely/model/nearby_response.dart';
import 'package:flutter_svg/svg.dart';

class FilterSearch extends StatefulWidget {
  final VoidCallback onFilterPressed; // Callback function

  const FilterSearch({
    Key? key,
    required this.onFilterPressed,
  }) : super(key: key);

  @override
  State<FilterSearch> createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  double _currentSliderValue = 0.01;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.grey,
      icon: SvgPicture.asset(
        "assets/images/filter.svg",
        height: 30,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: const EdgeInsets.all(10),
              child: Container(
                height: 380,
                width: 300,
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchBar(
                            hintText: 'Enter your location',
                            hintStyle: MaterialStateProperty.all(
                                const TextStyle(
                                    color: Color(0xFF1C1C1C), fontSize: 16)),
                            constraints: const BoxConstraints(minHeight: 48),
                            leading: SvgPicture.asset(
                              "assets/images/location1.svg",
                              height: 30,
                            ),
                            elevation: const MaterialStatePropertyAll(0),
                            side: MaterialStateProperty.all(const BorderSide(
                                color: Color.fromRGBO(1, 1, 1, 0.1))),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            trailing: [],
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 235, 238, 235)),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchBar(
                            hintText: 'Destination (optional)',
                            hintStyle: MaterialStateProperty.all(
                                const TextStyle(
                                    color: Color(0xFF1C1C1C), fontSize: 16)),
                            constraints: const BoxConstraints(minHeight: 48),
                            leading: SvgPicture.asset(
                              "assets/images/right_arrow.svg",
                              height: 30,
                            ),
                            elevation: const MaterialStatePropertyAll(0),
                            side: MaterialStateProperty.all(const BorderSide(
                                color: Color.fromRGBO(1, 1, 1, 0.1))),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            trailing: [],
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 235, 238, 235)),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Center(
                      child: Text(
                        'Radius',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1C1C1C),
                          height:
                              1.495, // Calculated line height (35.88px / 24px)
                          // The textAlign property is not necessary for a centered text widget
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Slider(
                      value: _currentSliderValue,
                      min: 0,
                      max: 10,
                      divisions: 1000,
                      label: _currentSliderValue.toStringAsFixed(2),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onFilterPressed();
                          },
                          child: const Text('OK'),
                        ),
                        const SizedBox(width: 70.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('CANCEL'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  String radius = "1000";
  String apiKey = google_api_key;
  double latitude = 49.8401193;
  double longitude = 24.0245918;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
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
                  FilterSearch(
                    // Pass callback function to FilterSearch
                    onFilterPressed: getNearbyPlaces,
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

  Future<void> getresponse() async {
    latitude += 0.01;
    longitude += 0.01;
    List<String> placeTypes =
        (["restaurant", "church", "park", "museum", "cafe", "gym", "store"]);
    String typesParameter = placeTypes.join('|');
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            latitude.toString() +
            ',' +
            longitude.toString() +
            '&radius=' +
            radius +
            '&types=' +
            typesParameter +
            '&key=' +
            apiKey);

    var response = await http.post(url);

    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});
  }

  void getNearbyPlaces() async {
    markers.clear();
    polylines.clear();
    getresponse();
    // Extracting points from nearbyPlacesResponse
    List<LatLng> points = [];
    for (var result in nearbyPlacesResponse.results!) {
      double? lat = result.geometry?.location?.lat;
      double? lng = result.geometry?.location?.lng;
      if (lat != null && lng != null) {
        points.add(LatLng(lat, lng));
      }
    }

    // Add markers for each point
    for (var point in points) {
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
      ));
    }
    drawExcursionRoad(points);
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
      LatLng destination =
          points[(i + 1) % points.length]; // Connect back to the first point
      List<LatLng> segmentPoints = await _getDirections(origin, destination);
      excursionRoad.addAll(segmentPoints);
    }
    return excursionRoad;
  }

  Future<List<LatLng>> _getDirections(LatLng origin, LatLng destination) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=walking&key=$apiKey';

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
/*
class SearchBar extends StatelessWidget {
  final String hintText;
  final Widget leading;
  final List<Widget> trailing;

  const SearchBar({
    Key? key,
    required this.hintText,
    required this.leading,
    required this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: leading,
          ),
          Expanded(
            child: TextField(
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                hintText: hintText,
              ),
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
*/