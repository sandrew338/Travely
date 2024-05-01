import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:travely/model/nearby_response.dart';

class NearByPlacesScreen extends StatefulWidget {
  const NearByPlacesScreen({Key? key}) : super(key: key);

  @override
  State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearByPlacesScreen> {

  String radius = "100";
  double latitude = 49.8401193;
  double longitude = 24.0245918;
  String  PLACES_API_KEY = 'AIzaSyCTa7obRMkWaWr7Ma4wlAEPieccmHIFZNE';
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

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
            ElevatedButton(onPressed: (){

              getNearbyPlaces();

            }, child: const Text("Get Nearby Places")),

            if(nearbyPlacesResponse.results != null)
              for(int i = 0 ; i < nearbyPlacesResponse.results!.length; i++)
                  nearbyPlacesWidget(nearbyPlacesResponse.results![i])
          ],
        ),
      ),
    );
  }

  void getNearbyPlaces() async {

    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' + latitude.toString() + ','
    + longitude.toString() + '&radius=' + radius + '&key=' + PLACES_API_KEY
    );

    var response = await http.post(url);

    nearbyPlacesResponse = NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});

  }
// Image getImage(photoReference) {
//     final baseUrl = "https://maps.googleapis.com/maps/api/place/photo";
//     final maxWidth = "400";
//     final maxHeight = "200";
//     final url = "$baseUrl?maxwidth=$maxWidth&maxheight=$maxHeight&photoreference=$photoReference&key=$PLACES_API_KEY";
//     return Image.network(url);
//   }
  
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

// Method to construct the URL for fetching photos
String getImageUrl(String photoReference) {
  final baseUrl = "https://maps.googleapis.com/maps/api/place/photo";
  final maxWidth = "400";
  final maxHeight = "200";
  final url =
      "$baseUrl?maxwidth=$maxWidth&maxheight=$maxHeight&photoreference=$photoReference&key=$PLACES_API_KEY";
  return url;
}
}