import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:travely/model/nearby_response.dart';
//import 'package:url_launcher/url_launcher_string.dart';

class NearByPlacesScreen extends StatefulWidget {
  const NearByPlacesScreen({Key? key}) : super(key: key);

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

    nearbyPlacesResponse = NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});

  }

  String getImageUrl(String photoReference) {
  final baseUrl = "https://maps.googleapis.com/maps/api/place/photo";
  final maxWidth = "800";
  final maxHeight = "400";
  final url =
      "$baseUrl?maxwidth=$maxWidth&maxheight=$maxHeight&photoreference=$photoReference&key=$apiKey";
  return url;
}
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
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: results.photos!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    width: 100,
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