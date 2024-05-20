/*import 'dart:convert';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:travely/model/nearby_response.dart';
//import 'package:url_launcher/url_launcher_string.dart';

class NearByPlacesScreen extends StatefulWidget {
  const NearByPlacesScreen({super.key});

  @override
  State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearByPlacesScreen> {
  String locationMessage = '';
  String apiKey = "AIzaSyCTa7obRMkWaWr7Ma4wlAEPieccmHIFZNE";
  String radius = "1000";
  //double latitude = 49.8401193;
  //double longitude = 24.0245918;
  double latitude = 49.8401193;
  double longitude = 24.0245918;
  late String lat;
  late String long;
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  Future<Position> _getCurrentLocation() async{
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled){
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied){
        return Future.error('Location permissions are denied');
      }
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error('error');
    }

    return await Geolocator.getCurrentPosition();
  }

void _liveLocation() {
  LocationSettings locationSettings = const LocationSettings(
     accuracy: LocationAccuracy.high,
     distanceFilter: 100,     
  );

  Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
          lat = position.latitude.toString();
          long = position.longitude.toString();
          latitude = position.latitude;
          longitude = position.longitude;

          setState((){
            locationMessage = 'Latitude: $lat, Longitude: $long';
          });

        });
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Nearby Places'),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: (){
              getNearbyPlaces();
            },
            child: const Text("Get Nearby Places"),
          ),
          ElevatedButton(
            onPressed: (){
              _getCurrentLocation().then((value){
                lat = '${value.latitude}';
                long = '${value.longitude}';
                setState((){
                  locationMessage = 'Latitude: $lat, Longitude: $long';
                });
                _liveLocation();
              });
            },
            child: const Text("Get Your Location", textAlign: TextAlign.center),
          ),
          // Display locationMessage here
          Text(locationMessage),
          
          if(nearbyPlacesResponse.results != null)
            for(int i = 0 ; i < nearbyPlacesResponse.results!.length; i++)
              nearbyPlacesWidget(nearbyPlacesResponse.results![i])
        ],
      ),
    ),
  );
}


void getNearbyPlaces() async {
    latitude += 0.01;
    longitude += 0.01;
    List<String> placeTypes = (["restaurant", "church", "park", "museum", "cafe", "gym", "store"]);
    String typesParameter = placeTypes.join('|');
    var url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&types=$typesParameter&key=$apiKey');

    var response = await http.post(url);

    nearbyPlacesResponse = NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});

  }

  String getImageUrl(String photoReference) {
  final baseUrl = "https://maps.googleapis.com/maps/api/place/photo";
  final maxWidth = "400";
  final maxHeight = "200";
  final url =
      "$baseUrl?maxwidth=$maxWidth&maxheight=$maxHeight&photoreference=$photoReference&key=$apiKey";
  return url;
}
//   Widget nearbyPlacesWidget(Results results) {
//   return Container(
//     width: MediaQuery.of(context).size.width,
//     margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
//     padding: const EdgeInsets.all(5),
//     decoration: BoxDecoration(
//       border: Border.all(color: Colors.black),
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Name: " + results.name!),
//         Text("Location: " +
//             results.geometry!.location!.lat.toString() +
//             " , " +
//             results.geometry!.location!.lng.toString()),
//         Text(results.openingHours != null ? "Open" : "Closed"),
//         SizedBox(height: 10),
//         // Displaying photos if available
//         if (results.photos != null)
//           SizedBox(
//             height: 100,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: results.photos!.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: SizedBox(
//                     width: 100,
//                     child: Image.network(
//                       getImageUrl(results.photos![index].photoReference!),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//       ],
//     ),
//   );
// }
// }
Widget nearbyPlacesWidget(Results results) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name: " + results.name!),
        Text("Location: " +
            results.geometry!.location!.lat.toString() +
            " , " +
            results.geometry!.location!.lng.toString()),
        Text(results.openingHours != null ? "Open" : "Closed"),
        SizedBox(height: 10),
        // Displaying photos if available
        if (results.photos != null)
          SizedBox(
            height: 200, // Adjust this height as per your requirement
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: results.photos!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    width: 200, // Adjust this width as per your requirement
                    child: Image.network(
                      getImageUrl(results.photos![index].photoReference!),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
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

class NearByPlacesScreen extends StatefulWidget {
  const NearByPlacesScreen({super.key});

  @override
  State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearByPlacesScreen> {
  late GoogleMapController _controller;
  double latitude = 49.8401193;
  double longitude = 24.0245918;
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Places'),
        centerTitle: true,
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 14.0,
        ),
        markers: markers,
        polylines: polylines,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getNearbyPlaces,
        child: const Icon(Icons.place),
      ),
    );
  }

  void getNearbyPlaces() async {
    markers.clear();
    polylines.clear();

    // Generate 10 points evenly spaced around a circle
    List<LatLng> points =
        generateCircularPoints(10, const LatLng(49.8401193, 24.0245918), 0.005);

    for (var point in points) {
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
      ));
    }

    drawExcursionRoad(points);
  }

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
      LatLng destination =
          points[(i + 1) % points.length]; // Connect back to the first point
      List<LatLng> segmentPoints = await _getDirections(origin, destination);
      excursionRoad.addAll(segmentPoints);
    }
    return excursionRoad;
  }

  Future<List<LatLng>> _getDirections(LatLng origin, LatLng destination) async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=walking&key=$google_api_key';

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
